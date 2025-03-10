using Godot;
namespace SteeringBehaviors
{
    // 静态类，提供了计算转向力的辅助方法。
    public static class BehaviorMath
    {
        // 计算“逃离”行为的转向力。
        public static Vector2 Flee(ISteeringTarget target, ISteeringEntity steeringEntity)
        {
            // 计算从当前位置到目标位置的方向向量，并将其归一化。
            var dv = (target.Position - steeringEntity.Position);
            
            dv.Normalized();
            
            // 将方向向量反转，并乘以最大速度，得到期望的速度。
            dv *= steeringEntity.MaxVelocity;
            steeringEntity.DesiredVelocity = -dv;

            // 返回期望速度与当前速度之差作为转向力。
            return steeringEntity.DesiredVelocity - steeringEntity.Velocity;
        }

        // 计算“寻找”行为的转向力。
        public static Vector2 Seek(ISteeringTarget target, ISteeringEntity steeringEntity)
        {
            // 计算从当前位置到目标位置的方向向量，并将其归一化。
            var dv = target.Position - steeringEntity.Position;
            dv.Normalized();

            // 设置期望速度为归一化后的方向向量。
            steeringEntity.DesiredVelocity = dv;

            // 返回期望速度（乘以最大速度）与当前速度之差作为转向力。
            return (steeringEntity.DesiredVelocity * steeringEntity.MaxVelocity) - steeringEntity.Velocity;
        }
    }
}