using Godot;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 科技树配置界面
    /// </summary>
    public partial class ScienceDeployView : ViewObject
    {
        public ScienceDeployView(int cfgId) : base(cfgId)
        {
        }

        public override void _Ready()
        {
            AddChild(panel);
        }


    }
}
