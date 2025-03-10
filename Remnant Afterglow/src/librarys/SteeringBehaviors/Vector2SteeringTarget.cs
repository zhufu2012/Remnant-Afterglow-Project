using Godot;

namespace SteeringBehaviors
{
    /// <summary>
    /// 表示一个基于 Vector2 的转向目标，实现了 ISteeringTarget 接口。
    /// </summary>
    public struct Vector2SteeringTarget : ISteeringTarget
    {
        // 目标位置，表示转向行为的目标点。
        public Vector2 Position { get; set; }

        // 表示该目标是否是实际存在的目标，默认返回 true。
        public bool IsActual => true;

        // 构造函数，允许通过提供一个 Vector2 来初始化一个新的 Vector2SteeringTarget 实例。
        public Vector2SteeringTarget(Vector2 value)
        {
            Position = value;
        }

        // 显式转换操作符，允许从 Vector2 类型显式转换为 Vector2SteeringTarget 类型。
        public static explicit operator Vector2SteeringTarget(Vector2 value)
        {
            return new Vector2SteeringTarget(value);
        }

        // 显式转换操作符，允许从 Vector2SteeringTarget 类型显式转换回 Vector2 类型。
        public static explicit operator Vector2(Vector2SteeringTarget value)
        {
            return value.Position;
        }
    }
}