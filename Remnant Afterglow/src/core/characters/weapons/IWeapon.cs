namespace Remnant_Afterglow
{
    //武器接口，所有武器理论上都应该实现该接口
    public interface IWeapon : IPoolItem
    {
        /// <summary>
        /// 武器所在阵营，通常单位的武器都是同阵营
        /// </summary>
        public int Camp { get; set; }

        /// <summary>
        /// 根据阵营数据和配置数据
        /// 初始化数据
        /// </summary>
        void InitData();
    }
}




