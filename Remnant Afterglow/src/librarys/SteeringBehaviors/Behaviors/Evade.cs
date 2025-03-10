using Godot;

namespace SteeringBehaviors
{
    /// <summary>
    /// 实现“躲避”行为的转向组件。该行为使得实体能够预测目标的未来位置，并尝试避开该位置。
    /// </summary>
    public partial class Evade : SteeringComponentBase
    {
        /// <summary>
        /// 计算并返回躲避行为的转向力。
        /// 该方法：
        /// 1. 计算当前实体与目标之间的距离。
        /// 2. 根据最大速度计算未来的时间间隔。
        /// 3. 预测目标在未来时间间隔内的位置。
        /// 4. 如果存在嵌套行为，则调用嵌套行为的 Steer 方法；否则使用 BehaviorMath.Flee 方法计算转向力。
        /// </summary>
        /// <param name="target">目标对象。</param>
        /// <returns>计算出的转向力。</returns>
        public override Vector2 Steer(ISteeringTarget target)
        {
            // 计算当前实体与目标之间的距离。
            var distance = (target.Position - SteeringEntity.Position).Length();

            // 根据最大速度计算未来的时间间隔。
            var updatesAhead = distance / SteeringEntity.MaxVelocity;

            // 预测目标在未来时间间隔内的位置。
            Vector2 futurePos;
            if (target is ISteeringEntity steeringTarget)
            {
                // 如果目标也是一个转向实体，则考虑其速度来预测未来位置。
                futurePos = target.Position + steeringTarget.Velocity * updatesAhead;
            }
            else
            {
                // 如果目标不是转向实体，则假设目标位置不变。
                futurePos = target.Position;
            }

            // 如果存在嵌套行为，则调用嵌套行为的 Steer 方法；
            // 否则使用 BehaviorMath.Flee 方法计算转向力。
            return NestedBehavior == null
                ? BehaviorMath.Flee((Vector2SteeringTarget)futurePos, SteeringEntity)
                : NestedBehavior.Steer((Vector2SteeringTarget)futurePos);
        }
    }
}