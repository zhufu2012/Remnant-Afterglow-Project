using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 SequenceMapBase 用于 序列图配置,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class SequenceMapBase
    {
        #region 参数及初始化
        /// <summary>        
        /// 序列图id
        /// </summary>
        public int SequenceId { get; set; }
        /// <summary>        
        /// 序列图
        ///这里填json名称就行
        /// </summary>
        public SequenceMapType Sequence { get; set; }
        /// <summary>        
        /// 是否自动播放
        /// </summary>
        public bool IsAutoplay { get; set; }
        /// <summary>        
        /// 是否循环播放
        /// </summary>
        public bool IsLoop { get; set; }

        public SequenceMapBase(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_SequenceMapBase, id);//public const string Config_SequenceMapBase = "cfg_SequenceMapBase"; 
			SequenceId = (int)dict["SequenceId"];
			Sequence = (SequenceMapType)dict["Sequence"];
			IsAutoplay = (bool)dict["IsAutoplay"];
			IsLoop = (bool)dict["IsLoop"];
			InitData();
        }

        
        public SequenceMapBase(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_SequenceMapBase, cfg_id);//public const string Config_SequenceMapBase = "cfg_SequenceMapBase"; 
			SequenceId = (int)dict["SequenceId"];
			Sequence = (SequenceMapType)dict["Sequence"];
			IsAutoplay = (bool)dict["IsAutoplay"];
			IsLoop = (bool)dict["IsLoop"];
			InitData();
        }

        public SequenceMapBase(Dictionary<string, object> dict)
        {
			SequenceId = (int)dict["SequenceId"];
			Sequence = (SequenceMapType)dict["Sequence"];
			IsAutoplay = (bool)dict["IsAutoplay"];
			IsLoop = (bool)dict["IsLoop"];
			InitData();
        }
        #endregion
    }
}
