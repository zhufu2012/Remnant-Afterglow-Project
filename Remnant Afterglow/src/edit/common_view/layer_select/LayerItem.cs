using Godot;
using Remnant_Afterglow;
using System;
namespace Remnant_Afterglow_EditMap
{
    //层控件
    public partial class LayerItem : Control
    {
        //层名称
        public Label labelName;
        //是否启用层的选择按钮
        public CheckButton button;

        //层配置
        public MapImageLayer cfgData;

        //是否启用层
        public bool IsUser;
        //是否亮起,选择地图材料时，会修改对应层的颜色为亮起，表示该材料是对应层的材料
        public bool IsLight;
        //初始化
        public void InitData(MapImageLayer cfgData)
        {
            this.cfgData = cfgData;
        }

        public override void _Ready()
        {
            labelName = GetNode<Label>("Panel/Label");
            button = new CheckButton();
            button.Toggled += ButtonToggled;
        }

        //按钮状态被切换
        public void ButtonToggled(bool toggled_on)
        {
            IsUser = toggled_on;
            //按照现在的状态，更新tileMap的显示，
        }
    }
}