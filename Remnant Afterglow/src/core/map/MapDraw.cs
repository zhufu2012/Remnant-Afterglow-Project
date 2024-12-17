using GameLog;
using Godot;
using System;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    public partial class MapDraw : TileMap
    {
        /// <summary>
        /// 副本关卡数据
        /// </summary>
        private ChapterCopyBase copyData;
        /// <summary>
        /// 图块资源
        /// </summary>
        public LoadTileSetConfig loadTileSetConfig;
        /// <summary>
        /// 地图生成器
        /// </summary>
        public MapGenerate mapGenerate;
        /// <summary>
        /// 地图各层数据
        /// </summary>
        public Dictionary<int, Cell[,]> layer_dict = new Dictionary<int, Cell[,]>();
        /// <summary>
        /// 导航区域
        /// </summary>
        public Dictionary<Vector2I, NavigationRegion2D> NavigationDict = new Dictionary<Vector2I, NavigationRegion2D>();
        /////////////////////地图内数据//////////////////////


        /// <summary>
        /// 地图总时间
        /// </summary>
        public double nowTime = 0;
        public int ChapterId;//副本id
        public int CopyId;//关卡id
        public FastNoiseLite noise;//随机种子
        /// <summary>
        /// 地图大小
        /// </summary>
        public Vector2 Size;//
        public MapDraw(int ChapterId, int CopyId, Vector2 Size, FastNoiseLite noise)
        {
            copyData = new ChapterCopyBase(ChapterId, CopyId);
            this.ChapterId = ChapterId;
            this.CopyId = CopyId;
            this.noise = noise;
            this.Size = Size;
            if (MapConstant.IsShow_Navigate)
                NavigationVisibilityMode = VisibilityMode.ForceShow;
            if (MapConstant.IsShow_Collide)
                CollisionVisibilityMode = VisibilityMode.ForceShow;
        }

        #region 初始化数据
        public override void _Ready()
        {
            InitMapCfg();
            InitMap();//初始化绘制地图
        }

        /// <summary>
        /// 地图绘制资源配置初始化
        /// </summary>
        public void InitMapCfg()
        {
            loadTileSetConfig = new LoadTileSetConfig(1);
            TileSet = loadTileSetConfig.GetTileSet();
            mapGenerate = new MapGenerate(copyData.CopyId);
        }
        /// <summary>
        /// 初始化绘制地图
        /// </summary>
        public void InitMap()
        {
            layer_dict = mapGenerate.GenerateMap(noise, Size);
            foreach (var Layer in layer_dict)
            {
                int layer = Layer.Key;//当前层
                Cell[,] map = Layer.Value;//本层的结构
                if (layer >= GetLayersCount())
                {
                    for (int i = GetLayersCount(); i <= layer; i++)
                    {
                        AddLayer(i);
                    }
                }
                int cellsize = MapConstant.TileCellSize;//格子长宽
                for (int i = 0; i < map.GetLength(0); i++)
                {
                    int i_cellsize = i * cellsize;
                    int i_cellsize2 = i_cellsize + cellsize;
                    for (int j = 0; j < map.GetLength(1); j++)
                    {

                        SetCell(layer, new Vector2I(i, j), map[i, j].MapImageId, map[i, j].ImagePos);

                        /**if (layer == 1)//祝福注释，这个数字，需要和生成地图类的mapLayer 用固定变量表示
                        {
                            Log.Print("新速度:", 1);
                            int cell_index = map[i, j].index;

                            int j_cellsize = j * cellsize;
                            int j_cellsize2 = j_cellsize + cellsize;

                            var navigation = new NavigationRegion2D();
                            navigation.Name = "navigation";
                            MainCopy.Instance.NavigationRoot.AddChild(navigation);
                            var Polygon = new NavigationPolygon();
                            Polygon.AddOutline(new[]
                            {
                                new Vector2(i_cellsize, j_cellsize),
                                new Vector2(i_cellsize, j_cellsize2),
                                new Vector2(i_cellsize2, j_cellsize2),
                                new Vector2(i_cellsize2, j_cellsize)
                            });

                            Polygon.Vertices = LoadTileSetConfig.mapImageSet.NavigationDict[cell_index];
                            Polygon.AddPolygon(LoadTileSetConfig.mapImageSet.NavigationIndexDict[cell_index]);
                            Polygon.SetParsedCollisionMaskValue(1, true);
                            Polygon.SourceGeometryMode = NavigationPolygon.SourceGeometryModeEnum.GroupsWithChildren;
                            Polygon.SourceGeometryGroupName = "navigation";
                            Polygon.CellSize = 1;
                            NavigationServer2D.BakeFromSourceGeometryData(Polygon, new NavigationMeshSourceGeometryData2D());
                            //Polygon.MakePolygonsFromOutlines();
                            navigation.NavigationPolygon = Polygon;
                            navigation.BakeNavigationPolygon(false);//-祝福注释-看是否需要放置单独线程来烘焙 导航网格
                        }
                        **/
                    }
                }
            }
        }
        #endregion


        public override void _Process(double delta)
        {
            QueueRedraw();
        }

        /// <summary>
        /// 逻辑帧
        /// </summary>
        /// <param name="delta"></param>
        public override void _PhysicsProcess(double delta)
        {
            base._PhysicsProcess(delta);
        }

        public override void _UnhandledInput(InputEvent @event)
        {
            if (@event.IsActionPressed("mapview_drawmap"))
            {
                InitMap();//重新绘制
            }
            base._UnhandledInput(@event);
        }

        /// <summary>
        /// 获取鼠标位置在地图中的位置
        /// </summary>
        /// <param name="pos"></param>
        /// <returns></returns>
        public Vector2I GetLocalMousePos(Vector2I pos)
        {
            return LocalToMap(ToLocal(pos));
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
