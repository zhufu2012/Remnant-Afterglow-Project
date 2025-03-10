using Godot;
using System;
namespace SteeringBehaviors
{
    /// <summary>
    /// 枚举类型，表示路径跟随模式。
    /// </summary>
    public enum PathFollowingMode
    {
        OneWay, // 单向跟随：从起点到终点，不返回。
        Circular, // 循环跟随：循环遍历路径中的所有节点。
        Patrol // 巡逻跟随：在路径节点之间来回巡逻。
    }

    /// <summary>
    /// 实现“路径跟随”行为的转向组件。该行为使得实体能够根据预定义的路径进行移动。
    /// </summary>
    public partial class PathFollowing : SteeringComponentBase
    {
        /// <summary>
        /// 用于实现具体路径跟随逻辑的转向行为组件。
        /// </summary>
        private readonly ISteeringBehavior _pathFollowingBehavior;

        /// <summary>
        /// 表示路径跟随模式。
        /// </summary>
        public PathFollowingMode PathFollowingMode { get; set; }

        /// <summary>
        /// 当前处理的路径节点索引。
        /// </summary>
        private int _currentNode = 0;

        /// <summary>
        /// 路径方向，正值为正向，负值为反向。
        /// </summary>
        private int _pathDir = -1;

        /// <summary>
        /// 构造函数，初始化路径跟随行为和模式。
        /// </summary>
        /// <param name="pathFollowingBehavior">用于实现具体路径跟随逻辑的转向行为组件。</param>
        /// <param name="mode">路径跟随模式，默认为单向。</param>
        public PathFollowing(ISteeringBehavior pathFollowingBehavior, PathFollowingMode mode = PathFollowingMode.OneWay)
        {
            _pathFollowingBehavior = pathFollowingBehavior;
            PathFollowingMode = mode;
        }

        /// <summary>
        /// 初始化方法，在组件被添加到实体时调用。
        /// 设置路径跟随行为组件关联的转向实体。
        /// </summary>
        //public override void Initialize()
        //{
            //base.Initialize();

        //    _pathFollowingBehavior.SteeringEntity = SteeringEntity;
        //}

        /// <summary>
        /// 计算并返回路径跟随行为的转向力。
        /// 根据不同的路径跟随模式计算转向力：
        /// 1. 如果目标路径已完成，则停止移动。
        /// 2. 如果目标不是 PathComponent 类型，则抛出异常。
        /// 3. 根据路径跟随模式的不同，选择下一个路径节点，并使用嵌套的行为来计算转向力。
        /// </summary>
        /// <param name="target">目标对象。</param>
        /// <returns>计算出的转向力。</returns>
        public override Vector2 Steer(ISteeringTarget target)
        {
            if (!target.IsActual) // 如果路径已完成，需要停止移动
                return -SteeringEntity.Velocity;

            var pathComp = target as PathComponent;
            if (pathComp == null)
                throw new Exception("Incorrect pathing target (use PathComponent)");

            var path = pathComp.Path;

            if (path.NodeCount == 0)
                return -SteeringEntity.Velocity;

            switch (PathFollowingMode)
            {
                case PathFollowingMode.Patrol:
                    return HandlePatrolMode(path);
                case PathFollowingMode.Circular:
                    return HandleCircularMode(path);
                case PathFollowingMode.OneWay:
                    return HandleOneWayMode(path);
                default:
                    return -SteeringEntity.Velocity;
            }
        }

        /// <summary>
        /// 处理巡逻模式下的路径跟随逻辑。
        /// </summary>
        /// <param name="path">路径对象。</param>
        /// <returns>计算出的转向力。</returns>
        private Vector2 HandlePatrolMode(Path path)
        {
            var targetNode = path[_currentNode];

            if (targetNode != null && IsWithinTarget(targetNode))
            {
                _currentNode += _pathDir;

                if (_currentNode >= path.NodeCount || _currentNode < 0)
                {
                    _pathDir *= -1;
                    _currentNode += _pathDir;
                }

                targetNode = path[_currentNode];
            }

            return _pathFollowingBehavior.Steer((Vector2SteeringTarget)targetNode.Target);
        }

        /// <summary>
        /// 处理循环模式下的路径跟随逻辑。
        /// </summary>
        /// <param name="path">路径对象。</param>
        /// <returns>计算出的转向力。</returns>
        private Vector2 HandleCircularMode(Path path)
        {
            var targetNode = path[_currentNode % path.NodeCount];

            if (targetNode != null && IsWithinTarget(targetNode))
            {
                _currentNode++;
                targetNode = path[_currentNode % path.NodeCount];
            }

            return _pathFollowingBehavior.Steer((Vector2SteeringTarget)targetNode.Target);
        }

        /// <summary>
        /// 处理单向模式下的路径跟随逻辑。
        /// </summary>
        /// <param name="path">路径对象。</param>
        /// <returns>计算出的转向力。</returns>
        private Vector2 HandleOneWayMode(Path path)
        {
            var targetNode = path.GetTargetNode();
            if (targetNode != null && IsWithinTarget(targetNode))
                path.RemoveTargetNode();

            return _pathFollowingBehavior.Steer((Vector2SteeringTarget)targetNode.Target);
        }

        /// <summary>
        /// 检查当前实体是否在目标节点的目标半径内。
        /// </summary>
        /// <param name="target">路径节点。</param>
        /// <returns>如果在目标半径内，则返回 true；否则返回 false。</returns>
        private bool IsWithinTarget(PathNode target)
        {
            var distance = (SteeringEntity.Position - target.Target).Length();
            return distance <= target.TargetRadius;
        }
    }
}