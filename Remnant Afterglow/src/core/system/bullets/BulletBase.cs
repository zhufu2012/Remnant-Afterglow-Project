using Godot;
using System;
using BulletMLLib.SharedProject;
using GameLog;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 子弹类，需要实现IPoolBullet接口
    /// </summary>
    public partial class BulletBase : Bullet, IPoolBullet
    {
        /// <summary>
        /// 标记此子弹是否正在使用中。
        /// </summary>
        private bool used;

        /// <summary>
        /// 子弹的父节点，通常是场景树中的一个节点，用于添加或移除子弹。
        /// </summary>
        public Node2D ParentNode { get; set; }

        /// <summary>
        /// 子弹的实际显示节点，用于在屏幕上渲染子弹。
        /// </summary>
        public Node2D BulletNode { get; set; }

        /// <summary>
        /// 阵营组参数
        /// </summary>
        public string CampSubName;

        #region 子弹配置数据
        /// <summary>
        /// 子弹基础的数据
        /// </summary>
        public BulletData bulletData;
        /// <summary>
        /// 子弹逻辑数据
        /// </summary>
        public BulletLogic bulletLogic;
        /// <summary>
        /// 子弹碰撞数据
        /// </summary>
        public BulletCollide bulletCollide;
        #endregion
        /// <summary>
        /// 构造函数，初始化Mover实例，并设置其管理器。
        /// </summary>
        /// <param name="myBulletManager">管理此子弹的IBulletManager实例。</param>
        public BulletBase(IBulletManager myBulletManager, string BulletLabel, BaseObject baseObject)
            : base(myBulletManager, baseObject)
        {
            this.BulletLabel = BulletLabel;
            bulletData = ConfigCache.GetBulletData(BulletLabel);
            bulletLogic = ConfigCache.GetBulletLogic(BulletLabel);
            bulletCollide = ConfigCache.GetBulletCollide(bulletData.CollideId);
        }



        /// <summary>
        /// 在每次更新后调用的方法，用于处理子弹的情况。
        /// </summary>
        public override void PostUpdate()
        {
            if (CurrFlyDistance >= bulletLogic.MaxDistance)// 检查子弹是否超出最大飞行距离
            {
                Used = false;//将子弹标记为未使用

            }
        }

        /// <summary>
        /// 获取或设置子弹的X坐标位置。
        /// </summary>
        public override float X
        {
            get => Position.X; // 返回子弹的X坐标
            set
            {
                var position = Position; // 获取当前位置
                position.X = value; // 设置新的X坐标
                Position = position; // 更新位置
                // 同步子弹节点的位置
                BulletNode.Position = Position;
            }
        }

        /// <summary>
        /// 获取或设置子弹的Y坐标位置。
        /// </summary>
        public override float Y
        {
            get => Position.Y; // 返回子弹的Y坐标
            set
            {
                var position = Position; // 获取当前位置
                position.Y = value; // 设置新的Y坐标
                Position = position; // 更新位置

                // 同步子弹节点的位置
                BulletNode.Position = Position;
            }
        }

        /// <summary>
        /// 子弹的位置，以Vector2表示。
        /// </summary>
        public Vector2 Position { get; set; }

        /// <summary>
        /// 获取或设置子弹是否正在使用中。
        /// 当子弹不再使用时，将其从视图中隐藏。
        /// </summary>
        public bool Used
        {
            get => used;
            set
            {
                used = value;
                //根据子弹是否使用来控制其可见性
                BulletNode.Visible = value;
            }
        }


        /// <summary>
        /// 初始化子弹，创建并添加到场景中。
        /// </summary>
        public void Init()//祝福注释-这里的子弹场景之后必须用对象池
        {
            ParentNode = MapCopy.Instance.BulletNode; // 设置父节点为游戏的主要实例
            //ParentNode = MapCopy.Instance.UnitNode; // 设置父节点为游戏的主要实例-祝福注释-用相同节点测试-测试进出检测问题
            BulletNode = (Node2D)ResourceLoader.Load<PackedScene>(bulletData.ScenePath).Instantiate(); // 加载子弹场景
            BulletNode.ZIndex = 10;//祝福注释-之后得改，子弹绘图层
            
            Area2D CollisionArea = BulletNode.GetNode<Area2D>("Area2D");
            CollisionArea.CollisionMask = Common.CalculateMaskSum(bulletCollide.CollisionLayerList);
            CollisionArea.CollisionLayer = Common.CalculateMaskSum(bulletCollide.CollisionLayerList);
            CollisionArea.Monitoring = true;//不检测进入和离开区域，节省性能
            CollisionArea.InputPickable = true;//节省性能
            CollisionArea.AreaEntered += Area2DAreaEntered;
            CollisionArea.AddToGroup("bullet");//祝福注释-测试1111111
            //BulletNode.AddChild(CollisionArea);
            ParentNode.AddChild(BulletNode); // 将子弹节点添加到父节点下
            Used = true; // 标记子弹为使用状态
        }

        public void Area2DAreaEntered(Area2D area)
        {
        }
    }
}