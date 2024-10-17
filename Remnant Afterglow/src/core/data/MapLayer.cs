namespace Remnant_Afterglow
{
    /// <summary>
    /// 地图图层
    /// </summary>
    public static class MapLayer
    {




        #region 地板部分
        /// <summary>
        /// 地下层-背景
        /// </summary>
        public const int AutoFloorLayer = 0;
        /// <summary>
        /// 地板层1
        /// </summary>
        public const int FloorLayer1 = AutoFloorLayer + 1;
        /// <summary>
        /// 地板层2-常用于绘制地上装饰
        /// </summary>
        public const int FloorLayer2 = FloorLayer1 + 1;
        /// <summary>
        /// 地板层3-绘制其他装饰，绘制出生点圈
        /// </summary>
        public const int FloorLayer3 = FloorLayer2 + 1;
        #endregion

        #region 地板与实体之间的缝隙层
        //FloorLayer3+1
        //FloorLayer3+2
        //FloorLayer3+3
        #endregion

        #region 实体部分
        /// <summary>
        /// 实体层1
        /// </summary>
        public const int ObjectLayer1 = FloorLayer3 + 4;
        /// <summary>
        /// 实体层2  -单位主体位置
        /// </summary>
        public const int ObjectLayer2 = ObjectLayer1 + 1;
        /// <summary>
        /// 实体层3  -武器底座位置
        /// </summary>
        public const int ObjectLayer3 = ObjectLayer2 + 1;
        /// <summary>
        /// 实体层4  - 武器
        /// </summary>
        public const int ObjectLayer4 = ObjectLayer3 + 1;
        /// <summary>
        /// 实体层5  -
        /// </summary>
        public const int ObjectLayer5 = ObjectLayer4 + 1;
        /// <summary>
        /// 实体层6  -
        /// </summary>
        public const int ObjectLayer6 = ObjectLayer5 + 1;
        #endregion

        #region 高于实体的缝隙
        //ObjectLayer4+1
        //ObjectLayer4+2
        //ObjectLayer4+3
        #endregion

        #region 更上层
        /// <summary>
        ///  顶层
        /// </summary>
        public const int TopLayer = ObjectLayer4 + 4;
        #endregion
    }
}
