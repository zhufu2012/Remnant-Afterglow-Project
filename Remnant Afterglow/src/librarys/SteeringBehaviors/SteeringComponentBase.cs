using Godot;
using System;
namespace SteeringBehaviors
{
    // 抽象类，作为所有具体转向行为组件的基础类。
    public  abstract partial class SteeringComponentBase :Node, ISteeringBehavior
    {
        // 可以在编辑器中检查和修改的属性，表示与该转向行为关联的实体。
        public ISteeringEntity SteeringEntity { get; set; }

        // 可以在编辑器中检查和修改的属性，表示此转向行为是否是累加性的。
        public bool IsAdditive { get; set; }

        // 一个条件谓词，用于确定是否应用此转向行为。
        public Predicate<ConditionArgs> Condition { get; set; }

        // 嵌套的转向行为，允许组合多个转向行为。
        public ISteeringBehavior NestedBehavior { get; set; }

        // 初始化方法，在组件被添加到实体时调用。
        public void intData(ISteeringEntity Entity)
        {
            SteeringEntity = Entity;
        }

        // 抽象方法，子类必须实现此方法来计算转向力。
        public abstract Vector2 Steer(ISteeringTarget target);

        // 当组件从实体移除时调用的方法。
        public override void _ExitTree()
        {
        
            // 如果转向实体存在，则重置它。
            if (SteeringEntity != null)
            {
                SteeringEntity.Reset();
            }
        }

        // 当组件被添加到实体时调用的方法。
        public override void _EnterTree() 
        {
            // 如果转向实体存在，则重置它。
            if (SteeringEntity != null)
            {
                SteeringEntity.Reset();
            }
        }
    }
}