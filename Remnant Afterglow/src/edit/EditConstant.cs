using Godot;

namespace Remnant_Afterglow_EditMap
{
    /// <summary>
    /// 编辑器基础参数
    /// </summary>
    public static class EditConstant
    {
        /// <summary>
        /// 地图保存默认文件夹-  PathConstant.GetPathUser(EditConstant.Map_Path)
        /// </summary>
        public static string Map_Path = "./map/";


        /// <summary>
        /// 编辑器 地图 默认大小
        /// </summary>
        public static Vector2I Define_MapSize = new Vector2I(200, 200);

        /// <summary>
        /// 编辑器 大地图 默认大小
        /// </summary>
        public static Vector2I Define_BigMapSize = new Vector2I(100, 100);



    }
}