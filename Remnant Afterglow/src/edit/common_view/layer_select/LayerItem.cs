using GameLog;
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
		public CheckButton checkButton;

		//层配置
		public MapImageLayer cfgData;

		//是否启用层-显示图层该层
		public bool IsUser = true;
		//初始化
		public void InitData(MapImageLayer cfgData)
		{
			this.cfgData = cfgData;
		}

		public override void _Ready()
		{
			labelName = GetNode<Label>("Panel/Label");
			checkButton = GetNode<CheckButton>("Panel/CheckButton");

			labelName.Text = ""+cfgData.ImageLayerId+"  "+cfgData.LayerName;
			checkButton.ButtonPressed = IsUser;
			
		}


	}
}
