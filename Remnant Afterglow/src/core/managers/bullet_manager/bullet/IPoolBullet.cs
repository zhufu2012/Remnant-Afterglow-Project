using System;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 对象池子弹接口
    /// </summary>
    public interface IPoolBullet : IPoolItem
    {

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