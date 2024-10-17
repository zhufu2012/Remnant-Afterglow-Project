

using Godot;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 配置界面
    /// </summary>
    public partial class DeployView : ViewObject
    {
        public DeployView(int cfgId) : base(cfgId)
        {
        }

        public override void _Ready()
        {
            AddChild(panel);
        }
    }
}
