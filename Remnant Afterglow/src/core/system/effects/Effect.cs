
namespace Remnant_Afterglow
{
    /// <summary>
    /// 特效接口
    /// </summary>
    public class Effect : IEffect
    {
        public string Logotype { get; set; }

        public bool IsDestroyed { get; }
        /// <summary>
        /// 配置id
        /// </summary>
        public int cfg_id { get; set; }

        /// <summary>
        /// 播放特效
        /// </summary>
        public void PlayEffect()
        {

        }

        /// <summary>
        /// 当物体被回收时调用，也就是进入对象池
        /// </summary>
        public void OnLeavePool()
        {
        }
        /// <summary>
        /// 离开对象池时调用
        /// </summary>
        public void OnReclaim()
        {
        }

        public void Destroy()
        {

        }
    }

}
