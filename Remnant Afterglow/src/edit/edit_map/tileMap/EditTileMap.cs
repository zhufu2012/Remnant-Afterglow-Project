using GameLog;
using Godot;
using Remnant_Afterglow;
using System.Collections.Generic;

namespace Remnant_Afterglow_EditMap
{
	/// <summary>
	/// EditorTileMap-初始化操作
	/// </summary>
	public partial class EditTileMap : TileMap
	{
		/// <summary>
		/// 地图各层数据
		/// </summary>
		public Dictionary<int, Cell[,]> layerData = new Dictionary<int, Cell[,]>();
		/// <summary>
		/// <实体id, 实体数据>
		/// </summary>
		public Dictionary<int, EntityData> entityDict = new Dictionary<int, EntityData>();

		/// <summary>
		/// 当前序号
		/// </summary>
		public int NowIndex = 0;
		/// <summary>
		/// <序号, 实体位置>
		/// </summary>
		public Dictionary<int, Vector2I> IndexPosDict = new Dictionary<int, Vector2I>();



		/// <summary>
		/// 图块资源
		/// </summary>
		public LoadTileSetConfig loadTileSetConfig;
		/// <summary>
		/// 地图数据
		/// </summary>
		public MapDrawData drawData;

		(int dx, int dy)[] directions;

		//实体管理器
		public EntityManager entityManager;
		/// <summary>
		/// 初始化各数据
		/// </summary>
		/// <param name="drawData"></param>
		public void InitData(MapDrawData drawData)
		{
			this.drawData = drawData;
			layerData = drawData.layerData;
			entityDict = drawData.entityDict;
			loadTileSetConfig = new LoadTileSetConfig(1);
			TileSet = loadTileSetConfig.GetTileSet();
			foreach (var Layer in layerData)//添加到所有层列表和所有显示层列表
			{
				allLayerList.Add(Layer.Key);
				showLayerList.Add(Layer.Key);
			}
			directions = MapConstant.Terraindirections;
			InitDrawEntity();//绘制实体
		}

		public override void _Ready()
		{
			InitView();
			InitDrawMap();//绘制地图
			InitLayer();//初始化图层显示
		}
		/// <summary>
		/// 初始化节点
		/// </summary>
		public void InitView()
		{
			buildShow = GetNode<Sprite2D>("建造预览");
			line2D = GetNode<Line2D>("建造预览/边框线");
			entityManager = new EntityManager(); // 初始化实体管理器
		}

		/// <summary>
		/// 初始化绘制地图
		/// </summary>
		public void InitDrawMap()
		{
			foreach (var Layer in EditMapView.Instance.nowMapData.NowShowLayer)//添加各层
			{
				AddLayer(Layer);
			}
		}

		/// <summary>
		/// 初始化绘制实体
		/// </summary>
		public void InitDrawEntity()
		{
			foreach (var info in entityDict)
			{
				int objectId = info.Key;
				EntityData entityData = info.Value;
				BuildData buildData = ConfigCache.GetBuildData(objectId);
				foreach (List<int> l in entityData.PosL)
				{
					Vector2I mapPos = new Vector2I(l[1], l[2]);
					Vector2 pos = GetMapPos(buildData.BuildingSize % 2 == 0, mapPos);
					AddBuild(buildData, pos, mapPos);
				}
			}
		}
		/// <summary>
		/// 初始化层数据
		/// </summary>
		public void InitLayer()
		{
			if (_initLayer)
			{
				return;
			}
			_initLayer = true;
		}
		#region 图层操作
		/// <summary>
		/// 是否初始化完成图层
		/// </summary>
		private bool _initLayer = false;
		/// <summary>
		/// 当前选择绘制的图层
		/// </summary>
		public int CurrLayer = 0;
		/// <summary>
		/// 当前选择显示的图层
		/// </summary>
		public List<int> showLayerList = new List<int>();
		/// <summary>
		/// 拥有的所有图层
		/// </summary>
		public List<int> allLayerList = new List<int>();
		/// <summary>
		/// 设置选择绘制的layer
		/// </summary>
		/// <param name="layer"></param>
		public void SetCurrLayer(int layer)
		{
			CurrLayer = layer;
			EditMapView.Instance.layerSelectPanel.ClearLayerItemColor();
			LayerItem item = EditMapView.Instance.layerSelectPanel.GetNowLayerItem();
			item.Modulate = EditConstant.MapLayerSelectPanel_NowLayerColor;
		}

