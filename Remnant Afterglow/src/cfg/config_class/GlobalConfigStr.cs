using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 GlobalConfigStr 用于 Str数据,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class GlobalConfigStr
    {
        #region 参数及初始化
        /// <summary>
        /// 全局配置id
        /// </summary>
        public string ConfigId { get; set; }
        /// <summary>
        /// 全局配置名称
        /// </summary>
        public string ConfigName { get; set; }
        /// <summary>
        /// 
        ///设置-特殊参数中是否显示
        /// </summary>
        public bool ShopSetting { get; set; }
        /// <summary>
        /// 设置-特殊参数中是否可以修改
        /// </summary>
        public bool IsModif { get; set; }
        /// <summary>
        /// 全局配置值
        /// </summary>
        public string ConfigValue { get; set; }

        public GlobalConfigStr(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_GlobalConfigStr, id);//public const string Config_GlobalConfigStr = "cfg_GlobalConfigStr"; 
			ConfigId = (string)dict["ConfigId"];
			ConfigName = (string)dict["ConfigName"];
			ShopSetting = (bool)dict["ShopSetting"];
			IsModif = (bool)dict["IsModif"];
			ConfigValue = (string)dict["ConfigValue"];
			InitData();
        }

        
        public GlobalConfigStr(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_GlobalConfigStr, cfg_id);//public const string Config_GlobalConfigStr = "cfg_GlobalConfigStr"; 
			ConfigId = (string)dict["ConfigId"];
			ConfigName = (string)dict["ConfigName"];
			ShopSetting = (bool)dict["ShopSetting"];
			IsModif = (bool)dict["IsModif"];
			ConfigValue = (string)dict["ConfigValue"];
			InitData();
        }

        public GlobalConfigStr(Dictionary<string, object> dict)
        {
			ConfigId = (string)dict["ConfigId"];
			ConfigName = (string)dict["ConfigName"];
			ShopSetting = (bool)dict["ShopSetting"];
			IsModif = (bool)dict["IsModif"];
			ConfigValue = (string)dict["ConfigValue"];
			InitData();
        }
        #endregion
    }
}
