namespace Remnant_Afterglow
{
    /// <summary>
    /// 可被对象池池回收的实例对象接口
    /// </summary>
    public interface IPoolItem : IDestroy
    {
        /// <summary>
        /// 是否已经回收
        /// </summary>
        public bool IsRecycled { get; set; }
        /// <summary>
        /// 对象唯一id,IdGenerator生成
        /// </summary>
        public string Logotype { get; set; }
        /// <summary>
        /// 对象池id = 对象类型+ _ + cfg_id
        /// </summary>
        public string PoolId { get; set;}
    }
}