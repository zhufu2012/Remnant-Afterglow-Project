using Godot;
using System.Collections;
using System.Collections.Generic;

namespace SteeringBehaviors
{
    // 表示一条路径，由多个 PathNode 组成，实现了 IEnumerable<PathNode> 接口以支持遍历。
    public class Path : IEnumerable<PathNode>
    {
        // 存储路径节点的私有列表。
        private readonly List<PathNode> _nodes;

        // 路径可以包含的最大节点数量，默认值为 128。
        public int MaxNodes { get; set; }

        // 当前路径中的节点数量，通过属性 NodeCount 访问。
        public int NodeCount => _nodes.Count;

        // 索引器，允许通过索引访问路径中的节点。
        public PathNode this[int i] => _nodes[i];

        // 构造函数，初始化一个具有指定最大节点数的新路径。
        public Path(int maxNodes = 128)
        {
            _nodes = new List<PathNode>(maxNodes); // 初始化节点列表，预分配空间以提高性能
            MaxNodes = maxNodes; // 设置最大节点数量
        }

        // 清空路径中的所有节点。
        public void Clear()
        {
            _nodes.Clear(); // 清除所有节点
        }

        /// <summary>
        /// 向路径中添加一个新的节点。如果超过了最大节点数，则移除目标节点（即第一个节点）后再添加新节点。
        /// </summary>
        /// <param name="position"></param>
        /// <param name="radius"></param>
        /// <param name="arrivalRadius"></param>
        public void AddNode(Vector2 position, float radius = 32f, float arrivalRadius = 36f)
        {
            if (NodeCount < MaxNodes) // 检查是否还有空间添加新节点
            {
                PathNode pathNode = new PathNode(position, null, radius, arrivalRadius);
                if (NodeCount > 0) // 如果这不是第一个节点，则设置其 NextNode 属性指向当前最后一个节点
                    pathNode.NextNode = _nodes[NodeCount - 1];
                _nodes.Add(pathNode); // 将新节点添加到路径中
            }
            else
            {
                RemoveTargetNode(); // 如果达到最大节点数，先移除目标节点
                AddNode(position); // 再次尝试添加新节点
            }
        }

        // 获取路径的目标节点（即第一个节点），如果没有节点则返回 null。
        public PathNode GetTargetNode()
        {
            if (NodeCount > 0)
                return _nodes[0]; // 返回第一个节点作为目标节点
            return null;
        }

        // 移除路径的目标节点（即第一个节点）。
        public void RemoveTargetNode()
        {
            if (NodeCount > 0)
                _nodes.Remove(GetTargetNode()); // 移除第一个节点
        }

        // 实现 IEnumerable<PathNode> 接口，提供对路径节点的枚举。
        public IEnumerator<PathNode> GetEnumerator()
        {
            return _nodes.GetEnumerator(); // 返回节点列表的枚举器
        }

        // 显式实现 IEnumerable.GetEnumerator 方法，支持非泛型的枚举。
        IEnumerator IEnumerable.GetEnumerator()
        {
            return GetEnumerator(); // 调用泛型版本的方法
        }
    }
}