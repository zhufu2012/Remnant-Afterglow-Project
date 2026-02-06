using System.Collections.Generic;
using Godot;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 WreckAge 用于 残骸配置,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class WreckAge
    {
        #region 参数及初始化
        /// <summary>
        /// 残骸id
        /// </summary>
        public int WreckAgeId { get; set; }
        /// <summary>
        /// 超时时长（单位 秒）
        /// </summary>
        public int OutTime { get; set; }
        /// <summary>
        /// 残骸图
        /// </summary>
        public Texture2D WreckAgePng { get; set; }

        public WreckAge(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_WreckAge, id);//public const string Config_WreckAge = "cfg_WreckAge"; 
			WreckAgeId = (int)dict["WreckAgeId"];
			OutTime = (int)dict["OutTime"];
			WreckAgePng = (Texture2D)dict["WreckAgePng"];
			InitData();
        }

        
        public WreckAge(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_WreckAge, cfg_id);//public const string Config_WreckAge = "cfg_WreckAge"; 
			WreckAgeId = (int)dict["WreckAgeId"];
			OutTime = (int)dict["OutTime"];
			WreckAgePng = (Texture2D)dict["WreckAgePng"];
			InitData();
        }

        public WreckAge(Dictionary<string, object> dict)
        {
			WreckAgeId = (int)dict["WreckAgeId"];
			OutTime = (int)dict["OutTime"];
			WreckAgePng = (Texture2D)dict["WreckAgePng"];
			InitData();
        }
        #endregion
    }
}
