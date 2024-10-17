
using Godot;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 祝福注释-暂时这样使用，之后可以改成，初始化时加载，读取就直接读枚举就行
    /// </summary>
    public static class PathConstant
    {

        /// <summary>
        /// 路径使用状态，0 为 开发使用，1为测试使用
        /// </summary>
        public static int PathType = 0;


        /// <summary>
        /// 游戏配置路径  PathConstant.GetPathUser(PathConstant.GAME_PARAM_PATH_USER)
        /// </summary>
        public static string GAME_PARAM_PATH_USER = "./data/config.json";

        /// <summary>
        /// 配置加载文件-目前使用的路径   PathConstant.GetPathUser(PathConstant.CONFIG_PATH_USER)
        /// </summary>
        public static string CONFIG_PATH_USER = "./data/config/file_name.json";

        /// <summary>
        /// 游戏配置路径  PathConstant.GetPathUser(PathConstant.SequenceMap_PATH_USER)
        /// </summary>
        public static string SequenceMap_PATH_USER = "./data/sequence_map/";



        /// <summary>
        /// 存档保存基础路径-目前使用的路径 PathConstant.GetPathUser(PathConstant.SAVE_LOAD_PATH_USER)
        /// </summary>
        public static string SAVE_LOAD_PATH_USER = "./save/";
        /// <summary>
        /// 存档文件后缀 PathConstant.GetPathUser(PathConstant.SAVE_LOAD_FILE_SUFFIX)
        /// </summary>
        public static string SAVE_LOAD_FILE_SUFFIX = ".data";

        /// <summary>
        /// 存档文件界面数据文件 保存名称 PathConstant.GetPathUser(PathConstant.SAVE_LOAD_VIEW_UI)
        /// </summary>
        public static string SAVE_LOAD_VIEW_UI = "archive_ui.json";



        /// <summary>
        /// mod加载路径-目前使用的路径  PathConstant.GetPathUser(PathConstant.MOD_LOAD_PATH_USER)
        /// </summary>
        public static string MOD_LOAD_PATH_USER = "./mods/";
        /// <summary>
        /// mod列表路径-目前使用的路径 PathConstant.GetPathUser(PathConstant.MOD_LIST_PATH_USER)
        /// </summary>
        public static string MOD_LIST_PATH_USER = "./mods/mod_list.json";

        /// <summary>
        /// 地图生成用噪声工具的保存路径 PathConstant.GetPathUser(PathConstant.NOISE_SETTING_PATH_USER)
        /// </summary>
        public static string NOISE_SETTING_PATH_USER = "./data/tool_noise_setting.cfg";

        /// <summary>
        /// 获取对应路径
        /// </summary>
        /// <param name="path"></param>
        /// <returns></returns>
        public static string GetPathUser(string path)
        {
            string user_path = "";
            switch (PathType)
            {
                case 0://编辑器开发环境
                    return path;
                case 1://测试环境
                    user_path = path.Replace("./", "\\");
                    user_path = user_path.Replace("/", "\\");
                    return user_path;
                default:
                    return path;
            }
        }


    }

}
