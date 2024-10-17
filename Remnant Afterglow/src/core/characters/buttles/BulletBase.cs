using Godot;
using System;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 子弹类，需要实现IBullet接口
    /// </summary>
    public partial class BulletObject : BaseObject, IBullet
    {
        #region IBullet
        public event Action OnReclaimEvent;
        public event Action OnLeavePoolEvent;
        /// <summary>
        /// 是否已经回收
        /// </summary>
        public bool IsRecycled { get; set; }
        /// <summary>
        /// 对象唯一标识，哪儿用到了就哪个
        ///  用于在对象池中区分对象类型，可以是资源路径，也可以是配置表id
        ///  或者唯一数据id
        /// </summary>
        public string Logotype { get; set; }
        /// <summary>
        /// 配置id
        /// </summary>
        public int cfg_id { get; set; }
        /// <summary>
        /// 对象池id = 对象类型+ _ + cfg_id
        /// </summary>
        public string PoolId { get; set; }
        /// <summary>
        /// 所在阵营
        /// </summary>
        public int Camp { get; set; }

        public bool IsDestroyed { get; }
        #endregion


        /// <summary>
        /// 当前子弹已经飞行的距离
        /// </summary>
        private float CurrFlyDistance = 0;

        /// <summary>
        /// 子弹状态
        /// </summary>
        public BulletStateEnum State { get; }

        /// <summary>
        /// 子弹伤害碰撞区域
        /// </summary>
        [Export]
        public Area2D CollisionArea { get; set; }

        /// <summary>
        /// 子弹使用的数据
        /// </summary>
        public BulletData CfgData { get; private set; }


        public BulletObject(int cfg_id, int camp)
        {
            this.cfg_id = cfg_id;
            this.Camp = camp;
            GroupName = MapGroup.GroupName_Bullet + Camp;
            InitData();
            InitAttr(BaseObjectType.BaseBullet, CfgData.ObjectId, CfgData.TempLateList);//初始化属性
        }
        /// <summary>
        /// 根据阵营数据和配置数据
        /// 初始化子弹数据
        /// </summary>
        public virtual void InitData()
        {
            CfgData = ConfigCache.GetBulletData("" + cfg_id);
            Logotype = IdGenerator.Generate(IdConstant.ID_TYPE_BULLET);
        }

        /// <summary>
        /// 子弹运行逻辑执行完成
        /// </summary>
        public virtual void LogicalFinish()
        {
            ObjectPool.Reclaim(this);
        }

        /// <summary>
        /// 离开对象池时调用
        /// </summary>
        public void OnLeavePool()
        {
        }

        /// <summary>
        /// 当物体被回收时调用，也就是进入对象池
        /// </summary>
        public void OnReclaim()
        {
        }

        public void Destroy()
        {
            throw new NotImplementedException();
        }
    }
}