using Godot;

namespace SteeringBehaviors
{
    /// <summary>
    /// 实现“跟随领导者”行为的转向组件。该行为使得实体能够跟踪并保持在领导者的后面一定距离处。
    /// </summary>
    public partial class LeaderFollowing : SteeringComponentBase
    {
        /// <summary>
        /// 领导者实体。
        /// </summary>
        public ISteeringEntity Leader { get; set; }

        /// <summary>
        /// 表示实体应保持在领导者后面的最小距离。
        /// </summary>
        public float LeaderBehindDist { get; set; }

        /// <summary>
        /// 表示领导者视野半径。
        /// </summary>
        public float LeaderSightRadius { get; set; }

        /// <summary>
        /// 用于实现到达行为的 Arrival 组件。
        /// </summary>
        private Arrival _arrival;

        /// <summary>
        /// 存储计算出的领导者前方位置。
        /// </summary>
        private Vector2 _ahead;

        /// <summary>
        /// 存储计算出的领导者后方位置。
        /// </summary>
        private Vector2 _behind;

        /// <summary>
        /// 构造函数，初始化领导者、跟随距离和视野半径。
        /// </summary>
        /// <param name="leader">领导者实体。</param>
        /// <param name="leaderBehindDist">跟随距离。</param>
        /// <param name="leaderSightRadius">视野半径。</param>
        public LeaderFollowing(ISteeringEntity leader, float leaderBehindDist, float leaderSightRadius)
        {
            Leader = leader;
            LeaderBehindDist = leaderBehindDist;
            LeaderSightRadius = leaderSightRadius;
        }

        /// <summary>
        /// 初始化方法，在组件被添加到实体时调用。
        /// 创建并初始化 Arrival 行为，并设置其关联的转向实体。
        /// </summary>
        public override void _Ready()
        {

            // 创建一个 Arrival 行为实例，并设置其减速半径（TODO: 考虑将其作为嵌套行为配置）。
            _arrival = new Arrival(16f);
            _arrival.SteeringEntity = SteeringEntity;
        }

        /// <summary>
        /// 计算并返回跟随领导者行为的转向力。
        /// 该方法：
        /// 1. 根据领导者的速度计算其前方和后方的位置。
        /// 2. 检查当前实体是否在领导者的视野范围内。
        /// 3. 使用嵌套的行为（默认为 Arrival）来计算转向力。
        /// </summary>
        /// <param name="target">目标对象。</param>
        /// <returns>计算出的转向力。</returns>
        public override Vector2 Steer(ISteeringTarget target)
        {
            var dv = Leader.Velocity;
            var force = Vector2.Zero;

            if (dv != Vector2.Zero)
                dv.Normalized();
            dv *= LeaderBehindDist;
            _ahead = Leader.Position + dv;

            dv *= -1;
            _behind = Leader.Position + dv;

            // 注意：以下代码被注释掉了，可能需要根据具体需求启用或调整。
            //if (IsOnLeaderSight(_ahead))
            //    force += _evade.Steer(Leader as ISteeringTarget);

            // 使用嵌套的行为（默认为 Arrival）来计算转向力。
            ISteeringBehavior nestedBehavior = NestedBehavior ?? _arrival;
            return force + nestedBehavior.Steer(new Vector2SteeringTarget(_behind));
        }

        /// <summary>
        /// 检查当前实体是否在领导者的视野范围内。
        /// </summary>
        /// <param name="leaderAhead">领导者前方位置。</param>
        /// <returns>如果在视野范围内，则返回 true；否则返回 false。</returns>
        private bool IsOnLeaderSight(Vector2 leaderAhead)
        {
            return leaderAhead.DistanceTo( SteeringEntity.Position) <= LeaderSightRadius ||
                   Leader.Position.DistanceTo( SteeringEntity.Position) <= LeaderSightRadius;
        }


    }

}