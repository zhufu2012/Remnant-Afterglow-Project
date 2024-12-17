using System;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 所有Buff类的基类,一个buff 实体上只会有一个
    /// 这里完善 管理器接手的生命周期函数
    ///OnBuffAwake->
    ///   OnBuffStart ->         /// Buff开始生效时-子类可实现
    ///   LateUpdate             /// BuffHandler:LateUpdate  尽量在一帧最后运行
    ///   <   OnBuffModifyLayer , onBuffTickEffect   >     ///循环 层修改 和 buff运行
    ///   OnBuffRemove  ->       ///设置移除buff,设置为buff不再生效
    ///    下一帧 ->
    ///   OnBuffDestroy          ///真正移除buff
    /// </summary>
    public abstract partial class BuffBase : IBuff, IComparable<BuffBase>
    {
        /// <summary>
        /// 是否是第一次调用。
        /// </summary>
        private bool firstFrame;

        /// <summary>
        /// 是否永久生效
        /// </summary>
        public bool IsPermanent;
        /// <summary>
        /// 是否移除全部层
        /// </summary>
        public bool IsRemoveAllLayer;
        /// <summary>
        /// 在Buff被唤醒时调用。
        /// </summary>
        public virtual void OnBuffAwake()
        {
            timer = buffData.Duration;//buff时间-计时器修改为
            isEffective = true;//buff设置为生效
            Layer = 0;//层数设置为0
            ModifyLayer(1);//修改层数为1
            firstFrame = true;
        }

        /// <summary>
        /// 在Buff被销毁时调用。
        /// </summary>
        public void OnBuffDestroy()
        {
            if (mutilAddType == BuffMutilAddType.multipleLayer || mutilAddType == BuffMutilAddType.multipleLayerAndResetTime)
            //如果buff类型是增加Buff层数或增加Buff层数且重置Buff时间
            {
                ModifyLayer(-Layer);
            }
            RealModifyLayer();
        }

        /// <summary>
        /// 当Buff需要被移除时调用。
        /// </summary>
        public abstract void OnBuffRemove();

        /// <summary>
        /// 更新Buff的状态。-每帧运行
        /// </summary>
        public void OnBuffUpdate()
        {
            if (firstFrame)//第一次调用，需要无视掉
            {
                firstFrame = false;
                return;
            }
            if (!isEffective) return;
            if (!IsPermanent)//是否为永久Buff
            {
                timer -= AddTick;
                while (timer <= 0 && isEffective)
                {
                    if (IsRemoveAllLayer)//true 计时结束时 buff -1层/  false 层全清空
                    {
                        timer += Duration;
                        ModifyLayer(-1);
                    }
                    else
                    {
                        isEffective = false;
                        timer = 0;
                    }
                }
            }
            RealModifyLayer();//实际执行 buff层的修改
            BuffTickUpdate();//buff周期的更新
        }

        /// <summary>
        /// 重置计时器到初始持续时间。
        /// </summary>
        public void ResetTimer()
        {
            timer = buffData.Duration;//buff时间-计时器 修改为 Buff持续时间
        }

        public void SetEffective(bool ef)
        {
            isEffective = ef;
        }

        /// <summary>
        /// Buff生效的效果-子类实现
        /// </summary>
        public abstract void OnBuffStart();

        /// <summary>
        /// 当Buff的层数被修改时调用。-子类实现
        /// </summary>
        /// <param name="change">改变的层数值。</param>
        public abstract void OnBuffModifyLayer(int change);
        /// <summary>
        /// 重置Buff的所有状态。
        /// </summary>
        public abstract void Reset();
    }
}