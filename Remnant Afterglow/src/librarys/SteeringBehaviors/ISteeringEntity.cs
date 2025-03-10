using Godot;
using System;
namespace SteeringBehaviors
{
    // 定义实现转向行为的实体必须遵循的接口。
    public interface ISteeringEntity
    {
        // 当实体重置时触发的事件。
        event EventHandler ResetEvent;

        // 实体当前位置。
        Vector2 Position { get; set; }

        // 实体期望达到的速度（理想速度），通常由转向行为算法计算得出。
        Vector2 DesiredVelocity { get; set; }

        // 实体当前的实际速度。
        Vector2 Velocity { get; set; }

        // 应用到实体上的转向力，即通过转向行为计算出的调整量。
        Vector2 Steering { get; set; }

        // 实体能够达到的最大速度。
        float MaxVelocity { get; set; }

        // 可以应用到实体上的最大转向力。
        float MaxForce { get; set; }

        // 实体的质量，影响加速度和转向力的效果。
        float Mass { get; set; }

        // 实体的旋转角度，可以用于表示朝向或方向。
        float Rotation { get; set; }

        // 重置实体的状态，例如位置、速度等。
        void Reset();
    }
}