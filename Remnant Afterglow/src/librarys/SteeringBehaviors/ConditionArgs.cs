using System;

namespace SteeringBehaviors
{
    /// <summary>
    /// 用于封装转向行为条件检查所需参数的类。
    /// </summary>
    public class ConditionArgs
    {
        /// <summary>
        /// 获取与条件检查相关的转向行为实体。
        /// </summary>
        public ISteeringEntity Entity { get; }

        /// <summary>
        /// 获取条件检查的目标对象。
        /// </summary>
        public ISteeringTarget Target { get; }

        // 构造函数，允许通过提供一个 ISteeringEntity 和一个 ISteeringTarget 来初始化一个新的 ConditionArgs 实例。
        public ConditionArgs(ISteeringEntity entity, ISteeringTarget target)
        {
            Entity = entity ?? throw new ArgumentNullException(nameof(entity), "转向行为实体不能为空");
            Target = target ?? throw new ArgumentNullException(nameof(target), "转向行为目标不能为空");
        }
    }
}