using GameLog;
using Godot;
using Remnant_Afterglow_EditMap;
using System.Collections.Generic;
using System.Linq;

namespace Remnant_Afterglow
{
	public partial class FixedTileMap : TileMap
	{
		/// <summary>
		/// 图块资源
		/// </summary>
		public LoadTileSetConfig loadTileSetConfig;
		public Dictionary<int, NavigationRegion2D> regionDict = new Dictionary<int, NavigationRegion2D>();
		public Dictionary<int, NavigationPolygon> polygonDict = new Dictionary<int, NavigationPolygon>();
		/// <summary>
		/// 地图各层数据
		/// </summary>
		public Dictionary<int, Cell[,]> layerData = new Dictionary<int, Cell[,]>();

		/// <summary>
		/// 地图宽度
		/// </summary>
		public int Width { get; set; }
		/// <summary>
		/// 地图高度
		/// </summary>
		public int Height { get; set; }
		/// <summary>
		/// 固定地图配置
		/// </summary>
		public GenerateFixedMap cfgData;
		/// <summary>
		/// 固定地图的数据
		/// </summary>
		public MapDrawData mapDrawData;
		public List<MapNavigate> navigateList = new List<MapNavigate>();
		public List<MapPassType> mapPassTypeList = new List<MapPassType>();
		public override void _Ready()
		{
			InitMapCfg();
		}

		/// <summary>
		/// 地图绘制资源配置初始化
		/// </summary>
		public void InitMapCfg()
		{
			buildShow = GetNode<Sprite2D>("建造预览");
			line2D = GetNode<Line2D>("建造预览/边框线");
			shape2D= GetNode<CollisionShape2D>("建造预览/占地区域/形状");
			area2D = GetNode<Area2D>("建造预览/占地区域");
			loadTileSetConfig = new LoadTileSetConfig(1);
			TileSet = loadTileSetConfig.GetTileSet();

		}


		public void InitData(int cfgId)
		{
			cfgData = ConfigCache.GetGenerateFixedMap(cfgId);
			mapDrawData = MapDrawData.GetMapDrawData(EditConstant.Map_Path, cfgData.MapName);
			Width = mapDrawData.Width;
			Height = mapDrawData.Height;
			layerData = mapDrawData.layerData;
			if (!layerData.ContainsKey(MapConstant.MapLogicLayer))//不存在该层就自行加上
			{
				layerData[MapConstant.MapLogicLayer] = new Cell[Width, Height];
			}
			if (MapConstant.IsShow_Navigate)
				NavigationVisibilityMode = VisibilityMode.ForceShow;
			if (MapConstant.IsShow_Collide)
				CollisionVisibilityMode = VisibilityMode.ForceShow;

			CreatMap();//创建地图
			//CreatNavigation();//创建导航地图
		}

		/// <summary>
		/// 创建地图
		/// </summary>
		public void CreatMap()
		{
			foreach (var Layer in layerData)
			{
				int layer = Layer.Key;//当前层
				if (layer >= GetLayersCount())//当前层大于等于层数
				{
					for (int i = GetLayersCount(); i <= layer; i++)
					{
						AddLayer(i);
					}
				}
				Cell[,] map = Layer.Value;//本层的结构
				for (int i = 0; i < map.GetLength(0); i++)
				{
					for (int j = 0; j < map.GetLength(1); j++)
					{

						SetCell(layer, new Vector2I(i, j), map[i, j].MapImageId, map[i, j].ImagePos);
					}
				}
			}
		}

		
		/// <summary>
		/// 创建导航地图
		/// </summary>
		public void CreatNavigation()
		{
			int cellsize = MapConstant.TileCellSize;
			Cell[,] logicMap = layerData[MapConstant.MapLogicLayer];//导航层
			for (int i = 0; i < logicMap.GetLength(0); i++)
			{
				for (int j = 0; j < logicMap.GetLength(1); j++)
				{
					if (logicMap[i, j].index != 0)
					{
						if (MapImageSet.LogicMaterialList.Contains(logicMap[i, j].index))
						{
							MapFixedMaterial item = ConfigCache.GetMapFixedMaterial(logicMap[i, j].index);
							polygonDict[item.PassTypeId].AddOutline(new[]
							{
								new Vector2(i,j)*cellsize,
								new Vector2(i+1,j)*cellsize,
								new Vector2(i+1, j+1)*cellsize,
								new Vector2(i, j+1)*cellsize
							});
						}
					}
				}
			}
			foreach (var mapPassType in mapPassTypeList)
			{
				if (mapPassType.PassTypeId == 0)
					continue;
				regionDict[mapPassType.PassTypeId].BakeNavigationPolygon(false);
			}
		}

		/***
		/// <summary>
		/// 创建导航地图
		/// </summary>
		public void CreatNavigation()
		{
			int cellsize = MapConstant.TileCellSize;
			Cell[,] logicMap = layerData[MapConstant.MapLogicLayer];//导航层
			for (int i = 0; i < logicMap.GetLength(0); i++)
			{
				for (int j = 0; j < logicMap.GetLength(1); j++)
				{
					if (logicMap[i, j].index != 0)
					{
						if (MapImageSet.LogicMaterialList.Contains(logicMap[i, j].index))
						{
							MapFixedMaterial item = ConfigCache.GetMapFixedMaterial(logicMap[i, j].index);
							MapPassType mapPass = ConfigCache.GetMapPassType(item.PassTypeId);
							//可通行的层
							List<MapNavigate> passList = navigateList.FindAll((MapNavigate t) => { return !mapPass.NoPassList.Contains(t.NavigateLayerId); });
							foreach (MapNavigate navigate in passList)
							{
								if(navigate.NavigateLayerId ==1)
								polygonDict[navigate.NavigateLayerId].AddOutline(new[]
									{
									new Vector2(i,j)*cellsize,
									new Vector2(i+1,j)*cellsize,
									new Vector2(i+1, j+1)*cellsize,
									new Vector2(i, j+1)*cellsize
								});
							}
						}
					}
				}
			}
			foreach (MapNavigate navigate in navigateList)
			{
				//polygon.MakePolygonsFromOutlines();
				Log.Print(NavigationServer2D.GetMaps());
				regionDict[navigate.NavigateLayerId].BakeNavigationPolygon(false);
				Log.Print(navigate.NavigateLayerId);
			}
		}***/

		public override void _PhysicsProcess(double delta)
		{
			UpdateView(delta);//更新界面
		}





		/// <summary>
		/// 获取鼠标位置在地图中的位置
		/// </summary>
		/// <param name="pos"></param>
		/// <returns></returns>
		public Vector2I GetLocalMousePos()
		{
			return LocalToMap(GetGlobalMousePosition());
		}

		/// <summary>
		/// 获取地图中TileData
		/// </summary>
		/// <param name="layer">对应层</param>
		/// <param name="pos">对应位置</param>
		/// <returns></returns>
		public TileData GetLocalMousePos(int layer, Vector2I pos)
		{
			return GetCellTileData(layer, pos);
		}

	}
}
