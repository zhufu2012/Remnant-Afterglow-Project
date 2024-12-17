using System;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 所有Buff类的基类-buff中 时间相关逻辑和buff周期相关逻辑
    /// </summary>
    public abstract partial class BuffBase : IBuff, IComparable<BuffBase>
    {
        public int Duration;

        /// <summary>
        /// buff时间-计时器-帧数
        /// </summary>
        private int timer;

        /// <summary>
        /// 获取周期性效果的剩余时间
        /// </summary>
        public int tickTimer;

        /// <summary>
        /// 每帧 减少的计数,初始化时默认为1
        /// </summary>
        public int AddTick;

        /// <summary>
        /// 时候开始了周期性计时
        /// </summary>
        public bool runTickTimer = false;

        /// <summary>
        /// 设置每帧的计数
        /// </summary>
        /// <param name="AddTick">每帧计数</param>
        public void SetAddTick(int AddTick)
        {
            this.AddTick = AddTick;
        }
        /// <summary>
        /// 开始周期性效果计时。
        /// </summary>
        /// <param name="interval">周期间隔。</param>
        public void StartBuffTickEffect()
        {
            runTickTimer = true;
            tickTimer = buffData.TickInterval;
        }
        /// <summary>
        /// 停止周期性效果计时。
        /// </summary>
        public void StopBuffTickEffect()
        {
            runTickTimer = false;
        }

        //buff周期的更新
        public void BuffTickUpdate()
        {
            if (!runTickTimer)
                return;//是否开启了周期buff生效功能
            tickTimer -= AddTick;
            while (tickTimer <= 0)
            {
                tickTimer += buffData.TickInterval;
                OnBuffTickEffect();//处理周期性 buff效果
            }
        }


        /// <summary>
        /// 处理周期性效果。
        /// </summary>
        protected abstract void OnBuffTickEffect();
    }
}