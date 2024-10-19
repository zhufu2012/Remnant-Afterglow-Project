using System.Collections.Generic;
using Godot;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 MapBuildLable 用于 建造列表标签,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class MapBuildLable
    {
        #region 参数及初始化
        /// <summary>        
        /// 建造列表标签id
        /// </summary>
        public int BuildLableId { get; set; }
        /// <summary>        
        /// 标签名称
        /// </summary>
        public string LableName { get; set; }
        /// <summary>        
        /// 标签图标
        /// </summary>
        public Texture2D LablePng { get; set; }

        public MapBuildLable(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_MapBuildLable, id);//public const string Config_MapBuildLable = "cfg_MapBuildLable"; 
			BuildLableId = (int)dict["BuildLableId"];
			LableName = (string)dict["LableName"];
			LablePng = (Texture2D)dict["LablePng"];
			InitData();
        }

        
        public MapBuildLable(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_MapBuildLable, cfg_id);//public const string Config_MapBuildLable = "cfg_MapBuildLable"; 
			BuildLableId = (int)dict["BuildLableId"];
			LableName = (string)dict["LableName"];
			LablePng = (Texture2D)dict["LablePng"];
			InitData();
        }

        public MapBuildLable(Dictionary<string, object> dict)
        {
			BuildLableId = (int)dict["BuildLableId"];
			LableName = (string)dict["LableName"];
			LablePng = (Texture2D)dict["LablePng"];
			InitData();
        }
        #endregion
    }
}
