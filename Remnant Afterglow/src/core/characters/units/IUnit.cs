namespace Remnant_Afterglow
{
    /// <summary>
    /// 单位接口，所有单位，理论上都应该实现该接口
    /// </summary>
    public interface IUnit : IPoolItem
    {
        /// <summary>
        /// 所在阵营，通常单位的武器都是同阵营
        /// </summary>
        public int Camp { get; set; }
        /// <summary>
        /// 单位AI类型
        /// </summary>
        public UnitAIType AiType { get; set; }

    }
}