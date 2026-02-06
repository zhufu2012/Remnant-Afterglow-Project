using System.Collections.Generic;
using Godot;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 GlobalConfigPng 用于 Png散图,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class GlobalConfigPng
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
        /// 全局配置值
        ///图片
        /// </summary>
        public Texture2D ConfigValue { get; set; }

        public GlobalConfigPng(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_GlobalConfigPng, id);//public const string Config_GlobalConfigPng = "cfg_GlobalConfigPng"; 
			ConfigId = (string)dict["ConfigId"];
			ConfigName = (string)dict["ConfigName"];
			ConfigValue = (Texture2D)dict["ConfigValue"];
			InitData();
        }

        
        public GlobalConfigPng(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_GlobalConfigPng, cfg_id);//public const string Config_GlobalConfigPng = "cfg_GlobalConfigPng"; 
			ConfigId = (string)dict["ConfigId"];
			ConfigName = (string)dict["ConfigName"];
			ConfigValue = (Texture2D)dict["ConfigValue"];
			InitData();
        }

        public GlobalConfigPng(Dictionary<string, object> dict)
        {
			ConfigId = (string)dict["ConfigId"];
			ConfigName = (string)dict["ConfigName"];
			ConfigValue = (Texture2D)dict["ConfigValue"];
			InitData();
        }
        #endregion
    }
}
