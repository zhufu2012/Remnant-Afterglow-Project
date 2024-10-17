using Godot;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 道具配置界面
    /// </summary>
    public partial class ItemDeployView : ViewObject
    {
        public ItemDeployView(int cfgId) : base(cfgId)
        {
        }

        public override void _Ready()
        {
            AddChild(panel);
        }


    }
}
