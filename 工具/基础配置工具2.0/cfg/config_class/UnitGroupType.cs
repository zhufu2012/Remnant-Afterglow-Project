using System.Collections.Generic;
using Godot;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 UnitGroupType 用于 单位组类型,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class UnitGroupType
    {
        #region 参数及初始化
        /// <summary>        
        /// 单位组类型
        /// </summary>
        public int GroupTypeId { get; set; }
        /// <summary>        
        /// 单位组显示名称
        /// </summary>
        public string ShowName { get; set; }
        /// <summary>        
        /// 单位组名称
        /// </summary>
        public string Name { get; set; }
        /// <summary>        
        /// 单位出现提示图片
        /// </summary>
        public Texture2D PromptPng { get; set; }

        public UnitGroupType(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_UnitGroupType, id);//public const string Config_UnitGroupType = "cfg_UnitGroupType"; 
			GroupTypeId = (int)dict["GroupTypeId"];
			ShowName = (string)dict["ShowName"];
			Name = (string)dict["Name"];
			PromptPng = (Texture2D)dict["PromptPng"];
			InitData();
        }

        
        public UnitGroupType(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_UnitGroupType, cfg_id);//public const string Config_UnitGroupType = "cfg_UnitGroupType"; 
			GroupTypeId = (int)dict["GroupTypeId"];
			ShowName = (string)dict["ShowName"];
			Name = (string)dict["Name"];
			PromptPng = (Texture2D)dict["PromptPng"];
			InitData();
        }

        public UnitGroupType(Dictionary<string, object> dict)
        {
			GroupTypeId = (int)dict["GroupTypeId"];
			ShowName = (string)dict["ShowName"];
			Name = (string)dict["Name"];
			PromptPng = (Texture2D)dict["PromptPng"];
			InitData();
        }
        #endregion
    }
}
