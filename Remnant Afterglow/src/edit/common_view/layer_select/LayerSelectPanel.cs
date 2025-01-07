using Godot;
using System;
namespace Remnant_Afterglow_EditMap
{
    public partial class LayerSelectPanel : Control
    {
        public ScrollContainer scroll;
        public VBoxContainer vbox;
        //层数据字典<层id,层配置数据>
        public Dictionary<int, MapImageLayer> layerCfgDataDict;
        //层 字典<层id,层控件>
        public  Dictionary<int, LayerItem> layerItemDict = new Dictionary<int, LayerItem>();

        //初始化
        public LayerSelectPanel()
        {
            List<MapImageLayer> list = ConfigCache.GetAllMapImageLayer();
            foreach(var cfgData in list)
            {
                layerCfgDataDict[cfgData.ImageLayerId] = cfgData;
            }
        }

        public override void _Ready()
        {
            scroll = GetNode<ScrollContainer>("ScrollContainer");
            vbox = GetNode<VBoxContainer>("ScrollContainer/VBoxContainer");
            foreach(var cfgData in list)
            {
                LayerItem item = (LayerItem)GD.Load<PackedScene>("res://src/edit/common_view/layer_select/LayerItem.tscn").Instantiate();
                item.InitData(cfgData);
                vbox.AddChild(item);
            }
        }

        public override void _Process(double delta)
        {
        }
    }
}