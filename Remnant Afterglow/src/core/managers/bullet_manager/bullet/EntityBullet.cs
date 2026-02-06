using BulletMLLib.SharedProject;
using Godot;
using System;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 实体子弹
    /// </summary>
    public partial class EntityBullet : Bullet, IPoolBullet
    {
        #region IPoolBullet
        /// <summary>
        /// 对象唯一标识，哪儿用到了就哪个
        ///  用于在对象池中区分对象类型，可以是资源路径，也可以是配置表id
        ///  或者唯一数据id
        /// </summary>
        public string Logotype { get; set; }

        public bool IsDestroyed { get; }
        public virtual void InitData()
        { }
        public virtual void LogicalFinish()
        {
        }
        public void Destroy()
        {
        }
        #endregion
        /// <summary>
        /// 标记此子弹是否正在使用中。
        /// </summary>
        private bool used;
        /// <summary>
        /// 子弹基础的数据
        /// </summary>
        public BulletData bulletData;

        public BulletLogic bulletLogic;
        /// <summary>
        /// 构造函数，初始化Mover实例，并设置其管理器。
        /// </summary>
        /// <param name="myBulletManager">管理此子弹的IBulletManager实例。</param>
        public EntityBullet(IBulletManager myBulletManager, BulletData bulletData, BaseObject targetObject, BaseObject createObject)
            : base(myBulletManager, targetObject, createObject)
        {
            this.bulletData = bulletData;
            BulletId = bulletData.BulletId;
            BulletLabel = bulletData.BulletLabel;
            Camp = createObject.Camp;
            bulletLogic = ConfigCache.GetBulletLogic(BulletId);
        }
        /// <summary>
        /// 初始化子弹，创建并添加到场景中。
        /// </summary>
        public void Init()//祝福注释-这里的子弹场景之后必须用对象池
        {
            Used = true; // 标记子弹为使用状态
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
            }
        }
    }
}