		/// <summary>
		/// 刷新层数据
		/// </summary>
		private void FlushLayerData()
		{
			allLayerList.Clear();
			foreach (var Layer in layerData)//添加到所有层列表和所有显示层列表
			{
				allLayerList.Add(Layer.Key);
			}
		}

		/// <summary>
		/// 刷新层启用情况
		/// </summary>
		public void FlushLayerEnabled()
		{
			FlushLayerData();
			showLayerList = EditMapView.Instance.layerSelectPanel.GetSelectLayerList();
			foreach (int layer in allLayerList)
			{
				ClearLayer(layer);//清理然后重新绘制
				if (showLayerList.Contains(layer))
				{
					Cell[,] map = layerData[layer];//本层的结构
					int width = map.GetLength(0);
					int height = map.GetLength(1);
					for (int i = 0; i < map.GetLength(0); i++)
					{
						for (int j = 0; j < map.GetLength(1); j++)
						{
							Cell cell = map[i, j];
							if (MapConstant.EditSet.Contains(cell.index))//是否需要边缘处理
							{
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
										{
											flags |= 1u << index;  // 使用 1u 代替 (byte)(1 << index)
										}
									}
									else
									{
										flags |= 1u << index;  // 使用 1u 代替 (byte)(1 << index)
									}
								}
								if (flags == 0)
								{
									SetCell(layer, new Vector2I(i, j), cell.MapImageId, map[i, j].ImagePos);
								}
								else
								{
									//Log.Print(flags);
									int bit = TileSetTerrainInfo.TerrainBitToIndex(flags);
									//Log.Print(bit);
									SetCell(layer, new Vector2I(i, j), cell.MapImageId, TileSetTerrainInfo.TerrainIndexToCoords(bit));
								}
							}
							else
							{
								SetCell(layer, new Vector2I(i, j), cell.MapImageId, map[i, j].ImagePos);
							}

						}
					}
				}
			}
		}
		/// <summary>
		/// 修改层显示情况
		/// </summary>
		public void FlushLayer(int showlayer, bool isKey)
		{
			FlushLayerData();
			showLayerList = EditMapView.Instance.layerSelectPanel.GetSelectLayerList();
			if (isKey)//要绘制
			{
				if (layerData.ContainsKey(showlayer))//有该层
				{
					Cell[,] map = layerData[showlayer];//本层的结构
					int width = map.GetLength(0);
					int height = map.GetLength(1);
					for (int i = 0; i < map.GetLength(0); i++)
					{
						for (int j = 0; j < map.GetLength(1); j++)
						{
							Cell cell = map[i, j];
							if (MapConstant.EditSet.Contains(cell.index))//是否需要边缘处理
							{
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
										if (cell.index == map[checkX, checkY].index)
											flags |= 1u << index;
									}
									else
										flags |= 1u << index;
								}
								if (flags == 0)
									SetCell(showlayer, new Vector2I(i, j), cell.MapImageId, map[i, j].ImagePos);
								else
								{
									int bit = TileSetTerrainInfo.TerrainBitToIndex(flags);
									SetCell(showlayer, new Vector2I(i, j), cell.MapImageId, TileSetTerrainInfo.TerrainIndexToCoords(bit));
								}
							}
							else
							{
								SetCell(showlayer, new Vector2I(i, j), cell.MapImageId, map[i, j].ImagePos);
							}
						}
					}
				}
			}
			else//要隐藏
			{
				ClearLayer(showlayer);//清理
			}
		}
		#endregion




		/// <summary>
		/// 位置是否正确
		/// </summary>
		/// <returns></returns>
		public bool IsPos(Vector2 pos)
		{
			return pos.X < drawData.Width && pos.X >= 0 && pos.Y < drawData.Height && pos.Y >= 0;
		}

		/// <summary>
		/// 设置画笔模式
		/// </summary>
		/// <param name="mouseButtonType"></param>
		public static void SetType(MouseButtonType mouseButtonType)
		{
			EditMapView.Instance.tileMap.MouseType = mouseButtonType;
		}
	}
}
