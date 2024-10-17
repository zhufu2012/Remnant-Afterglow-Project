using System.Collections.Generic;
using Godot;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 AttributeBase 用于 属性表,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class AttributeBase
    {
        #region 参数及初始化
        /// <summary>        
        /// 属性id
        /// </summary>
        public int AttributeId { get; set; }
        /// <summary>        
        /// 显示名称
        /// </summary>
        public string ShowName { get; set; }
        /// <summary>        
        /// 属性描述
        /// </summary>
        public string AttributeDescribe { get; set; }
        /// <summary>        
        /// 属性显示类型
        ///0 属性不显示
        ///1 属性条
        /// </summary>
        public int ShowType { get; set; }
        /// <summary>        
        /// 属性显示颜色
        /// </summary>
        public Color ShowColor { get; set; }
        /// <summary>        
        /// 依赖关系id列表
        ///（属性id,cfg_AttrDependency_属性依赖表id）
        ///当该属性变化时，对应属性也变化
        ///新属性根据属性依赖表计算
        /// </summary>
        public List<int> DependencyIdList { get; set; }

        public AttributeBase(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_AttributeBase, id);//public const string Config_AttributeBase = "cfg_AttributeBase"; 
			AttributeId = (int)dict["AttributeId"];
			ShowName = (string)dict["ShowName"];
			AttributeDescribe = (string)dict["AttributeDescribe"];
			ShowType = (int)dict["ShowType"];
			ShowColor = (Color)dict["ShowColor"];
			DependencyIdList = (List<int>)dict["DependencyIdList"];
			InitData();
        }

        
        public AttributeBase(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_AttributeBase, cfg_id);//public const string Config_AttributeBase = "cfg_AttributeBase"; 
			AttributeId = (int)dict["AttributeId"];
			ShowName = (string)dict["ShowName"];
			AttributeDescribe = (string)dict["AttributeDescribe"];
			ShowType = (int)dict["ShowType"];
			ShowColor = (Color)dict["ShowColor"];
			DependencyIdList = (List<int>)dict["DependencyIdList"];
			InitData();
        }

        public AttributeBase(Dictionary<string, object> dict)
        {
			AttributeId = (int)dict["AttributeId"];
			ShowName = (string)dict["ShowName"];
			AttributeDescribe = (string)dict["AttributeDescribe"];
			ShowType = (int)dict["ShowType"];
			ShowColor = (Color)dict["ShowColor"];
			DependencyIdList = (List<int>)dict["DependencyIdList"];
			InitData();
        }
        #endregion
    }
}
