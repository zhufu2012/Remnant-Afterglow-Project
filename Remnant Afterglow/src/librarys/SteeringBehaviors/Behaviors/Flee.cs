using Godot;

namespace SteeringBehaviors
{
    /// <summary>
    /// 实现“逃离”行为的转向组件。该行为使得实体能够尽可能远离目标。
    /// </summary>
    public partial class Flee : SteeringComponentBase
    {
        /// <summary>
        /// 计算并返回逃离行为的转向力。
        /// 该方法调用了 BehaviorMath.Flee 方法来计算转向力，使得实体能够远离目标。
        /// </summary>
        /// <param name="target">目标对象。</param>
        /// <returns>计算出的转向力。</returns>
        public override Vector2 Steer(ISteeringTarget target)
        {
            // 调用静态辅助类 BehaviorMath 中的 Flee 方法来计算转向力。
            return BehaviorMath.Flee(target, SteeringEntity);
        }
    }
}