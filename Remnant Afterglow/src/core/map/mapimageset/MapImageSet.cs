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
        /// 地图图像集大小
        /// </summary>
        public Vector2I MapImageSize;

        public Dictionary<Vector2I, Texture2D> textureList = new Dictionary<Vector2I, Texture2D>();
        //Width 和Height 是切分图片的指定大小
        public ImageSetData(Dictionary<string, Object> dict, int Width, int Height)
        {
            MapImageSetId = (int)dict["MapImageSetId"];
            MapImageSetName = (string)dict["MapImageSetName"];
            ImageSetDescribe = (string)dict["ImageSetDescribe"];
            ImageSetType = (int)dict["ImageSetType"];
            ImageSetMaxId = (int)dict["ImageSetMaxId"];
            MapImageSize = (Vector2I)dict["MapImageSize"];
            Texture2D texture = (Texture2D)dict["MapImageSet"];
            textureList = Common.SplitTexture2(texture, new Vector2I(Width, Height));
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
        /// 地图图像集 数据字典
        /// </summary>
        public Dictionary<int, ImageSetData> MapSetDataDict = new Dictionary<int, ImageSetData>();


        /// <summary>
        /// 保存地图生成材料id 对应的备选id
        /// <地图材料id,其备选id>
        /// </summary>
        public static Dictionary<Vector2, int> MapMaterialDict = new Dictionary<Vector2, int>();
        /// <summary>
        /// 逻辑层有哪些材料id
        /// </summary>
        public static List<int> LogicMaterialList = new List<int>();
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
                Vector2I size = (Vector2I)kvp["MapImageSize"];
                TileSetAtlasSource source = new TileSetAtlasSource();
                Texture2D texture2D = (Texture2D)kvp["MapImageSet"];

                if (texture2D.GetWidth() >= Width * size.X && texture2D.GetHeight() >= Height * size.Y)
                {
                    source.Texture = texture2D;
                    source.TextureRegionSize = new Vector2I(Width, Height);
                    for (var i = 0; i < size.X; i++)
                    {
                        for (var j = 0; j < size.Y; j++)
                        {
                            source.CreateTile(new Vector2I(i, j));//创建给定大小 size 的图块
                        }
                    }

                    tileSet.AddSource(source, MapImageSetId);//加入资源
                    /**
                    if (MapConstant.EditImageSet.ContainsKey(MapImageSetId))
                    {
                        tileSet.AddTerrain(0, terrainId);
                        int index = 1;
                        for (var i = 0; i < size.Y; i++)
                        {
                            for (var j = 0; j < size.X; j++)
                            {
                                if (index != 4)
                                {
                                    TileData tileData = source.GetTileData(new Vector2I(j, i), 0);
                                    tileData.TerrainSet = 0;
                                    tileData.Terrain = terrainId;
                                    TileSetTerrainInfo.InttTerrain(tileData, terrainId, index);
                                }
                                index++;
                            }
                        }
                        terrainId++;
                    }
                    **/


                    MapSetDataDict[(int)kvp["MapImageSetId"]] = new ImageSetData(kvp, Width, Height);
                    MapSetDict[(int)kvp["MapImageSetId"]] = source;
                }
                else
                {
                    Log.Error("cfg_MapImageSet_地图图像集的 图像集id:" + MapImageSetId + ",图块创建错误！图集大小错误！");
                }
            }
            if (Type == 1)//作战地图
            {
                MapFixedSet mapFixed = ConfigCache.GetMapFixedSet(1);//逻辑图层
                LogicMaterialList = mapFixed.MaterialIdList;
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
