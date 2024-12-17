using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 SoundEffect 用于 音效配置,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class SoundEffect
    {
        #region 参数及初始化
        /// <summary>        
        /// 音效文件Id,字符串
        /// </summary>
        public string SoundId { get; set; }
        /// <summary>        
        /// 音效文件名称
        /// </summary>
        public string SoundName { get; set; }
        /// <summary>        
        /// 音效文件路径
        /// </summary>
        public string SoundPath { get; set; }

        public SoundEffect(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_SoundEffect, id);//public const string Config_SoundEffect = "cfg_SoundEffect"; 
			SoundId = (string)dict["SoundId"];
			SoundName = (string)dict["SoundName"];
			SoundPath = (string)dict["SoundPath"];
			InitData();
        }

        
        public SoundEffect(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_SoundEffect, cfg_id);//public const string Config_SoundEffect = "cfg_SoundEffect"; 
			SoundId = (string)dict["SoundId"];
			SoundName = (string)dict["SoundName"];
			SoundPath = (string)dict["SoundPath"];
			InitData();
        }

        public SoundEffect(Dictionary<string, object> dict)
        {
			SoundId = (string)dict["SoundId"];
			SoundName = (string)dict["SoundName"];
			SoundPath = (string)dict["SoundPath"];
			InitData();
        }
        #endregion
    }
}
