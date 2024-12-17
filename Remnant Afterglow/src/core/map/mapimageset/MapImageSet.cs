using GameLog;
using Godot;
using System;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    public class ImageSetData
    {
        /// <summary>
        /// 图像集id
        /// </summary>
        public int MapImageSetId;
        /// <summary>
        /// 地图图像集名称
        /// </summary>
        public string MapImageSetName;
        /// <summary>
        /// 地图图像集描述
        /// </summary>
        public string ImageSetDescribe;
        /// <summary>
        /// 地图类型
        /// </summary>
        public int ImageSetType;
        /// <summary>
        /// 地图可使用的最大序号
        /// </summary>
        public int ImageSetMaxId;
        /// <summary>
        /// 图像集绘制层数 在哪层绘制
        /// </summary>
        public int ImageSetLayer;
        /// <summary>
        /// 地图图像集大小
        /// </summary>
        public Vector2I MapImageSize;

        public Dictionary<Vector2I, Texture2D> textureList = new Dictionary<Vector2I, Texture2D>();
        public ImageSetData(Dictionary<string, Object> dict)
        {
            MapImageSetId = (int)dict["MapImageSetId"];
            MapImageSetName = (string)dict["MapImageSetName"];
            ImageSetDescribe = (string)dict["ImageSetDescribe"];
            ImageSetType = (int)dict["ImageSetType"];
            ImageSetMaxId = (int)dict["ImageSetMaxId"];
            ImageSetLayer = (int)dict["ImageSetLayer"];
            MapImageSize = (Vector2I)dict["MapImageSize"];
            Texture2D texture = (Texture2D)dict["MapImageSet"];
            Vector2I vector2I = ((Vector2I)((MapImageSize.X > 0 && MapImageSize.Y > 0) ? MapImageSize : new Vector2I(1, 1)));
            textureList = Common.SplitTexture(texture, vector2I);
        }
    }

    /// <summary>
    /// 地图图像集
    /// </summary>
    public class MapImageSet
    {
        /// <summary>
        /// 地图图像集 列表<图像集id.图像集>
        /// </summary>
		public Dictionary<int, TileSetAtlasSource> MapSetDict = new Dictionary<int, TileSetAtlasSource>();
        /// <summary>
        /// 地图图像集 数据列表
        /// </summary>
        public Dictionary<int, ImageSetData> MapSetDataDict = new Dictionary<int, ImageSetData>();


        /// <summary>
        /// 保存地图生成材料id 对应的备选id
        /// <地图材料id,其备选id>
        /// </summary>
        public Dictionary<int, int> MapMaterialDict = new Dictionary<int, int>();

        /// <summary>
        /// 加载图块数据
        /// </summary>
        public MapImageSet(TileSet tileSet, int Type, int Width, int Height)
        {
            List<Dictionary<string, object>> list = ConfigLoadSystem.QueryCfgAllLine(ConfigConstant.Config_MapImageSet,
            new Dictionary<string, object>
            {
                     { "ImageSetType",Type }
            });
            foreach (var kvp in list)
            {
                int MapImageSetId = (int)kvp["MapImageSetId"];
                TileSetAtlasSource source = new TileSetAtlasSource();

                source.Texture = (Texture2D)kvp["MapImageSet"];
                source.TextureRegionSize = new Vector2I(Width, Height);

                Vector2I size = (Vector2I)kvp["MapImageSize"];
                for (var i = 0; i < size.X; i++)
                {
                    for (var j = 0; j < size.Y; j++)
                    {
                        Vector2I pos = new Vector2I(i, j);
                        source.CreateTile(pos);//创建给定大小 size 的图块
                    }
                }

                tileSet.AddSource(source, MapImageSetId);//加入资源

                int index = 1;
                int cellsize = MapConstant.TileCellSize;//格子长宽
                for (var i = 0; i < size.X; i++)
                {
                    for (var j = 0; j < size.Y; j++)
                    {
                        if (Type == 1)
                        {
                            Vector2I pos = new Vector2I(i, j);
                            List<Dictionary<string, object>> MaterialList = ConfigLoadSystem.QueryCfgAllLine(ConfigConstant.Config_MapMaterial,
                            new Dictionary<string, object>
                            {
                                 { "ImageSetId" , MapImageSetId },
                                 { "ImageSetIndex" , index}
                            });
                            foreach (var info in MaterialList)
                            {
                                int MaterialId = (int)info["MaterialId"];
                                int newAlternativeTileId = source.CreateAlternativeTile(pos);//新增备选图块
                                MapMaterialDict[MaterialId] = newAlternativeTileId;
                                TileData tileData = source.GetTileData(pos, newAlternativeTileId);//对应单个图块数据
                                List<List<int>> CollisionPolygon = (List<List<int>>)info["CollisionPolygon"];//碰撞多边形数据
                                for (int key = 0; key < CollisionPolygon.Count; key++)//像tileData中加碰撞多边形
                                {
                                    int physicsLayer = CollisionPolygon[key][0];//物理层
                                    Vector2[] Vector2List = ListCommon.ConvertToVector2Array(CollisionPolygon[key], 1);
                                    tileData.AddCollisionPolygon(physicsLayer);
                                    tileData.SetCollisionPolygonPoints(physicsLayer, 0, Vector2List);
                                }
                            }
                        }
                        index++;
                    }
                }
                MapSetDataDict[(int)kvp["MapImageSetId"]] = new ImageSetData(kvp);
                MapSetDict[(int)kvp["MapImageSetId"]] = source;
            }
        }


        public int[] GetIntArray(int Num)
        {
            int[] ints = new int[Num];
            for (int i = 0; i < Num; i++)
            {
                ints[i] = i;
            }
            return ints;
        }


    }
}
