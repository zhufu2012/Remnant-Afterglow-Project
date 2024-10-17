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
        bool IsRecycled { get; set; }
        /// <summary>
        /// 对象唯一id,IdGenerator生成
        /// </summary>
        public string Logotype { get; set; }
        /// <summary>
        /// 实体配置id
        /// </summary>
        public int cfg_id { get; set;}
        /// <summary>
        /// 对象池id = 对象类型+ _ + cfg_id
        /// </summary>
        public string PoolId { get; set;}
        /// <summary>
        /// 当物体被回收时调用，也就是进入对象池
        /// </summary>
        void OnReclaim();
        /// <summary>
        /// 离开对象池时调用
        /// </summary>
        void OnLeavePool();
    }
}