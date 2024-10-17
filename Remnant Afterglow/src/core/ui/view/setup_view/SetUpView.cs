using Godot;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 设置界面
    /// </summary>
    public partial class SetUpView : ViewObject
    {
        public Button button1;
        public Button button2;
        public Button button3;
        public Button button4;
        public Button button5;
        public SetUpView(int cfgId) : base(cfgId)
        {
        }

        public override void _Ready()
        {
            AddChild(panel);
        }


    }
}
