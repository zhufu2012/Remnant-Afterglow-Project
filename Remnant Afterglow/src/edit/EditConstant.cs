using Godot;

namespace Remnant_Afterglow_EditMap
{
    /// <summary>
    /// 编辑器基础参数
    /// </summary>
    public static class EditConstant
    {
        /// <summary>
        /// 作战地图保存默认文件夹-  PathConstant.GetPathUser(EditConstant.Map_Path)
        /// </summary>
        public static string Map_Path = "./map/map/";
        /// <summary>
        /// 作战地图文件后缀-  PathConstant.GetPathUser(EditConstant.Map_Path)
        /// </summary>
        public static string Map_FileSuffix = ".json";
        /// <summary>
        /// 编辑器 作战地图 默认大小
        /// </summary>
        public static Vector2I Define_MapSize = new Vector2I(200, 200);




        /// <summary>
        /// 大地图保存默认文件夹-  PathConstant.GetPathUser(EditConstant.BigMap_Path)
        /// </summary>
        public static string BigMap_Path = "./map/bigmap/";
        /// <summary>
        /// 大地图地图文件后缀-  PathConstant.GetPathUser(EditConstant.Map_Path)
        /// </summary>
        public static string BigMap_FileSuffix = ".json";
        /// <summary>
        /// 编辑器 大地图 默认大小
        /// </summary>
        public static Vector2I Define_BigMapSize = new Vector2I(100, 100);



    }
}