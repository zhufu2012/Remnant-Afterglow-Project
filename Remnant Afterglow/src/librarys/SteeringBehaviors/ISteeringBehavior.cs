using Godot;
using System;

namespace SteeringBehaviors
{
    // 定义转向行为的公共接口。
    public interface ISteeringBehavior
    {
        // 获取或设置与该转向行为关联的实体。
        ISteeringEntity SteeringEntity { get; set; }

        // 根据给定的目标计算并返回应用于实体的转向力。
        Vector2 Steer(ISteeringTarget target);

        // 获取或设置一个条件谓词，用于确定是否应用此转向行为。
        Predicate<ConditionArgs> Condition { get; set; }

        // 获取或设置嵌套的转向行为，允许组合多个转向行为。
        ISteeringBehavior NestedBehavior { get; set; }
    }
}