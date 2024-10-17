

using Godot;

namespace Remnant_Afterglow
{
    public partial class ViewObject : Control
    {
        public ViewBase cfgData { get; set; }

        public Panel panel = new Panel();
        //ui界面cfgid
        public ViewObject(int cfgId)
        {
            cfgData = new ViewBase(cfgId);
            panel.Size = cfgData.ViewSize;
            panel.Position = cfgData.ViewPos;
            panel.SelfModulate = cfgData.BackdropColor;
        }


    }
}
