namespace Remnant_Afterglow
{
    /// <summary>
    /// 建筑接口
    /// </summary>
    public interface IBuild : IPoolItem
    {
        /// <summary>
        /// 建筑状态
        /// </summary>
        BuildStateEnum State { get; set; }

        /// <summary>
        /// 根据阵营数据和配置数据
        /// 初始化建筑数据
        /// </summary>
        void InitData();

        /// <summary>
        /// 建筑运行逻辑执行完成
        /// </summary>
        void LogicalFinish();
    }
}