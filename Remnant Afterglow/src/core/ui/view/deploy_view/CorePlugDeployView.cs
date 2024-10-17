using Godot;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 核心插件配置界面
    /// </summary>
    public partial class CorePlugDeployView : ViewObject
    {
        public CorePlugDeployView(int cfgId) : base(cfgId)
        {
        }

        public override void _Ready()
        {
            AddChild(panel);
        }


    }
}
