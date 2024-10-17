using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 GlobalConfigList 用于 List数据,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class GlobalConfigList
    {
        #region 参数及初始化
        /// <summary>        
        /// 全局配置id
        /// </summary>
        public string Configid { get; set; }
        /// <summary>        
        /// 全局配置名称
        /// </summary>
        public string ConfigName { get; set; }
        /// <summary>        
        /// 全局配置值
        /// </summary>
        public List<int> ConfigValue { get; set; }

        public GlobalConfigList(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_GlobalConfigList, id);//public const string Config_GlobalConfigList = "cfg_GlobalConfigList"; 
			Configid = (string)dict["Configid"];
			ConfigName = (string)dict["ConfigName"];
			ConfigValue = (List<int>)dict["ConfigValue"];
			InitData();
        }

        
        public GlobalConfigList(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_GlobalConfigList, cfg_id);//public const string Config_GlobalConfigList = "cfg_GlobalConfigList"; 
			Configid = (string)dict["Configid"];
			ConfigName = (string)dict["ConfigName"];
			ConfigValue = (List<int>)dict["ConfigValue"];
			InitData();
        }

        public GlobalConfigList(Dictionary<string, object> dict)
        {
			Configid = (string)dict["Configid"];
			ConfigName = (string)dict["ConfigName"];
			ConfigValue = (List<int>)dict["ConfigValue"];
			InitData();
        }
        #endregion
    }
}
