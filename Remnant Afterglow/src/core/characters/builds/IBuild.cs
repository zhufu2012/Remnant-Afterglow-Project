namespace Remnant_Afterglow
{
    //子弹接口
    public interface IBuild : IPoolItem
    {
        /// <summary>
        /// 建筑所在阵营，通常武器发射的子弹都与武器同阵营
        /// </summary>
        int Camp { get; set; }

        /// <summary>
        /// 建筑状态
        /// </summary>
        BuildStateEnum State { get; set; }

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