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
		public MapFixedSet cfgData;

		///材料数据字典<固定材料id,地图材料配置>
        Dictionary<int,MapFixedMaterial>  mapFixedMaterialDict = new Dictionary<int,MapFixedMaterial>();
		///图集数据<地图编辑器图集id，>
		Dictionary<int,ImageSetData>  imageSetDataDict = new Dictionary<int,ImageSetData>();

        GridContainer gridContainer;
		///地图类型
		public int Type;
        /// <summary>
		/// 当前选择的材料数据
		/// </summary>
        public MapFixedMaterial select;
        /// <summary>
		/// 当前选择的材料图
		/// </summary>
        public Texture2D img;

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
			switch(Type)
            				    {
            				        case 1://作战地图
            				            gridContainer.Columns = EditConstant.MapGridSelectPanel_ItemNum;
            				            break;
            				        case 2://大地图
            				            gridContainer.Columns = EditConstant.BigMapGridSelectPanel_ItemNum;
            							break;
            				        default:
            				            break;
            				    }
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
                    img = imageSetDataDict[mapFixed.ImageSetId].textureList[ve];
					EditMapView.Instance.gridSelectPanel.UpdataMaterial();//更新材料格子数据
					
					EditMapView.Instance.nowMapData.NowLayer = cfgData.ImageLayer;
					EditMapView.Instance.tileMap.SetCurrLayer( cfgData.ImageLayer);
                };
                gridContainer.AddChild(grid);
			}
        }


        /// <summary>
		/// 返回当前选择的材料
		/// </summary>
		/// <returns></returns>
        public MapFixedMaterial GetSelectMaterial()
        {
            return select;
        }


        /// <summary>
		/// 返回当前选择的材料图
		/// </summary>
		/// <returns></returns>
        public Texture2D GetSelectTexture2D()
        {
            return img;
        }
    }
}
