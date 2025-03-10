using Godot;

namespace SteeringBehaviors
{
    // 定义转向行为的目标对象必须实现的接口。
    public interface ISteeringTarget
    {
        // 获取或设置目标的位置。
        Vector2 Position { get; set; }

        // 获取一个布尔值，指示该目标是否是实际存在的目标。
        bool IsActual { get; }
    }
}