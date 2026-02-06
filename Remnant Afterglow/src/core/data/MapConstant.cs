using Godot;
using System.Collections.Generic;
namespace Remnant_Afterglow
{
    public static class MapConstant
    {
        /// <summary>
        /// 边缘配置-地图材料id
        /// </summary>
        public static readonly HashSet<int> EditSet = new HashSet<int>();
        /// <summary>
        /// 边缘配置-地图材料id
        /// </summary>
        public static readonly Dictionary<int, int> EditImageSet = new Dictionary<int, int>();
        static MapConstant()
        {
            List<MapEdge> list = ConfigCache.GetAllMapEdge();
            foreach (MapEdge e in list)
            {
                EditSet.Add(e.MaterialId);
                EditImageSet[e.ImageSetId] = e.MaterialId;
            }
        }

        /// <summary>
        /// 游戏地图网格大小, 值为 40
        /// </summary>
        public const int TileCellSize = 40;
        /// <summary>
        /// 游戏地图网格大小的一半, 值为 40
        /// </summary>
        public const int TileCellSize2 = 20;
        /// <summary>
        /// 大地图网格大小, 值为 110 * 90  图用128*128    衡纵比  10000 :  8660
        /// </summary>
        public const int BigCellSizeX = 375;
        public const int BigCellSizeY = 431;
        /// <summary>
        /// 游戏地图网格大小, 向量表示
        /// </summary>
        public static readonly Vector2I TileCellSizeVector2I = new Vector2I(TileCellSize, TileCellSize);

        /// <summary>
        /// 游戏地图网格大小一半, 向量表示
        /// </summary>
        public static readonly Vector2I TileCellSizeVector2I2 = new Vector2I(TileCellSize2, TileCellSize2);

        /// <summary>
        /// 游戏大地图网格大小, 向量表示
        /// </summary>
        public static readonly Vector2I TileBagCellSizeVector2I = new Vector2I(BigCellSizeX, BigCellSizeY);

        /// <summary>
        /// 游戏地图 的 寻路逻辑层
        /// </summary>
        public static readonly int MapLogicLayer = 1;
        /// <summary>
        /// 这是单位不可建造的格子数，不包含建筑的占地
        /// </summary>
        public const float CreateDistanceSq = 2;

        #region 地图边缘拼接

        /// <summary>
        /// 地形掩码纹理大小, 47格地形
        /// </summary>
        public static readonly Vector2I TerrainBit3x3 = new Vector2I(12, 4);

        /// <summary>
        /// 定义8个方向的坐标偏移量
        /// </summary>
        public static (int dx, int dy)[] Terraindirections = new[] {
            (-1, -1), // 0x01 (左上)  1
            (0, -1),  // 0x02 (上)    2
            (1, -1),  // 0x04 (右上)  3
            (-1, 0),   // 0x80 (左)  4
            (0,0),     //中          5
            (1, 0),   // 0x08 (右)    6
            (-1, 1),  // 0x40 (左下)  7
            (0, 1),   // 0x20 (下)    8
            (1, 1)   // 0x10 (右下)  9
        };
        #endregion

        #region 地图随机生成
        /// <summary>
        /// 是否显示导航层
        /// </summary>
        public static bool IsShow_Navigate = true;
        /// <summary>
        /// 是否显示碰撞层
        /// </summary>
        public static bool IsShow_Collide = true;

        public static Vector2I[] Vector2_Dir = new Vector2I[5] {
            new Vector2I(0, 1),
            new Vector2I(0, -1),
            new Vector2I(-1, 0),
            new Vector2I(1, 0),
            new Vector2I(0, 0)
        };
        #endregion


        #region 地图资源-祝福注释-这些必须修改,比如把显示的货币id列表，放在默认配置文件里
        /// <summary>
        /// 万能齿轮
        /// </summary>
        public const int MoneyId_1 = 1;
        /// <summary>
        /// 怨灵水晶
        /// </summary>
        public const int MoneyId_2 = 2;
        /// <summary>
        /// 次元岛溶剂
        /// </summary>
        public const int MoneyId_3 = 3;
        /// <summary>
        /// 废料
        /// </summary>
        public const int MoneyId_4 = 4;
        /// <summary>
        /// 核心单元
        /// </summary>
        public const int MoneyId_101 = 101;
        #endregion
    }
}


