using System;

namespace Remnant_Afterglow
{
    //子弹接口
    public interface IBullet : IPoolItem
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
        /// 子弹所在阵营，通常武器发射的子弹都与武器同阵营
        /// </summary>
        int Camp { get; set; }
        /// <summary>
        /// 子弹状态
        /// </summary>
        BulletStateEnum State { get; }

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