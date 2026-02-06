
using BulletMLLib.SharedProject;
using GameLog;
using Godot;
using System.Collections.Generic;
using System.Linq;

namespace Remnant_Afterglow
{

    public partial class BulletManager : Node2D, IBulletManager
    {
        #region 子弹脚本预加载
        /// <summary>
        /// 子弹id与子弹标签的对应关系
        /// </summary>
        private static readonly Dictionary<int, string> bullet_to_label = new();
        /// <summary>
        /// 子弹标签与子弹脚本的对应关系
        /// </summary>
        private static readonly Dictionary<string, BulletPattern> _patternCache = new();

        /// <summary>
        /// 所有类型的子弹id-图片资源rid 字典
        /// </summary>
        private static readonly Dictionary<int, Rid> _textureCache = new();
        /// <summary>
        /// 子弹id-图片大小
        /// </summary>
        private static readonly Dictionary<int, Vector2> _textureSizeCache = new();

        /// <summary>
        /// 中心对称子弹 的字典-祝福注释-可以改成hashset
        /// </summary>
        private static readonly Dictionary<int, bool> _centerbulletCache = new();


        static BulletManager()
        {
            var bulletDatas = ConfigCache.GetAllBulletData();
            foreach (var data in bulletDatas)
            {
                var pattern = new BulletPattern();
                pattern.ParseXML(data.Logic);
                bullet_to_label[data.BulletId] = data.BulletLabel;
                _patternCache[data.BulletLabel] = pattern;
                Rid rid = data.BulletPng.GetRid();
                _textureSizeCache[data.BulletId] = data.BulletPng.GetSize();
                if (data.IsCenter)
                {
                    _centerbulletCache[data.BulletId] = true;
                }
                _textureCache[data.BulletId] = rid;
            }
        }
        #endregion

        /// <summary>
        /// 时间速度常量，用于控制子弹的时间流逝速度。
        /// </summary>
        private const float timeSpeed = 1.0f;

        /// <summary>
        /// 缩放比例常量，用于控制子弹的大小。
        /// </summary>
        private const float scale = 1.0f;

        /// <summary>
        /// 更新所有子弹的状态。
        /// </summary>
        public void Update()
        {
            AutoAdjustRate();
            ProcessBulletQueue(); // 处理子弹队列
            foreach (var bullet in bulletDict.Values)
            {
                bullet.Update(); // 更新每个普通子弹
            }

            foreach (var bullet in topBulletList)
            {
                bullet.Update(); // 更新每个普通子弹
            }
        }


        /// <summary>
        /// 在每次更新后调用的方法，用于处理额外的逻辑。
        /// </summary>
        public void PostUpdate()
        {
            foreach (var bullet in bulletDict.Values)
            {
                bullet.PostUpdate(); // 更新每个普通子弹
            }
            foreach (var bullet in topBulletList)
            {
                bullet.PostUpdate(); // 更新每个普通子弹
            }
            FreeMovers(); // 释放不再使用的子弹
            EntityDraw();
        }



        /// <summary>
        /// 释放不再使用的子弹。
        /// </summary>
        private void FreeMovers()
        {
            foreach (var info in bulletDict)
            {
                if (!info.Value.Used)
                {
                    bulletDict.Remove(info.Key);
                    PhysicsServer2D.FreeRid(info.Key);
                    // 释放非中心对称子弹的 CanvasItem
                    if (bulletCanvasItemDict.TryGetValue(info.Key, out Rid canvasItemRid))
                    {
                        RenderingServer.FreeRid(canvasItemRid);
                        bulletCanvasItemDict.Remove(info.Key);
                    }
                }
            }
            // 处理顶级子弹
            topBulletList.RemoveAll(b =>
            {
                return b.TasksFinished();
            });
        }


        public Vector2 PlayerPosition(IBullet targettedBullet)
        {
            return new Vector2(0, 0); // 返回玩家的位置-祝福注释
        }

        public void RemoveBullet(IBullet deadBullet)
        {
            if (deadBullet is EntityBullet bullet)
            {
                bullet.Used = false; // 将子弹标记为未使用
            }
        }

        public double Tier()
        {
            return 0.0; // 默认返回0.0，可以根据需要修改
        }
    }
}
