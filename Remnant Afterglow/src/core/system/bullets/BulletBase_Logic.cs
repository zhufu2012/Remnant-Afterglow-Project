using Godot;
using System;
using BulletMLLib.SharedProject;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 子弹类，这里处理子弹的逻辑
    /// </summary>
    public partial class BulletBase : Bullet, IPoolBullet
    {
        #region IPoolBullet
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
        /// 子弹状态
        /// </summary>
        public BulletStateEnum State { get; set; } = BulletStateEnum.Normal;
        /// <summary>
        /// 对象池id = 对象类型+ _ + object_id
        /// </summary>
        public string PoolId { get; set; }

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
        /// 当前反弹次数
        /// </summary>
        public int CurrentBounce { get; protected set; } = 0;

        /// <summary>
        /// 当前穿透次数
        /// </summary>
        public int CurrentPenetration { get; protected set; } = 0;
    }
}