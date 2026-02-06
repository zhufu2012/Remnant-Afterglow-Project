using GameLog;
using Godot;

namespace Remnant_Afterglow
{
	public partial class BuildList : Control
	{

		TextureButton button1;
		TextureButton button2;
		TextureButton button3;
		TextureButton button4;
		public SubBuildList subBuildList;
		public BuildInfoView buildInfoView;
		/// <summary>
		/// 高亮图
		/// </summary>
		public TextureRect texture;


		public override void _Ready()
		{
			texture = GetNode<TextureRect>("按钮高亮");
			button1 = GetNode<TextureButton>("采集列表");
			button2 = GetNode<TextureButton>("武器列表");
			button3 = GetNode<TextureButton>("防御列表");
			button4 = GetNode<TextureButton>("辅助列表");
			subBuildList = GetNode<SubBuildList>("SubBuildList");
			buildInfoView = GetNode<BuildInfoView>("BuildInfoView");
			button1.ButtonDown += Button1_ButtonDown;
			button2.ButtonDown += Button2_ButtonDown;
			button3.ButtonDown += Button3_ButtonDown;
			button4.ButtonDown += Button4_ButtonDown;
		}


		private void Button1_ButtonDown()
		{
			SetButtonType(SubBuildListType.Select1);
		}
		private void Button2_ButtonDown()
		{
			SetButtonType(SubBuildListType.Select2);
		}
		private void Button3_ButtonDown()
		{
			SetButtonType(SubBuildListType.Select3);
		}

		private void Button4_ButtonDown()
		{
			SetButtonType(SubBuildListType.Select4);
		}
		/// <summary>
		/// 按钮状态修改
		/// </summary>
		/// <param name="type"></param>
		public void SetButtonType(SubBuildListType type)
		{
			if (!subBuildList.IsAnima)//如果动画不在播放
			{
				if (subBuildList.AnimaType)//如果是开启状态
				{
					if (subBuildList.type == type)//新旧状态相同，就关闭
						SetHighLight(SubBuildListType.NoSelect);
					else
					{
						SetHighLight(type);
						
					}
					subBuildList.SetView(false, type);
					
				}
				else
				{
					SetHighLight(type);
					subBuildList.SetView(true, type);
				}
			}
		}

		/// <summary>
		/// 设置建筑类型的高亮状态
		/// </summary>
		/// <param name="type"></param>
		public void SetHighLight(SubBuildListType type)
		{
			switch (type)
			{
				case SubBuildListType.NoSelect:
					texture.Visible = false;
					break;
				case SubBuildListType.Select1:
					texture.Position = button1.Position;
					texture.Visible = true;
					break;
				case SubBuildListType.Select2:
					texture.Position = button2.Position;
					texture.Visible = true;
					break;
				case SubBuildListType.Select3:
					texture.Position = button3.Position;
					texture.Visible = true;
					break;
				case SubBuildListType.Select4:
					texture.Position = button4.Position;
					texture.Visible = true;
					break;
				default:
					break;
			}
		}


		public override void _Process(double delta)
		{
		}
	}
}
