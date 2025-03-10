using Godot;
namespace SteeringBehaviors
{
    /// <summary>
    /// 碰撞避免转向行为。通过向期望速度方向投射射线并检查是否存在障碍物来实现。
    /// 如果存在障碍物，则尝试通过减去期望速度向量和障碍物位置来避开它。
    /// 注意：此行为需要其他转向行为的支持（例如 <see cref="Seek"/>）。
    /// </summary>
    public partial class CollisionAvoidance : SteeringComponentBase
    {
        /// <summary>
        /// 表示最远检测距离。
        /// </summary>
        public float MaxAvoidAhead { get; set; }

        /// <summary>
        /// 表示避免力的强度。
        /// </summary>
        public float AvoidForce { get; set; }

        /// <summary>
        /// 存储向前预测的位置。
        /// </summary>
        private Vector2 _ahead;

        /// <summary>
        /// 存储计算出的避障转向力。
        /// </summary>
        private Vector2 _avoidance;

        /// <summary>
        /// 构造函数，用于初始化最远检测距离和避免力。
        /// </summary>
        /// <param name="maxAvoidAhead">最远检测距离。</param>
        /// <param name="avoidForce">避免力的强度。</param>
        public CollisionAvoidance(float maxAvoidAhead, float avoidForce)
        {
            MaxAvoidAhead = maxAvoidAhead;
            AvoidForce = avoidForce;
        }

        /// <summary>
        /// 初始化方法，在组件被添加到实体时调用。
        /// 设置初始速度、期望速度和转向力为零，并初始化向前预测的位置和避障转向力。
        /// </summary>
        public override void _Ready()
        {

            // 设置实体的初始速度、期望速度和转向力为零。
            SteeringEntity.Velocity = new Vector2(-1, -2); // 注意：这里设置了一个负值，可能需要根据具体需求调整。
            SteeringEntity.DesiredVelocity = Vector2.Zero;
            SteeringEntity.Steering = Vector2.Zero;
            _ahead = Vector2.Zero;
            _avoidance = Vector2.Zero;
        }

        /// <summary>
        /// 计算并返回碰撞避免转向力。
        /// 该方法：
        /// 1. 根据当前速度计算向前预测的位置。
        /// 2. 使用 Physics.Linecast 方法检查从当前位置到预测位置之间是否有碰撞。
        /// 3. 如果有碰撞且碰撞体不属于当前实体，则计算避障转向力。
        /// 4. 返回计算出的避障转向力。
        /// 注意：此方法可能会导致实体卡在边缘（如矩形碰撞体），建议检查视野范围而不仅仅是射线。
        /// </summary>
        /// <param name="target">目标对象。</param>
        /// <returns>计算出的避障转向力。</returns>
        public override Vector2 Steer(ISteeringTarget target)
        {
            var dv = SteeringEntity.Velocity;
            if (dv != Vector2.Zero)
                dv.Normalized();
            dv *= MaxAvoidAhead * SteeringEntity.Velocity.Length() / SteeringEntity.MaxVelocity;

            _ahead = SteeringEntity.Position + dv;

            var ray = new PhysicsRayQueryParameters2D();///祝福注释

            


            /**
            // 检查从当前位置到预测位置之间的碰撞。
            var collision = Physics.Linecast(SteeringEntity.Position, _ahead, 2);
            var mostThreatening = collision.Collider;

            if (mostThreatening != null && collision.Collider.Entity != Entity)
            {
                // 计算避障转向力，即预测位置与障碍物位置之间的差值，归一化后乘以避免力强度。
                _avoidance = _ahead - mostThreatening.AbsolutePosition;
                _avoidance.Normalized();
                _avoidance *= AvoidForce;
            }
            else
            {
                // 如果没有检测到障碍物或碰撞体属于当前实体，则将避障转向力设为零。
                _avoidance *= 0;
            }**/

            return _avoidance;
        }
    }
}