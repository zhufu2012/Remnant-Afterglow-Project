using Godot;

namespace SteeringBehaviors
{
    // 路径点，用于指导实体从一个位置移动到另一个位置。
    public class PathNode
    {
        // 下一个路径节点，形成链表结构以表示整个路径。
        public PathNode NextNode { get; set; }

        // 目标位置，实体将尝试到达这个位置。
        public Vector2 Target { get; set; }

        // 目标半径，当实体进入此范围内时，可以认为它已经到达目标。
        public float TargetRadius { get; set; }

        // 到达半径，定义了实体接近目标时应该开始减速的距离。
        public float ArrivalRadius { get; set; }

        // 构造函数，初始化具有默认半径值的路径节点。
        // 默认情况下，TargetRadius 为 6f，ArrivalRadius 为 32f，且没有下一个节点（NextNode 为 null）。
        public PathNode(Vector2 position)
            : this(position, null, 6f, 32f)
        {
            // 使用带有所有参数的构造函数进行初始化。
        }

        // 构造函数，允许自定义设置路径节点的所有属性。
        public PathNode(Vector2 position, PathNode next, float radius, float arrivalRadius)
        {
            // 设置下一个路径节点。
            NextNode = next;
            // 设置目标位置。
            Target = position;
            // 设置目标半径。
            TargetRadius = radius;
            // 设置到达半径。
            ArrivalRadius = arrivalRadius;
        }
    }
}