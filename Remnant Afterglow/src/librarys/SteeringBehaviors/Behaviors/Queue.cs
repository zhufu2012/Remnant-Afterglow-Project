using Godot;
using System;
namespace SteeringBehaviors
{
    /// <summary>
    /// 实现“排队”行为的转向组件。该行为用于模拟实体在队列中保持适当间距的行为。
    /// </summary>
    public partial class Queue : SteeringComponentBase
    {
        /// <summary>
        /// 获取前方邻居的委托函数。
        /// </summary>
        private Func<ISteeringEntity, ISteeringEntity> _getNeighborAheadFunc;

        /// <summary>
        /// 队列的最大半径，用于确定实体之间的最小安全距离。
        /// </summary>
        private float _maxQueueRadius;

        /// <summary>
        /// 构造函数，初始化获取前方邻居的委托函数和最大队列半径。
        /// </summary>
        /// <param name="getNeighborAheadFunc">获取前方邻居的委托函数。</param>
        /// <param name="maxQueueRadius">队列的最大半径。</param>
        public Queue(Func<ISteeringEntity, ISteeringEntity> getNeighborAheadFunc, float maxQueueRadius)
        {
            _getNeighborAheadFunc = getNeighborAheadFunc ?? throw new ArgumentNullException(nameof(getNeighborAheadFunc));
            _maxQueueRadius = maxQueueRadius;
        }

        /// <summary>
        /// 计算并返回排队行为的转向力。
        /// 该方法：
        /// 1. 检查前方是否有邻居。
        /// 2. 如果有邻居且与当前实体的距离小于最大队列半径，则应用减速逻辑。
        /// 3. 返回计算出的转向力。
        /// </summary>
        /// <param name="target">目标对象。</param>
        /// <returns>计算出的转向力。</returns>
        public override Vector2 Steer(ISteeringTarget target)
        {
            var v = SteeringEntity.Velocity;
            var brake = Vector2.Zero;
            var neighbor = _getNeighborAheadFunc.Invoke(SteeringEntity);

            if (neighbor != null)
            {
                // 应用减速逻辑
                brake = -SteeringEntity.Steering * 0.8f; // 减速力度

                // 反转速度向量以减慢实体的速度
                v *= -1;
                brake += v;

                // 如果当前实体与前方邻居的距离小于最大队列半径，则进一步减速
                if (SteeringEntity.Position.DistanceTo(neighbor.Position) <= _maxQueueRadius)
                    SteeringEntity.Velocity *= 0.3f; // 进一步减速
            }

            return brake;
        }
    }
}