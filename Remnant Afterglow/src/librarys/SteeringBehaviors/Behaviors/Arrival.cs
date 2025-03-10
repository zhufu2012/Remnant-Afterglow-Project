using Godot;

namespace SteeringBehaviors
{
    // 具体转向行为类，实现了“到达”行为。
    public partial class Arrival : SteeringComponentBase
    {
        //表示减速半径。
        public float SlowingRadius { get; set; }

        // 私有字段，存储当前的目标。
        private ISteeringTarget _target;

        // 构造函数，用于初始化减速半径。
        public Arrival(float slowingRadius)
        {
            SlowingRadius = slowingRadius;
        }

        // 计算并返回转向力，使得实体能够到达目标。
        public override Vector2 Steer(ISteeringTarget target)
        {
            if (_target == null)
                _target = target;

            // 计算从当前位置到目标位置的期望速度。
            SteeringEntity.DesiredVelocity = target.Position - SteeringEntity.Position;
            var distance = SteeringEntity.DesiredVelocity.Length();

            // 如果距离小于减速半径，则根据距离比例调整期望速度。
            if (distance < SlowingRadius)
            {
                SteeringEntity.DesiredVelocity = SteeringEntity.DesiredVelocity.Normalized() * SteeringEntity.MaxVelocity * (distance / SlowingRadius);
            }
            else
            {
                // 否则，设置期望速度为最大速度。
                SteeringEntity.DesiredVelocity = SteeringEntity.DesiredVelocity.Normalized() * SteeringEntity.MaxVelocity;
            }

            // 返回计算出的转向力，即期望速度与当前速度之差。
            return SteeringEntity.DesiredVelocity - SteeringEntity.Velocity;
        }
    }
}