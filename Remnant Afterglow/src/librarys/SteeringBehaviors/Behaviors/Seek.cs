using Godot;

namespace SteeringBehaviors
{
    /// <summary>
    /// 实现“寻求”行为的转向组件。该行为使得实体能够向目标位置移动。
    /// </summary>
    public partial class Seek : SteeringComponentBase
    {
        /// <summary>
        /// 计算并返回寻求行为的转向力。
        /// </summary>
        /// <param name="target">目标对象。</param>
        /// <returns>计算出的转向力。</returns>
        public override Vector2 Steer(ISteeringTarget target)
        {
            // 检查目标是否为空，以防止潜在的空引用异常。
            if (target == null || SteeringEntity == null)
                return Vector2.Zero; // 返回零向量表示没有转向力

            // 调用 BehaviorMath.Seek 方法计算转向力，使实体朝向目标位置移动。
            return BehaviorMath.Seek(target, SteeringEntity);
        }
    }
}