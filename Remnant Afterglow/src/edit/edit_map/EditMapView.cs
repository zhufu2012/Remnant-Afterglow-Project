using GameLog;
using Godot;
using Remnant_Afterglow;
using System.Collections.Generic;

namespace Remnant_Afterglow_EditMap
{
	/// <summary>
	/// 作战地图编辑器
	/// </summary>
	public partial class EditMapView : Control
	{
		#region 控件
		/// <summary>
		/// 返回按钮,点击返回上一个页面
		/// </summary>
		public Button ReturnButton = new Button();
		/// <summary>
		/// 保存地图按钮
		/// </summary>
		public Button SaveButton = new Button();
		/// <summary>
		/// 不使用地图模板
		/// </summary>
		public OptionButton optionButton = new OptionButton();
		/// <summary>
		/// 地图控件
		/// </summary>
		public EditTileMap tileMap;
		/// <summary>
		/// 绘制地图辅助线和地图坐标等
		/// </summary>
		public MapHelpControl mapControl;


		public EditCamera2D editCamera2D;
		/// <summary>
		/// 图层选择器
		/// </summary>
		public LayerSelectPanel layerSelectPanel;

		public ToolContainer toolContainer;
		/// <summary>
		/// 选择器下拉菜单
		/// </summary>
		public OptionButton selectOption;
		/// <summary>
		/// 材料选择器
		/// </summary>
		public GridSelectPanel gridSelectPanel;
		/// <summary>
		/// 实体选择器
		/// </summary>
		public EntitySelectPanel entitySelectPanel;
		#endregion
		/// <summary>
		/// 地图当前大小
		/// </summary>
		public Vector2I MapSize = EditConstant.Define_MapSize;

		public int mapType = 1;
		/// <summary>
		/// 当前的地图数据的路径
		/// </summary>
		public string nowPath;
		/// <summary>
		/// 当前的地图数据的文件名称
		/// </summary>
		public string mapName;
		/// <summary>
		/// 当前使用的地图数据
		/// </summary>
		public MapDrawData nowMapData;

		/// <summary>
		/// 实体管理器单例
		/// </summary>
		public static EditMapView Instance { get; set; }


		/// <summary>
		/// 构造函数
		/// </summary>
		public EditMapView()
		{
			Instance = this;
			mapType = (int)SceneManager.GetParam("MapType");
			nowPath = (string)SceneManager.GetParam("MapDataPath");
			mapName = (string)SceneManager.GetParam("MapName");
			SceneManager.DataClear();//清空数据
			nowMapData = MapDrawData.GetMapDrawData(nowPath, mapName);
		}

		/// <summary>
		/// 进入场景树
		/// </summary>
		public override void _EnterTree()
		{
			LoadMapConfig.InitData();
		}

		/// <summary>
		/// 退出场景树
		/// </summary>
		public override void _ExitTree()
		{
			LoadMapConfig.ClearData();
			Instance = null;
		}

		public override void _Ready()
		{
			InitMapCfg();
			InitView();
		}

		/// <summary>
		/// 初始化地图配置
		/// </summary>
		public void InitMapCfg()
		{
			//祝福注释-这里需要加场景文件
			//tileMap = (EditTileMap)GD.Load<PackedScene>("res://src/edit/edit_map/tileMap/EditTileMap.tscn").Instantiate();
			tileMap = GetNode<EditTileMap>("EditTileMap");
			tileMap.InitData(nowMapData);
			mapControl = GetNode<MapHelpControl>("EditTileMap/MapHelpControl");
			mapControl.InitData();
		}

		public void InitView()
		{
			ReturnButton = GetNode<Button>("Camera2D/CanvasLayer/ReturnButton");
			ReturnButton.ButtonDown += ReturnView;
			SaveButton = GetNode<Button>("Camera2D/CanvasLayer/SaveButton");
			SaveButton.ButtonDown += OnSaveButton;
			editCamera2D = (EditCamera2D)GetNode<Camera2D>("Camera2D");
			gridSelectPanel = (GridSelectPanel)GetNode<Control>("Camera2D/CanvasLayer/GridSelectPanel");
			gridSelectPanel.InitData(1);//作战地图-材料格子初始化
			entitySelectPanel = (EntitySelectPanel)GetNode<Control>("Camera2D/CanvasLayer/EntitySelectPanel");
			layerSelectPanel = (LayerSelectPanel)GetNode<Control>("Camera2D/CanvasLayer/LayerSelectPane");
			toolContainer = (ToolContainer)GetNode<GridContainer>("Camera2D/CanvasLayer/ToolContainer");
			selectOption = GetNode<OptionButton>("Camera2D/CanvasLayer/selectOption");
			selectOption.ItemSelected += SelectOption_ItemSelected;
		}

		/// <summary>
		/// 修改选择
		/// </summary>
		/// <param name="index"></param>
		/// <exception cref="System.NotImplementedException"></exception>
		private void SelectOption_ItemSelected(long index)
		{
			if (index == 0)
			{
				gridSelectPanel.Visible = true;
				entitySelectPanel.Visible = false;
			}
			else
			{
				gridSelectPanel.Visible = false;
				entitySelectPanel.Visible = true;
			}
		}

		/// <summary>
		/// 返回上一个界面
		/// </summary>
		public void ReturnView()
		{
			SceneManager.ChangeSceneBackward(this);
		}

		/// <summary>
		/// 保存数据
		/// </summary>
		public void OnSaveButton()
		{
			SaveMap();
		}

		/// <summary>
		/// 保存当前地图
		/// </summary>
		public void SaveMap()
		{
			switch (mapType)
			{
				case EditConstant.MapType://作战地图
					break;
				case EditConstant.TempMapType://地图模板
					break;
				default:
					break;
			}

			nowMapData.SetMapData(tileMap.layerData, tileMap.entityDict);//设置地图图块数据
			nowMapData.SaveData(nowPath, mapName);
		}



	}
}
