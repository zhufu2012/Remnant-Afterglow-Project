using Godot;
using Remnant_Afterglow_EditMap;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
	public partial class FixedTileMap : TileMap
	{
		/// <summary>
		/// 图块资源
		/// </summary>
		public LoadTileSetConfig loadTileSetConfig;
		/// <summary>
		/// 地图各层数据
		/// </summary>
		public Dictionary<int, Cell[,]> layerData = new Dictionary<int, Cell[,]>();
		/// <summary>
		/// <实体id, 实体数据>
		/// </summary>
		public Dictionary<int, EntityData> entityDict = new Dictionary<int, EntityData>();
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
		public string mapName;
		/// <summary>
		/// 固定地图的数据
		/// </summary>
		public MapDrawData mapDrawData;
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
			loadTileSetConfig = new LoadTileSetConfig(1);
			TileSet = loadTileSetConfig.GetTileSet();

		}


		public void InitData(string mapName)
		{
			mapDrawData = MapDrawData.GetMapDrawData(EditConstant.Map_Path, mapName);
			Width = mapDrawData.Width;
			Height = mapDrawData.Height;
			layerData = mapDrawData.layerData;
			entityDict = mapDrawData.entityDict;
			if (!layerData.ContainsKey(MapConstant.MapLogicLayer))//对逻辑层数据进行处理
			{
				layerData[MapConstant.MapLogicLayer] = new Cell[Width, Height];
			}
			if (MapConstant.IsShow_Navigate)
				NavigationVisibilityMode = VisibilityMode.ForceShow;
			if (MapConstant.IsShow_Collide)
				CollisionVisibilityMode = VisibilityMode.ForceShow;
		}

		/// <summary>
		/// 初始化绘制
		/// </summary>
		public void InitDraw()
		{
			InitDrawMap();//初始化绘制地图
			InitDrawEntity();//初始化绘制实体
		}

		/// <summary>
		/// 初始化绘制地图
		/// </summary>
		public void InitDrawMap()
		{
			(int dx, int dy)[] directions = MapConstant.Terraindirections;
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

				int width = map.GetLength(0);
				int height = map.GetLength(1);
				for (int i = 0; i < width; i++)
				{
					for (int j = 0; j < height; j++)
					{
						if (MapConstant.EditSet.Contains(map[i, j].index))//是否需要边缘处理
						{
							Cell cell = map[i, j];
							uint flags = 0;
							// 遍历所有方向
							for (int index = 0; index < directions.Length; index++)
							{
								int checkX = i + directions[index].dx;
								int checkY = j + directions[index].dy;
								// 检查边界
								if (checkX >= 0 && checkX < width && checkY >= 0 && checkY < height)
								{
									// 检查是否是同类母图块
									if (cell.TerrainEquals(map[checkX, checkY]))
										flags |= 1u << index;
								}
								else
									flags |= 1u << index;  // 使用 1u 代替 (byte)(1 << index)
							}
							if (flags == 0)
							{
								SetCell(layer, new Vector2I(i, j), cell.MapImageId, map[i, j].ImagePos);
							}
							else
							{
								int bit = TileSetTerrainInfo.TerrainBitToIndex(flags);
								SetCell(layer, new Vector2I(i, j), cell.MapImageId, TileSetTerrainInfo.TerrainIndexToCoords(bit));
							}
						}
						else
						{
							SetCell(layer, new Vector2I(i, j), map[i, j].MapImageId, map[i, j].ImagePos);
						}
					}
				}
			}
		}
		/// <summary>
		/// 初始化绘制实体
		/// </summary>
		public void InitDrawEntity()
		{
			foreach (var info in entityDict)
			{
				int objectId = info.Key;//实体id
				EntityData entityData = info.Value;
				BuildData buildData = ConfigCache.GetBuildData(objectId);
				if (buildData.Type == 0)
				{
					foreach (List<int> item in entityData.PosL)
					{
						ObjectManager.Instance.CreateMapBuild(objectId, item[0], new Vector2I(item[1], item[2]));
					}
				}
				else
				{
					foreach (List<int> item in entityData.PosL)
					{
						ObjectManager.Instance.CreateMapTower(objectId, item[0], new Vector2I(item[1], item[2]));
					}
				}
			}
		}

		public override void _PhysicsProcess(double delta)
		{
			UpdateView(delta);//更新界面
		}

		/// <summary>
		/// 获取鼠标位置在地图中的位置
		/// </summary>
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
