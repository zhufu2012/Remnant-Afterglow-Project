namespace Remnant_Afterglow
{
    /// <summary>
    /// 可被对象池池回收的实例对象接口
    /// </summary>
    public interface IPoolItem : IDestroy
    {
        /// <summary>
        /// 对象唯一id,IdGenerator生成
        /// </summary>
        public string Logotype { get; set; }
    }
}