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
        //构造函数
        public GridSelectPanel()
        {
            DataList = ConfigCache.GetAllMapFixedSet();
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="Type">0 作战地图  1是大地图</param>
        public GridSelectPanel(int Type)
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
        }

        //返还当前选择的分页控件
        public GridSelectCon GetSelectCon()
        {
            return GetCurrentTabControl();
        }

        //返回当前选择的材料
        public MapFixedMaterial GetSelectMaterial()
        {
            GridSelectCon con = GetCurrentTabControl();
            return con.GetSelectMaterial();
        }
    }
}