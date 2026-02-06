namespace Remnant_Afterglow
{
    /// <summary>
    /// AI类型
    /// </summary>
    public enum UnitAIType
    {
        /// <summary>
        /// 陆军AI 导航层1
        /// </summary>
        LandUnit = 0,
        /// <summary>
        /// 爬行单位 导航层1 2
        /// </summary>
        CrawlUnit = 1,
        /// <summary>
        /// 悬浮单位 导航层1 3
        /// </summary>
        SuspendUnit = 2,
        /// <summary>
        /// 飞行单位 导航层1-4
        /// </summary>
        AirUnit = 3,
        /// <summary>
        /// 机甲形 陆地单位
        /// </summary>
        HullLandUnit = 4,
        /// <summary>
        /// 机甲形 空军单位
        /// </summary>
        HullAirUnit = 5
    }
}