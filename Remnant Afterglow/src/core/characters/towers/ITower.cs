namespace Remnant_Afterglow
{
    //炮塔接口，所有炮塔，理论上都应该实现该接口
    public interface ITower : IPoolItem
    {
        /// <summary>
        /// 炮塔所在阵营
        /// </summary>
        public int Camp { get; set; }

        /// <summary>
        /// 根据阵营数据和配置数据
        /// 初始化数据
        /// </summary>
        void InitData();
    }
}