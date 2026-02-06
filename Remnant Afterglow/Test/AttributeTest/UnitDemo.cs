using GameLog;
using Godot;
using ManagedAttributes;

namespace Remnant_Afterglow
{
    public partial class UnitDemo : Node
    {
        private AttrData healthAttribute;
        private ulong Tick = 0;

        public override void _Ready()
        {
            // 初始化血量属性
            healthAttribute = new AttrData(1, 500f, 0f, 1000f, -5f);
            // 设置血量属性的初始值
            //healthAttribute.Set(500f, AttrDataType.Value);
            //healthAttribute.Set(1000f, AttrDataType.Max);
            //healthAttribute.Set(0f, AttrDataType.Min);
            //healthAttribute.Set(0.1f, AttrDataType.Regen);
            Log.Print(healthAttribute.GetRaw<float>(AttrDataType.Value));
            // 注册血量变化的事件处理器
            healthAttribute.AttributeUpdated += HandleHealthUpdated;
        }

        private void HandleHealthUpdated(IAttrData attribute)
        {
            // 检查血量是否为0
            if (attribute.Get<float>(AttrDataType.Value) <= 0)
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
            Log.Print(healthAttribute.GetObj(AttrDataType.Value));
        }
    }
}