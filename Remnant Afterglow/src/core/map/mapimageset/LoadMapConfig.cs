using Godot;

namespace Remnant_Afterglow
{
    public partial class LoadMapConfig
    {
        /// <summary>
        /// 作战地图 TileSet
        /// </summary>
        public TileSet tileSet1;
        /// <summary>
        /// 作战地图 图集
        /// </summary>
        public  MapImageSet mapSet1;

        /// <summary>
        /// 大地图 TileSet
        /// </summary>
        public  TileSet tileSet2;
        /// <summary>
        /// 大地图 图集
        /// </summary>
        public  MapImageSet mapSet2;
        /// <summary>
        /// 单例模式，用于全局访问LoadMapConfig实例
        /// </summary>
        public static LoadMapConfig Instance { get; set; }
        public LoadMapConfig()
        {
            Instance = this;
            CreateTileSetData(tileSet1, 1, MapConstant.TileCellSize, MapConstant.TileCellSize);
            CreateTileSetData(tileSet2, 2, MapConstant.TileCellSize, MapConstant.TileCellSize);
        }

        public static void InitData()
        {
            new LoadMapConfig();
        }
        /// <summary>
        /// 清理数据
        /// </summary>
        public static void ClearData()
        {
            Instance = null;
        }

        /// <summary>
        /// 获取由该对象生成的Godot.TileSet对象
        /// </summary>
        public  void CreateTileSetData(TileSet tileSet,int Type, int Width, int Height)
        {
            tileSet = new TileSet();//每次创建都需要覆盖
            tileSet.TileSize = new Vector2I(Width, Height);
            if (Type == 1)//副本地图
            {
                mapSet1 = new MapImageSet(tileSet, Type, MapConstant.TileCellSize, MapConstant.TileCellSize);//给格子加备选格子，以及加上碰撞层
            }
            if (Type == 2)//六边形大地图
            {
                tileSet.TileShape = TileSet.TileShapeEnum.Hexagon;
                mapSet2 = new MapImageSet(tileSet, Type, MapConstant.BigCellSizeX, MapConstant.BigCellSizeY);//给格子加备选格子，以及加上碰撞层
            }

        }


        /// <summary>
        /// 将对应图像集的index,转换为二维坐标
        /// </summary>
        /// <param name="data_id"></param>
        /// <param name="index"></param>
        /// <param name=""></param>
        /// <returns></returns>
        public static Vector2I GetImageIndex_TO_Vector2(int Type,int data_id, int index)
        {
            switch(Type)
            {
                case 1:
                    if (Instance.mapSet1.MapSetDataDict.ContainsKey(data_id))
                    {
                        int max_index = Instance.mapSet1.MapSetDataDict[data_id].ImageSetMaxId;
                        if (max_index < index)//超过最大可使用序列
                        {
                            return new Vector2I(-1, -1);
                        }
                        else
                        {
                            Vector2I size = Instance.mapSet1.MapSetDataDict[data_id].MapImageSize;
                            int y = (index - 1) / size.X;
                            return new Vector2I(index - y * size.X , y + 1);
                        }
                    }
                    else//转换失败
                    {
                        return new Vector2I(-2, -2);
                    }
                case 2:
                    if (Instance.mapSet1.MapSetDataDict.ContainsKey(data_id))
                    {
                        int max_index = Instance.mapSet1.MapSetDataDict[data_id].ImageSetMaxId;
                        if (max_index < index)//超过最大可使用序列
                        {
                            return new Vector2I(-1, -1);
                        }
                        else
                        {
                            Vector2I size = Instance.mapSet1.MapSetDataDict[data_id].MapImageSize;
                            int y = (index - 1) / size.X;
                            return new Vector2I(index - y * size.X, y + 1);
                        }
                    }
                    else//转换失败
                    {
                        return new Vector2I(-2, -2);
                    }
                default:
                    return new Vector2I(-3, -3);
            }

           
        }
    }
}
