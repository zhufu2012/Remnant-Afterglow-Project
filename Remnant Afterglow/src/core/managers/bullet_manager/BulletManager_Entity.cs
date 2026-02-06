

using BulletMLLib.SharedProject;
using Godot;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 子弹管理器 - 管理 实体子弹
    /// </summary>
    public partial class BulletManager : Node2D, IBulletManager
    {
        // 物理层定义（按项目实际需求调整）
        private const int BulletLayer = 32;   // 二进制 100000 祝福注释-优化 根据阵营层数，设置子弹所在层， 可以减少子弹碰撞检测
        private const int TargetLayer = 0;    // 二进制 0000

        /// <summary>
        /// 根据数据，生成实体子弹
        /// </summary>
        /// <param name="bulletId">子弹id</param>
        /// <param name="pos">位置</param>
        /// <param name="direction">方向</param>
        /// <param name="targetObject">目标实体</param>
        /// <param name="createObject">实体自身位置</param>
        /// <returns></returns>
        private IBullet CreateEntityBullet(int bulletId, Vector2 pos, float direction,
            BaseObject targetObject, BaseObject createObject)
        {
            BulletData bulletData = ConfigCache.GetBulletData(bulletId);
            var bullet = new EntityBullet(this, bulletData, targetObject, createObject)
            {
                TimeSpeed = timeSpeed,
                Scale = scale,
                Position = pos,
                Direction = direction,
            };
            bullet.Init();
            bullet.InitTopNode(bulletId, _patternCache[bulletData.BulletLabel].RootNode, targetObject, createObject);
            topBulletList.Add(bullet);
            return bullet;
        }

        public IBullet CreateBullet(Bullet parBullet, BaseObject targetObject, BaseObject createObject)
        {
            BulletData bulletData = ConfigCache.GetBulletData(parBullet.BulletId);
            Vector2 pos = parBullet.GetPosition();
            Rid rid = CreateBullet_Physics(parBullet.GetPosition(), parBullet.GetVelocity());
            var bullet = new EntityBullet(this, bulletData, targetObject, createObject)
            {
                TimeSpeed = timeSpeed, // 设置时间速度
                Scale = scale // 设置缩放比例
            };
            bullet.Init();
            // 为非中心对称子弹创建独立的 CanvasItem
            if (!_centerbulletCache.ContainsKey(parBullet.BulletId))
            {
                Rid canvasItem = RenderingServer.CanvasItemCreate();
                RenderingServer.CanvasItemSetParent(canvasItem, GetCanvasItem());
                RenderingServer.CanvasItemSetZIndex(canvasItem, ViewConstant.Bullet_ZIndex);
                bulletCanvasItemDict[rid] = canvasItem;
            }
            bulletDict[rid] = bullet;
            return bullet;
        }

        /// <summary>
        /// 创建子弹 的 物理部分
        /// </summary>
        /// <param name="position"></param>
        /// <param name="velocity"></param>
        private Rid CreateBullet_Physics(Vector2 position, Vector2 velocity)
        {
            Rid bodyRid = PhysicsServer2D.BodyCreate();
            //运动学物体
            //PhysicsServer2D.BodySetMode(bodyRid, PhysicsServer2D.BodyMode.Kinematic);

            // 设置碰撞层（关键修改）
            PhysicsServer2D.BodySetCollisionLayer(bodyRid, BulletLayer);
            PhysicsServer2D.BodySetCollisionMask(bodyRid, TargetLayer); // 只检测目标层

            //Rid shape = PhysicsServer2D.RectangleShapeCreate();
            Rid shape = PhysicsServer2D.CircleShapeCreate();
            PhysicsServer2D.ShapeSetData(shape, 5f);
            PhysicsServer2D.BodyAddShape(bodyRid, shape, new Transform2D(0, position));

            PhysicsServer2D.BodySetSpace(bodyRid, GetWorld2D().Space);
            PhysicsServer2D.BodySetState(bodyRid, PhysicsServer2D.BodyState.LinearVelocity, velocity);

            // 传递正确的索引
            PhysicsServer2D.BodySetForceIntegrationCallback(
                bodyRid,
                new Callable(this, MethodName._OnBodyMoved),
                bodyRid);
            return bodyRid;
        }

        private void _OnBodyMoved(PhysicsDirectBodyState2D state, Rid body)
        {
            if (bulletDict.TryGetValue(body, out var bullet))
            {
                // 强制保持速度
                state.LinearVelocity = bullet.GetVelocity();
                //state.Transform = new Transform2D(0, bullet.GetPosition());
                //bullet.Transform = new Transform2D(0, bullet.GetPosition());
            }
        }


        public override void _ExitTree()
        {
            // 清理资源
            foreach (var info in bulletDict)
            {
                PhysicsServer2D.FreeRid(info.Key);
            }
            RenderingServer.FreeRid(_canvasItem);
        }
    }
}
