using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 GenerateFixedMap 用于 固定地图配置,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class GenerateFixedMap
    {
        #region 参数及初始化
        /// <summary>        
        /// 固定地图id
        /// </summary>
        public int MapId { get; set; }
        /// <summary>        
        /// 地图名称
        /// </summary>
        public string MapName { get; set; }
        /// <summary>        
        /// 地图描述
        /// </summary>
        public string MapDescribe { get; set; }
        /// <summary>        
        /// 地图文件名称，可以带文件夹
        ///默认路径在这里 Remnant Afterglow\map\
        ///举例：1.json
        ///2.json
        ///key/3.json
        ///无法仅填写#BASEVALUE
        /// </summary>
        public string MapPath { get; set; }

        public GenerateFixedMap(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_GenerateFixedMap, id);//public const string Config_GenerateFixedMap = "cfg_GenerateFixedMap"; 
			MapId = (int)dict["MapId"];
			MapName = (string)dict["MapName"];
			MapDescribe = (string)dict["MapDescribe"];
			MapPath = (string)dict["MapPath"];
			InitData();
        }

        
        public GenerateFixedMap(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_GenerateFixedMap, cfg_id);//public const string Config_GenerateFixedMap = "cfg_GenerateFixedMap"; 
			MapId = (int)dict["MapId"];
			MapName = (string)dict["MapName"];
			MapDescribe = (string)dict["MapDescribe"];
			MapPath = (string)dict["MapPath"];
			InitData();
        }

        public GenerateFixedMap(Dictionary<string, object> dict)
        {
			MapId = (int)dict["MapId"];
			MapName = (string)dict["MapName"];
			MapDescribe = (string)dict["MapDescribe"];
			MapPath = (string)dict["MapPath"];
			InitData();
        }
        #endregion
    }
}
