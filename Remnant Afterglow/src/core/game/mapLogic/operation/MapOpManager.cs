using Godot;

namespace Remnant_Afterglow
{
	/// <summary>
	/// 关卡内玩家操作管理器
	/// </summary>
	public partial class MapOpManager : CanvasLayer
	{
		#region 界面绘制
		public TextureRect Map_Setting_1;
		public TextureRect Map_ItemView_Img_3;
		public TextureRect Map_ItemView_Img_4;
		public TextureRect Map_ItemView_Img_5;
		public TextureRect Map_Resources_1;

		/// <summary>
		/// 建造系统放置节点
		/// </summary>
		public Node2D BuildShowNode;
		/// <summary>
		/// 建造系统
		/// </summary>
		public ObjectBuildSystem buildSystem;

		/// <summary>
		/// 初始化界面
		/// </summary>
		public void InitView()
		{
			Map_Setting_1 = GetNode<TextureRect>("Control/Map_Setting_1");
			Map_ItemView_Img_3 = GetNode<TextureRect>("Control/Map_ItemView_Img_3");
			Map_ItemView_Img_4 = GetNode<TextureRect>("Control/Map_ItemView_Img_4");
			Map_ItemView_Img_5 = GetNode<TextureRect>("Control/Map_ItemView_Img_5");
			Map_Resources_1 = GetNode<TextureRect>("Control/Map_Resources_1");

			Map_Setting_1.Texture = ConfigCache.GetGlobal_Png("Map_Setting_1");
			Map_ItemView_Img_3.Texture = ConfigCache.GetGlobal_Png("Map_ItemView_Img_3");
			Map_ItemView_Img_4.Texture = ConfigCache.GetGlobal_Png("Map_ItemView_Img_4");
			Map_ItemView_Img_5.Texture = ConfigCache.GetGlobal_Png("Map_ItemView_Img_5");
			Map_Resources_1.Texture = ConfigCache.GetGlobal_Png("Map_Resources_1");
		}

		#endregion

		#region 防御塔操作
		/// <summary>
		/// 当前拖动的塔
		/// </summary>
		private TowerBase heldTower { get; set; }
		/// <summary>
		/// 当前选中的塔
		/// </summary>
		private TowerBase selectedTower { get; set; }
		/// <summary>
		/// 删除选中
		/// </summary>
		private void DeselectTower()
		{
			if (IsInstanceValid(heldTower))
				heldTower.QueueFree();
			if (!IsInstanceValid(selectedTower))
				return;
			selectedTower.isSelected = false;
			selectedTower.QueueRedraw();
			selectedTower = null;
			GetNode<Control>("HUD/SelectedTowerPanel").Hide();
		}

		//选中防御塔
		private void SelectTower(TowerBase tower)
		{
			if (selectedTower is not null)
			{
				selectedTower.isSelected = false;
				selectedTower.QueueRedraw();
			}
			selectedTower = tower;
			tower.isSelected = true;
			selectedTower.QueueRedraw();
		}
		#endregion


		public override void _Ready()
		{
			InitView();
			buildSystem = (ObjectBuildSystem)GD.Load<PackedScene>("res://src/core/game/mapLogic/operation/objectBuildSystem/ObjectBuildSystem.tscn").Instantiate();
			buildSystem.IniData(BuildShowNode);
			buildSystem.SetAnchorsPreset(Control.LayoutPreset.CenterBottom);
			AddChild(buildSystem);
		}


		public override void _UnhandledInput(InputEvent @event)
		{
			base._UnhandledInput(@event);
		}

		public override void _Input(InputEvent ev)
		{
			if (IsInstanceValid(heldTower))
			{
			}
		}
	}
}
