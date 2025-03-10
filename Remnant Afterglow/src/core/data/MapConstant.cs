using Godot;
namespace Remnant_Afterglow
{
    public static class MapConstant
    {

        /// <summary>
        /// 游戏地图网格大小, 值为 40
        /// </summary>
        public const int TileCellSize = 40;

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


        #region 地图资源
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


