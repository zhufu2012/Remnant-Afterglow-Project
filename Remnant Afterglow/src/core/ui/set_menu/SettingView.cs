using GameLog;
using Godot;

namespace Remnant_Afterglow
{
    //设置界面
    public partial class SettingView : Control
    {
        /// <summary>
        /// 返回按钮,点击返回主菜单
        /// </summary>
        public Button ReturnButton = new Button();
        public override void _Ready()
        {
            InitView();
        }

        public void InitView()
        {
            ReturnButton = GetNode<Button>("Panel/ReturnView");
            ReturnButton.ButtonDown += ReturnView;
        }

        /// <summary>
        /// 返回上一个界面
        /// </summary>
        public void ReturnView()
        {
            SceneManager.ChangeSceneBackward(this);
        }

        public override void _UnhandledInput(InputEvent @event)
        {
            if (@event.IsActionPressed(KeyConstant.Input_Key_ESC))
            {
                ReturnView();
            }
        }
    }
}