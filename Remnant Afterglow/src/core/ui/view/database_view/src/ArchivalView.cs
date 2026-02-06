using Godot;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
	public partial class ArchivalView : Node2D
	{
		/// <summary>
		/// 子项容器
		/// </summary>
		CarouselContainer carouselContainer;

		/// <summary>
		/// 势力项 容器
		/// </summary>
		HBoxContainer hBoxContainer;

		Button ReturnBut;
		public override void _Ready()
		{
			hBoxContainer = GetNode<HBoxContainer>("ScrollContainer/HBoxContainer");
			carouselContainer = GetNode<CarouselContainer>("CarouselContainer");
			ReturnBut = GetNode<Button>("设置按钮/设置图标/Button");
			List<Archival> archivalList = ConfigCache.GetAllArchival();
			foreach (Archival archival in archivalList)
			{
				Control control = CreateArcjovalControl(archival);
				hBoxContainer.AddChild(control);
				//增加档案库大项
			}
			ReturnBut.ButtonDown += ReturnView;
		}

		/// <summary>
		/// 返回上一个界面
		/// </summary>
		public void ReturnView()
		{
			SceneManager.ChangeSceneBackward(this);
		}

		public Control CreateArcjovalControl(Archival archival)
		{
			Control control = (Control)GD.Load<PackedScene>("res://src/core/ui/view/database_view/scene/ArcjovalControl.tscn").Instantiate(); ;
			Button button = control.GetNode<Button>("Button");
			button.Text = archival.Name;
			return control;
		}



	}
}
