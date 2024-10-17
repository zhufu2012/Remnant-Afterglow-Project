using Godot;

namespace Remnant_Afterglow
{
    //模组界面
    public partial class ModView : Control
    {
        //返回按钮,点击返回主菜单
        public Button ReturnButton = new Button();
        //点击刷新模组界面-（用于将刚激活的模组，移动到上面来）
        public Button FlushButton = new Button();

        //所有模组,当前加载的不在
        public VBoxContainer AllModCon = new VBoxContainer();
        //当前加载的模组
        public VBoxContainer LoadModCon = new VBoxContainer();

        public override void _Ready()
        {



        }
    }
}















