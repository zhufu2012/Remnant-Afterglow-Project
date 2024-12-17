
namespace Remnant_Afterglow
{
    /// <summary>
    /// 实体buff的接口，给实体加上各种效果的buff
    /// </summary>
    public interface IBuff
    {
        /// <summary>
        /// buffId
        /// </summary>
        public int buffId { get; set; }
        /// <summary>
        /// buff是否生效，不生效时，buff计时器也需要暂停
        /// </summary>
        public bool isEffective{get; set;}

        /// <summary>
        /// Buff启用时，生效前（即便该Buff不可作用于对象也会先执行）
        /// </summary>
        public void OnBuffAwake();
        /// <summary>
        /// Buff开始生效时
        /// </summary>
        public void OnBuffStart();
        /// <summary>
        /// Buff移除时（用于移除效果）
        /// </summary>
        public void OnBuffRemove();
        /// <summary>
        /// Buff销毁时（用于执行移除时效果）
        /// </summary>
        public void OnBuffDestroy();
        /// <summary>
        /// 更新周期性效果计时
        /// </summary>
        public void OnBuffUpdate();
        /// <summary>
        /// Buff层数变化时
        /// </summary>
        /// <param name="change"></param>
        public void OnBuffModifyLayer(int change);
        /// <summary>
        /// 开始周期性效果
        /// 如果已经开启过(无论是否在之后停止了)，则重置计时器并重新开始
        /// </summary>
        /// <param name="interval">周期时间</param>
        public void StartBuffTickEffect();
        /// <summary>
        /// 停止周期性效果
        /// </summary>
        public void StopBuffTickEffect();
        /// <summary>
        /// 重置Buff以复用
        /// </summary>
        public void Reset();
        /// <summary>
        /// 重置总体时间,重置buff时间
        /// </summary>
        public void ResetTimer();
        /// <summary>
        /// 让Buff层级+=i
        /// </summary>
        /// <param name="i">改变的层数，可以为负</param>
        public void ModifyLayer(int i);
        /// <summary>
        /// 设置Buff是否生效。
        /// 不生效时，Buff的所有计时器也会暂停
        /// </summary>
        /// <param name="ef"></param>
        public void SetEffective(bool ef);

    }
}
