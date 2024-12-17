using System;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 重复添加同一种Buff时的行为
    /// </summary>
    public enum BuffMutilAddType
    {
        resetTime = 1,                     //重置Buff时间
        multipleLayer = 2,                 //增加Buff层数
        multipleLayerAndResetTime = 3      //增加Buff层数且重置Buff时间
    }

    /// <summary>
    /// 所有Buff类的基类,一个buff 实体上只会有一个
    /// </summary>
    public abstract partial class BuffBase : IBuff, IComparable<BuffBase>, ICloneable
    {

        /// <summary>
        /// buff配置id
        /// </summary>
        public int buffId { get; set; }

        /// <summary>
        /// 当前Buff的层数
        /// </summary>
        public int Layer;

        /// <summary>
        /// 是否启用buff
        /// </summary>
        public bool isEffective { get; set; }

        /// <summary>
        /// 目标单位的Buff处理器引用
        /// </summary>
        public BuffHandler Handler;
        /// <summary>
        /// buff提供者
        /// </summary>
        public BaseObject CasterObject;
        //buff基础数据
        public BuffData buffData;

        /// <summary>
        /// 重复添加方式
        /// </summary>
        public BuffMutilAddType mutilAddType;

        /// <summary>
        /// 暂存的层变量，用于计算层的变化。
        /// </summary>
        private int tmpLayer = 0;
        /// <summary>
        /// 是否已经修改过层。
        /// </summary>
        private bool layerModified = false;

        /// <summary>
        /// 初始化
        /// </summary>
        /// <param name="buffId">buffId</param>
        /// <param name="target">Buff目标的buff处理器</param>
        /// <param name="caster">Buff来源</param>
        public void Initialize(int buffId, IBuffHandler target, BaseObject caster)
        {
            this.buffId = buffId;
            buffData = ConfigCache.GetBuffData(buffId);
            this.Handler = (BuffHandler)target;
            this.CasterObject = caster;
            mutilAddType = (BuffMutilAddType)buffData.BuffMutilAddType;
            runTickTimer = buffData.RunTickTimer;//初始化 buff周期设置
            IsPermanent = buffData.IsPermanent;
            IsRemoveAllLayer = buffData.IsRemoveAllLayer;
            Duration = buffData.Duration;
            AddTick = 1;
        }

        /// <summary>
        /// 克隆当前的Buff
        /// </summary>
        /// <returns>克隆的Buff</returns>
        public object Clone()
        {
            return base.MemberwiseClone();
        }

        #region Buff的层数逻辑
        /// <summary>
        /// 修改Buff的层数。
        /// </summary>
        /// <param name="i">要增加或减少的层数。</param>
        public void ModifyLayer(int i)
        {
            if (Layer + i != 0 && Layer + i != 1 && mutilAddType != BuffMutilAddType.multipleLayer && mutilAddType != BuffMutilAddType.multipleLayerAndResetTime)
                throw new System.Exception("试图修改非层级Buff的层数");
            tmpLayer += i;
            layerModified = true;
        }

        /// <summary>
        /// 实际执行层的修改。
        /// </summary>
        private void RealModifyLayer()
        {
            Layer += tmpLayer;
            if (layerModified) OnBuffModifyLayer(Layer < 0 ? -Layer : tmpLayer);//实际层修改
            if (Layer <= 0) isEffective = false;
            tmpLayer = 0;
            layerModified = false;
        }

        //buff对比
        public int CompareTo(BuffBase other)
        {
            return buffId.CompareTo(other.buffId);
        }
        #endregion


    }
}