using GameLog;
using Godot;
using Godot.Community.ManagedAttributes;

namespace Remnant_Afterglow
{
    public partial class UnitDemo : Node
    {
        private FloatManagedAttribute healthAttribute;
        private ulong Tick = 0;

        public override void _Ready()
        {
            // 初始化血量属性
            healthAttribute = new FloatManagedAttribute(1, 500f, 0f, 1000f, -5f);
            // 设置血量属性的初始值
            //healthAttribute.Set(500f, AttributeValueType.Value);
            //healthAttribute.Set(1000f, AttributeValueType.Max);
            //healthAttribute.Set(0f, AttributeValueType.Min);
            //healthAttribute.Set(0.1f, AttributeValueType.Regen);
            Log.Print(healthAttribute.GetRaw<float>(AttributeValueType.Value));
            // 注册血量变化的事件处理器
            healthAttribute.AttributeUpdated += HandleHealthUpdated;
        }

        private void HandleHealthUpdated(IManagedAttribute attribute)
        {
            // 检查血量是否为0
            if (attribute.Get<float>(AttributeValueType.Value) <= 0)
            {
                GD.Print("单位死亡");
            }
        }

        public override void _PhysicsProcess(double delta)
        {
            base._PhysicsProcess(delta);
            Tick += 1;
            // 每帧更新血量属性
            healthAttribute.Update(Tick);
            Log.Print(healthAttribute.GetObj(AttributeValueType.Value));
        }
    }
}