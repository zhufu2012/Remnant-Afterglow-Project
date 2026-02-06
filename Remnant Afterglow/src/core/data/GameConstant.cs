using System.Collections.Generic;

namespace Remnant_Afterglow
{
    public static class GameConstant
    {
        /// <summary>
        /// 游戏当前版本
        /// </summary>
        public const int game_version = 1;
        /// <summary>
        /// 默认语言-祝福注释-暂未使用
        /// </summary>
        public const string define_language = "zh_cn";

        /// <summary>
        /// 窗口长度
        /// </summary>
        public const int WindowSizeX = 1150;
        /// <summary>
        /// 窗口宽度
        /// </summary>
        public const int WindowSizeY = 648;

        /// <summary>
        /// 游戏帧数
        /// </summary>
        public const int GameFrame = 60;


        /// <summary>
        /// 作战地图使用的货币id
        /// </summary>
        public static List<int> PriceIdList = [1, 2, 3];
    }
}