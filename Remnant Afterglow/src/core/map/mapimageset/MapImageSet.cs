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
                MapSetDataDict[(int)kvp["MapImageSetId"]] =  new ImageSetData(kvp, Width, Height);
                MapSetDict[(int)kvp["MapImageSetId"]] = source;
            }
            if (Type == 1)//作战地图
            {
                MapFixedSet mapFixed = ConfigCache.GetMapFixedSet(1);//逻辑图层
                LogicMaterialList = mapFixed.MaterialIdList;
            }
                /**
                if (Type == 1)//作战地图
                {
                    NavigationRegion2D region2D = MapCopy.Instance.fixedTileMap.region2D;


                    List<MapNavigate> NavigateLayerList = ConfigCache.GetAllMapNavigate();
                    MapFixedSet mapFixed = ConfigCache.GetMapFixedSet(1);//逻辑图层
                    LogicMaterialList = mapFixed.MaterialIdList;
                    foreach (int id in mapFixed.MaterialIdList)
                    {
                        MapFixedMaterial item = ConfigCache.GetMapFixedMaterial(id);
                        MapPassType mapPass = ConfigCache.GetMapPassType(item.PassTypeId);
                        Vector2I size= (Vector2I)ConfigLoadSystem.GetCfgValue(ConfigConstant.Config_MapImageSet,""+item.ImageSetId,"MapImageSize");
                        int y = (item.ImageSetIndex - 1) / size.X;
                        Vector2I pos = new Vector2I(item.ImageSetIndex - y * size.X - 1, y);
                        TileSetAtlasSource temp_source = MapSetDict[item.ImageSetId];

                        List<MapNavigate> mapNavigates = NavigateLayerList.FindAll((MapNavigate t) => { return !mapPass.NoPassList.Contains(t.NavigateLayerId); }) ;
                        TileData tileData = temp_source.GetTileData(pos, 0);
                        foreach (MapNavigate navigate in mapNavigates)
                        {
                            if(navigate.NavigateLayerId==0)
                            {
                                //int newAlternativeTileId = temp_source.CreateAlternativeTile(pos);//新增备选图块
                                //MapMaterialDict[new Vector2(1,item.MaterialId)] = newAlternativeTileId;
                                tileData.AddCollisionPolygon(navigate.NavigateLayerId);
                                NavigationPolygon navigation = new NavigationPolygon();
                                var vertices = new Vector2[] {
                                    new Vector2(20, 20),
                                    new Vector2(-20, 20),
                                    new Vector2(-20, -20),
                                    new Vector2(20, -20) 
                                };
                                navigation.Vertices = vertices;
                                var polygons = new int[] {0,1,2,3};
                                navigation.AddPolygon(polygons);
                                var boundingOutline = new Vector2[] {
                                     new Vector2(-20, -20),
                                     new Vector2(20, -20),
                                     new Vector2(20, 20),
                                     new Vector2(-20, 20)
                                };
                                navigation.AddOutline(vertices);
                                navigation.AgentRadius = 0f;

                               
                                //navigation.MakePolygonsFromOutlines();

                                //NavigationServer2D.BakeFromSourceGeometryData(navigation, new NavigationMeshSourceGeometryData2D());

                                tileData.SetNavigationPolygon(navigate.NavigateLayerId, navigation);
                            }
                        }
                    }
                }**/
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
