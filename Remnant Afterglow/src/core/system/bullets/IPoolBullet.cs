using System;

namespace Remnant_Afterglow
{
    //对象池子弹接口
    public interface IPoolBullet : IPoolItem
    {

        /// <summary>
        /// 当物体被回收时的事件
        /// </summary>
        event Action OnReclaimEvent;
        /// <summary>
        /// 离开对象池时的事件
        /// </summary>
        event Action OnLeavePoolEvent;
        /// <summary>
        /// 子弹状态
        /// </summary>
        public BulletStateEnum State { get; set; }

        /// <summary>
        /// 根据阵营数据和配置数据
        /// 初始化子弹数据
        /// </summary>
        void InitData();

        /// <summary>
        /// 子弹运行逻辑执行完成
        /// </summary>
        void LogicalFinish();
    }
}