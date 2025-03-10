using Godot;
using System;
using System.Collections.Generic;

namespace SteeringBehaviors
{
    /// <summary>
    /// 实现“分离”行为的转向组件。该行为使得实体能够与附近的其他实体保持一定的距离。
    /// </summary>
    public partial class Separation : SteeringComponentBase
    {
        /// <summary>
        /// 获取附近实体的委托函数。
        /// </summary>
        public Func<Separation, IEnumerable<ISteeringEntity>> CheckNearestFunc { get; set; }

        /// <summary>
        /// 分离半径，用于确定哪些实体被视为邻居。
        /// </summary>
        public float SeparationRadius { get; set; }

        /// <summary>
        /// 最大分离力，用于限制转向力的大小。
        /// </summary>
        public float MaxSeparation { get; set; }

        /// <summary>
        /// 构造函数，初始化获取附近实体的委托函数、分离半径和最大分离力。
        /// </summary>
        /// <param name="checkNearestFunc">获取附近实体的委托函数。</param>
        /// <param name="separationRadius">分离半径。</param>
        /// <param name="maxSeparation">最大分离力。</param>
        public Separation(Func<Separation, IEnumerable<ISteeringEntity>> checkNearestFunc, float separationRadius, float maxSeparation)
        {
            CheckNearestFunc = checkNearestFunc ?? throw new ArgumentNullException(nameof(checkNearestFunc));
            SeparationRadius = separationRadius;
            MaxSeparation = maxSeparation;
        }

        /// <summary>
        /// 计算并返回分离行为的转向力。
        /// </summary>
        /// <param name="target">目标对象。</param>
        /// <returns>计算出的转向力。</returns>
        public override Vector2 Steer(ISteeringTarget target)
        {
            if (SteeringEntity == null || CheckNearestFunc == null)
                return Vector2.Zero; // 返回零向量表示没有转向力

            var force = Vector2.Zero;
            var neighborCount = 0;

            // 调用 CheckNearestFunc 获取附近的实体列表。
            var neighbors = CheckNearestFunc.Invoke(this);

            // 如果没有邻居，直接返回零向量。
            if (neighbors == null)
                return Vector2.Zero;

            foreach (var entity in neighbors)
            {
                // 计算当前实体与邻居之间的向量，并累积到总力量中。
                var difference = SteeringEntity.Position - entity.Position;
                var distance = difference.Length();

                // 只考虑在分离半径内的邻居。
                if (distance > 0 && distance < SeparationRadius)
                {
                    force += difference / distance; // 权重距离
                    neighborCount++;
                }
            }

            if (neighborCount > 0)
            {
                // 计算平均力量，并反转方向以远离邻居。
                force /= neighborCount;
                force *= -1;
            }

            if (force != Vector2.Zero)
            {
                // 对力量向量进行归一化，并乘以最大分离力。
                force.Normalized();
                force *= MaxSeparation;
            }

            return force;
        }
    }
}