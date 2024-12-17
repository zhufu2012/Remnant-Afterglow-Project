namespace Remnant_Afterglow
{
    /// <summary>
    /// 单位接口，所有单位，理论上都应该实现该接口
    /// </summary>
    public interface IUnit
    {
        /// <summary>
        /// 单位AI类型
        /// </summary>
        public UnitAIType AiType { get; set; }

    }
}