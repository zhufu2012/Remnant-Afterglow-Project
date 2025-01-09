using GameLog;
using Godot;
using Remnant_Afterglow;
using System.Collections.Generic;

namespace Remnant_Afterglow_EditMap
{
	public partial class GridSelectCon : Control
	{
		/// <summary>
		/// 地图配置
		/// </summary>
		MapFixedSet cfgData;
		//材料数据字典<固定材料id,地图材料配置>
        Dictionary<int,MapFixedMaterial>  mapFixedMaterialDict = new Dictionary<int,MapFixedMaterial>();
		//图集数据<地图编辑器图集id，>
		Dictionary<int,ImageSetData>  imageSetDataDict = new Dictionary<int,ImageSetData>();

        GridContainer gridContainer;
		///地图类型
		public int Type;
        //当前选择的材料数据
        public MapFixedMaterial select;

		public MapFixedMaterial material;
		public GridSelectCon()
		{
		}

		public void InitData(MapFixedSet material,int Type)
		{
            this.cfgData = material;
			this.Type = Type;
            Name = cfgData.EditSetName;

			foreach (var item in cfgData.MaterialIdList)
			{
				MapFixedMaterial mapFixedMaterial = ConfigCache.GetMapFixedMaterial(item);
				mapFixedMaterialDict[item] = mapFixedMaterial;
				int setId = mapFixedMaterial.ImageSetId;//图像图集id
				if(!imageSetDataDict.ContainsKey(setId))
				{
				    switch(Type)
				    {
				        case 1://作战地图
				            imageSetDataDict[setId] = LoadMapConfig.Instance.mapSet1.MapSetDataDict[setId];
				            break;
				        case 2://大地图
				            imageSetDataDict[setId] = LoadMapConfig.Instance.mapSet2.MapSetDataDict[setId];
							break;
				        default:
				            break;
				    }
				}
			}
		}


		public override void _Ready()
		{
			gridContainer = GetNode<GridContainer>("ScrollContainer/VBoxContainer/GridContainer");
			gridContainer.Columns = 20;//祝福注释-一行20个，暂时
			foreach(var item in mapFixedMaterialDict)
			{
			    MapFixedMaterial mapFixed = item.Value;
			    GridMaterial grid = (GridMaterial)GD.Load<PackedScene>("res://src/edit/common_view/grid_select/GridMaterial.tscn").Instantiate();
                grid.InitData(item.Value,Type);
                Vector2I ve = LoadMapConfig.GetImageIndex_TO_Vector2(Type, mapFixed.ImageSetId, mapFixed.ImageSetIndex);
                grid.Icon = imageSetDataDict[mapFixed.ImageSetId].textureList[ve];
                grid.Flat = true;
                grid.FocusEntered += ()=>
                {
                    select = mapFixed;
                };
                gridContainer.AddChild(grid);
			}
        }

	    //获得焦点时，
		public void OnFocusEntered()
		{
            //设置 材料格子的各项参数

		}

        //返回当前选择的材料
        public MapFixedMaterial GetSelectMaterial()
        {
            return select;
        }

	}
}
