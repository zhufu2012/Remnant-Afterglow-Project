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
        /// 背景音乐id，为字符串
        /// </summary>
        public string MusicId { get; set; }
        /// <summary>        
        /// 背景音乐名称
        /// </summary>
        public string MusicName { get; set; }
        /// <summary>        
        /// 背景音乐文件路径
        /// </summary>
        public string MusicPath { get; set; }

        public BackgroundMusic(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BackgroundMusic, id);//public const string Config_BackgroundMusic = "cfg_BackgroundMusic"; 
			MusicId = (string)dict["MusicId"];
			MusicName = (string)dict["MusicName"];
			MusicPath = (string)dict["MusicPath"];
			InitData();
        }

        
        public BackgroundMusic(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BackgroundMusic, cfg_id);//public const string Config_BackgroundMusic = "cfg_BackgroundMusic"; 
			MusicId = (string)dict["MusicId"];
			MusicName = (string)dict["MusicName"];
			MusicPath = (string)dict["MusicPath"];
			InitData();
        }

        public BackgroundMusic(Dictionary<string, object> dict)
        {
			MusicId = (string)dict["MusicId"];
			MusicName = (string)dict["MusicName"];
			MusicPath = (string)dict["MusicPath"];
			InitData();
        }
        #endregion
    }
}
