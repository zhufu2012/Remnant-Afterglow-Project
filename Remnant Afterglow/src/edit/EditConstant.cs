using Godot;

namespace Remnant_Afterglow_EditMap
{
    /// <summary>
    /// 编辑器基础参数
    /// </summary>
    public static class EditConstant
    {
        #region 作战地图
        public const int MapType = 1;
        /// <summary>
        /// 作战地图保存默认文件夹-  PathConstant.GetPathUser(EditConstant.Map_Path)
        /// </summary>
        public static string Map_Path = "./map/map/";
        /// <summary>
        /// 作战地图文件后缀-  PathConstant.GetPathUser(EditConstant.Map_FileSuffix)
        /// </summary>
        public static string Map_FileSuffix = ".map";
        /// <summary>
        /// 编辑器 作战地图 默认大小
        /// </summary>
        public static Vector2I Define_MapSize = new Vector2I(200, 200);
        /// <summary>
        /// 作战地图 材料选择器，一排的材料数
        /// </summary>
        public static int MapGridSelectPanel_ItemNum = 9;

        /// <summary>
        /// 地图编辑器 层选择控件  当前层颜色
        /// </summary>
        public static Color MapLayerSelectPanel_NowLayerColor = new Color(0.5f, 0.5f, 0.5f);
        #endregion

        #region 作战地图模板
        public const int TempMapType = 2;
        /// <summary>
        /// 作战地图保存默认文件夹-  PathConstant.GetPathUser(EditConstant.Map_Path)
        /// </summary>
        public static string TempMap_Path = "./map/temp_map/";
        /// <summary>
        /// 作战地图文件后缀-  PathConstant.GetPathUser(EditConstant.Map_FileSuffix)
        /// </summary>
        public static string TempMap_FileSuffix = ".temp";
        /// <summary>
        /// 编辑器 作战地图 默认大小
        /// </summary>
        public static Vector2I Define_TempMapSize = new Vector2I(20, 20);
        #endregion


        #region 大地图
        public const int BigMapType = 3;
        /// <summary>
        /// 大地图保存默认文件夹-  PathConstant.GetPathUser(EditConstant.BigMap_Path)
        /// </summary>
        public static string BigMap_Path = "./map/bigmap/";
        /// <summary>
        /// 大地图地图文件后缀-  PathConstant.GetPathUser(EditConstant.Map_Path)
        /// </summary>
        public static string BigMap_FileSuffix = ".bigmap";
        /// <summary>
        /// 编辑器 大地图 默认大小
        /// </summary>
        public static Vector2I Define_BigMapSize = new Vector2I(100, 100);
        /// <summary>
        /// 大地图 材料选择器，一排的材料数
        /// </summary>
        public static int BigMapGridSelectPanel_ItemNum = 9;
        #endregion






        #region  按键
        /// <summary>
        /// ctrl+滚轮向上
        /// </summary>
        public static string Input_Key_CtrlBrush1 = "Edit_Brush1";
        /// <summary>
        /// ctrl+滚轮向下
        /// </summary>
        public static string Input_Key_CtrlBrush2 = "Edit_Brush2";
        #endregion



    }
}