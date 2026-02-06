using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 SoundSfx 用于 UI音效配置,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class SoundSfx
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
        /// <summary>
        /// 0 用户界面音效
        ///1 游戏玩法音效
        ///2 环境音效
        ///3 特殊音效
        /// </summary>
        public int BusType { get; set; }
        /// <summary>
        /// 音量（分贝）
        /// </summary>
        public float VolumeDb { get; set; }
        /// <summary>
        /// 音高最小值
        ///（用于随机变化）
        /// </summary>
        public float PitchMin { get; set; }
        /// <summary>
        /// 音高最大值（用于随机变化）
        /// </summary>
        public float PitchMax { get; set; }
        /// <summary>
        /// 最大同时播放实例数
        /// </summary>
        public int MaxInstances { get; set; }

        public SoundSfx(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_SoundSfx, id);//public const string Config_SoundSfx = "cfg_SoundSfx"; 
			SoundId = (string)dict["SoundId"];
			SoundName = (string)dict["SoundName"];
			SoundPath = (string)dict["SoundPath"];
			BusType = (int)dict["BusType"];
			VolumeDb = (float)dict["VolumeDb"];
			PitchMin = (float)dict["PitchMin"];
			PitchMax = (float)dict["PitchMax"];
			MaxInstances = (int)dict["MaxInstances"];
			InitData();
        }

        
        public SoundSfx(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_SoundSfx, cfg_id);//public const string Config_SoundSfx = "cfg_SoundSfx"; 
			SoundId = (string)dict["SoundId"];
			SoundName = (string)dict["SoundName"];
			SoundPath = (string)dict["SoundPath"];
			BusType = (int)dict["BusType"];
			VolumeDb = (float)dict["VolumeDb"];
			PitchMin = (float)dict["PitchMin"];
			PitchMax = (float)dict["PitchMax"];
			MaxInstances = (int)dict["MaxInstances"];
			InitData();
        }

        public SoundSfx(Dictionary<string, object> dict)
        {
			SoundId = (string)dict["SoundId"];
			SoundName = (string)dict["SoundName"];
			SoundPath = (string)dict["SoundPath"];
			BusType = (int)dict["BusType"];
			VolumeDb = (float)dict["VolumeDb"];
			PitchMin = (float)dict["PitchMin"];
			PitchMax = (float)dict["PitchMax"];
			MaxInstances = (int)dict["MaxInstances"];
			InitData();
        }
        #endregion
    }
}
