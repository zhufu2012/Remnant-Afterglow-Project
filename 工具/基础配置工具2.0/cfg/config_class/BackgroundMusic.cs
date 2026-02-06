using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 BackgroundMusic 用于 背景音乐,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class BackgroundMusic
    {
        #region 参数及初始化
        /// <summary>
        /// 背景音乐id
        /// </summary>
        public string MusicId { get; set; }
        /// <summary>
        /// 背景音乐名称
        /// </summary>
        public string MusicName { get; set; }
        /// <summary>
        /// 音乐类型
        ///0 进入主菜单的背景音乐(进主菜单播放的音乐)
        ///1 其他主菜单背景音乐
        ///2 数据库背景音乐
        ///3 大地图背景音乐
        ///4 地图背景音乐
        ///
        /// </summary>
        public int MusicType { get; set; }
        /// <summary>
        /// 背景音乐参数
        ///音乐类型为3：这是大地图id
        ///音乐类型为4：这是副本地图id
        /// </summary>
        public int Param { get; set; }
        /// <summary>
        /// 播放概率万分比
        /// </summary>
        public int Probability { get; set; }
        /// <summary>
        /// 背景音乐默认音量倍数 1就是默认音量
        ///（相对于游戏当时音量的倍数 最大为音量100）
        /// </summary>
        public float VolumeMultiple { get; set; }
        /// <summary>
        /// 背景音乐文件路径
        /// </summary>
        public string MusicPath { get; set; }

        public BackgroundMusic(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BackgroundMusic, id);//public const string Config_BackgroundMusic = "cfg_BackgroundMusic"; 
			MusicId = (string)dict["MusicId"];
			MusicName = (string)dict["MusicName"];
			MusicType = (int)dict["MusicType"];
			Param = (int)dict["Param"];
			Probability = (int)dict["Probability"];
			VolumeMultiple = (float)dict["VolumeMultiple"];
			MusicPath = (string)dict["MusicPath"];
			InitData();
        }

        
        public BackgroundMusic(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BackgroundMusic, cfg_id);//public const string Config_BackgroundMusic = "cfg_BackgroundMusic"; 
			MusicId = (string)dict["MusicId"];
			MusicName = (string)dict["MusicName"];
			MusicType = (int)dict["MusicType"];
			Param = (int)dict["Param"];
			Probability = (int)dict["Probability"];
			VolumeMultiple = (float)dict["VolumeMultiple"];
			MusicPath = (string)dict["MusicPath"];
			InitData();
        }

        public BackgroundMusic(Dictionary<string, object> dict)
        {
			MusicId = (string)dict["MusicId"];
			MusicName = (string)dict["MusicName"];
			MusicType = (int)dict["MusicType"];
			Param = (int)dict["Param"];
			Probability = (int)dict["Probability"];
			VolumeMultiple = (float)dict["VolumeMultiple"];
			MusicPath = (string)dict["MusicPath"];
			InitData();
        }
        #endregion
    }
}
