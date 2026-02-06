using GameLog;
using Godot;
using Remnant_Afterglow;
using System;
using System.Collections.Generic;
namespace Remnant_Afterglow_EditMap
{
	public partial class LayerSelectPanel : Control
	{
		public ScrollContainer scroll;
		public VBoxContainer vbox;

		//层数据字典<层id,层配置数据>
		public Dictionary<int, MapImageLayer> layerCfgDataDict = new Dictionary<int, MapImageLayer>();
		//层 字典<层id,层控件>
		public Dictionary<int, LayerItem> layerItemDict = new Dictionary<int, LayerItem>();

		/// <summary>
		/// 构造函数
		/// </summary>
		public LayerSelectPanel()
		{
			List<MapImageLayer> list = ConfigCache.GetAllMapImageLayer();
			foreach (var cfgData in list)
			{
				layerCfgDataDict[cfgData.ImageLayerId] = cfgData;
			}
		}

		public override void _Ready()
		{
			scroll = GetNode<ScrollContainer>("Panel/ScrollContainer");
			vbox = GetNode<VBoxContainer>("Panel/ScrollContainer/VBoxContainer");
			foreach (var cfgData in layerCfgDataDict)
			{
				LayerItem item = (LayerItem)GD.Load<PackedScene>("res://src/edit/common_view/layer_select/LayerItem.tscn").Instantiate();
				item.InitData(cfgData.Value);
				vbox.AddChild(item);
				if (EditMapView.Instance.nowMapData.NowShowLayer.Contains(cfgData.Value.ImageLayerId))//存在
				{
					item.GetNode<CheckButton>("Panel/CheckButton").ButtonPressed = true;
				}
				item.checkButton.Toggled += (bool toggled_on) =>
				{//按钮状态被切换
					item.IsUser = toggled_on;
					EditMapView.Instance.tileMap.FlushLayer(item.cfgData.ImageLayerId, item.IsUser);
				};
				layerItemDict[cfgData.Key] = item;
			}
		}

		/// <summary>
		/// 返回当前选中层id
		/// </summary>
		/// <returns></returns>
		public List<int> GetSelectLayerList()
		{
			List<int> selectList = new List<int>();
			foreach (var info in layerItemDict)
			{
				if (info.Value.IsUser)//是否选中
				{
					selectList.Add(info.Key);
				}
			}
			return selectList;
		}


		/// <summary>
		/// 当前选中绘制的层控件
		/// </summary>
		/// <returns></returns>
		public LayerItem GetNowLayerItem()
		{
			return layerItemDict[EditMapView.Instance.nowMapData.NowLayer];
		}

		/// <summary>
		/// 当前选中绘制的层控件
		/// </summary>
		/// <returns></returns>
		public void ClearLayerItemColor()
		{
			foreach(LayerItem item in layerItemDict.Values)
			{
				item.Modulate = EditConstant.MapLayerSelectPanel_DefineLayerColor;
			}
		}
	}
}
