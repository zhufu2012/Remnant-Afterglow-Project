using GameLog;
using Godot;
using Godot.Community.ManagedAttributes;
using Remnant_Afterglow;
using System;

namespace Project_Core_Test
{

    /// <summary>
    /// 测试单位属性
    /// </summary>
    public partial class UnitDemoSystem : Node
    {
        [Export] public int UnitCount = 100;

        [Export] public ulong tick = 0;

        public Node2D UnitList;


        public override void _Ready()
        {
            UnitList = GetNode<Node2D>("UnitList");
            for (int i = 0; i < UnitCount; i++)
            {
                UnitBase unit = new UnitBase(1, 1);
                UnitList.AddChild(unit);
            }
            FloatManagedAttribute f1 = new FloatManagedAttribute(1, 1000);
            FloatManagedAttribute f2 = new FloatManagedAttribute(2, 1000);
            Func<float, float, float, float, float, float, float, float, float> func = (Func<float, float, float, float, float, float, float, float, float>)TemplateCache.GetCompiledDelegate(ConfigConstant.Config_AttrDependency, "" + 1);

            // 执行委托
            float result = func(f1.CurrentValue, f1.MaxValue, f1.MinValue, f1.RegenValue, f2.CurrentValue, f2.MaxValue, f2.MinValue, f2.RegenValue);
            //Log.Print($"结果: {result}");

        }



    }
}
