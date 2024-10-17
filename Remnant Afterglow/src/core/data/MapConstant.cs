using Godot;
namespace Remnant_Afterglow
{
    public static class MapConstant
    {

        /// <summary>
        /// 游戏地图网格大小, 值为 20
        /// </summary>
        public const int TileCellSize = 20;

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






        #region 地图随机生成

        public static Vector2I[] Vector2_Dir = new Vector2I[5] {
            new Vector2I(0, 1),
            new Vector2I(0, -1),
            new Vector2I(-1, 0),
            new Vector2I(1, 0),
            new Vector2I(0, 0)
        };

        #endregion
    }
}


