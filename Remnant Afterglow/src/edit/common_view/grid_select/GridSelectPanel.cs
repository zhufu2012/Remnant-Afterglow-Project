using Godot;
using Remnant_Afterglow;
using System.Collections.Generic;

namespace Remnant_Afterglow_EditMap
{
	/// <summary>
	/// 材料格子选择器
	/// </summary>
	public partial class GridSelectPanel : Control
	{
		/// <summary>
		/// 地图类型 1是作战地图 2 是大地图
		/// </summary>
		public int Type = 1;
		public TabContainer tabContainer;
		/// <summary>
		/// 地图材料列表
		/// </summary>
		public List<MapFixedSet> DataList;



		/// <summary>
		/// 图集字典  图集id,单图集控件
		/// </summary>
		public Dictionary<int, GridSelectCon> gridConDict = new Dictionary<int, GridSelectCon>();

		#region

		public Label lab_MaterialId;
		public Label lab_Name;
		public Label lab_ImageSetId;
		public Label lab_ImageSetIndex;
		public Label lab_ImageLayer;
		public Button but_Material;

		public void IntView()
		{
			lab_MaterialId = GetNode<Label>("Control/Panel/Id");
			lab_Name = GetNode<Label>("Control/Panel/Name");
			lab_ImageSetId = GetNode<Label>("Control/Panel/ImageSetId");
			lab_ImageSetIndex = GetNode<Label>("Control/Panel/ImageSetIndex");
			lab_ImageLayer = GetNode<Label>("Control/Panel/ImageLayer");
			but_Material = GetNode<Button>("Control/Panel/Button");

		}

		/// <summary>
		/// 设置材料栏数据
		/// </summary>
		public void UpdataMaterial()
		{
			MapFixedMaterial material = GetSelectMaterial();
			lab_MaterialId.Text = "材料ID:" + material.MaterialId;
			lab_Name.Text = "材料名称：" + material.MaterialName;
			lab_ImageSetId.Text = "图集ID：" + material.ImageSetId;
			lab_ImageSetIndex.Text = "图集序号：" + material.ImageSetIndex;
			lab_ImageLayer.Text = "所在图层：" + GetSelectCon().cfgData.ImageLayer;
			but_Material.Icon = GetSelectTexture2D();
		}

		#endregion

		/// <summary>
		/// 构造函数
		/// </summary>
		public GridSelectPanel()
		{
			DataList = ConfigCache.GetAllMapFixedSet();
		}


		/// <summary>
		/// 
		/// </summary>
		/// <param name="Type">0 作战地图  1是大地图</param>
		public void InitData(int Type)
		{
			this.Type = Type;
			DataList = ConfigCache.GetAllMapFixedSet();
		}

		public override void _Ready()
		{
			tabContainer = GetNode<TabContainer>("TabContainer");
			foreach (var item in DataList)
			{
				GridSelectCon control = (GridSelectCon)GD.Load<PackedScene>("res://src/edit/common_view/grid_select/GridSelectCon.tscn").Instantiate();
				control.InitData(item,Type);
				tabContainer.AddChild(control);
				gridConDict[item.EditImageSetId] = control;
			}
			IntView();
		}

		/// <summary>
		/// 返还当前选择的分页控件
		/// </summary>
		/// <returns></returns>
		public GridSelectCon GetSelectCon()
		{

			return (GridSelectCon)tabContainer.GetCurrentTabControl();
		}

		/// <summary>
		/// 返回当前选择的材料
		/// </summary>
		/// <returns></returns>
		public MapFixedMaterial GetSelectMaterial()
		{
			GridSelectCon con = (GridSelectCon)tabContainer.GetCurrentTabControl();
			return con.GetSelectMaterial();
		}

		/// <summary>
		/// 返回当前选择的材料图
		/// </summary>
		/// <returns></returns>
		public Texture2D GetSelectTexture2D()
		{
			GridSelectCon con = (GridSelectCon)tabContainer.GetCurrentTabControl();
			return con.GetSelectTexture2D();
		}

	}
}
