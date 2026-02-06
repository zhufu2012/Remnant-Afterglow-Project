using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 GlobalAttributeBase 用于 全局属性表,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class GlobalAttributeBase
    {
        #region 参数及初始化
        /// <summary>
        /// 全局属性id
        /// </summary>
        public int GlobalAttributeId { get; set; }
        /// <summary>
        /// 显示名称
        /// </summary>
        public string ShowName { get; set; }
        /// <summary>
        /// 属性描述
        /// </summary>
        public string Describe { get; set; }

        public GlobalAttributeBase(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_GlobalAttributeBase, id);//public const string Config_GlobalAttributeBase = "cfg_GlobalAttributeBase"; 
			GlobalAttributeId = (int)dict["GlobalAttributeId"];
			ShowName = (string)dict["ShowName"];
			Describe = (string)dict["Describe"];
			InitData();
        }

        
        public GlobalAttributeBase(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_GlobalAttributeBase, cfg_id);//public const string Config_GlobalAttributeBase = "cfg_GlobalAttributeBase"; 
			GlobalAttributeId = (int)dict["GlobalAttributeId"];
			ShowName = (string)dict["ShowName"];
			Describe = (string)dict["Describe"];
			InitData();
        }

        public GlobalAttributeBase(Dictionary<string, object> dict)
        {
			GlobalAttributeId = (int)dict["GlobalAttributeId"];
			ShowName = (string)dict["ShowName"];
			Describe = (string)dict["Describe"];
			InitData();
        }
        #endregion
    }
}
