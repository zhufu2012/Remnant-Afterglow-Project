using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 AttrDependency 用于 属性依赖表,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class AttrDependency
    {
        #region 参数及初始化
        /// <summary>
        /// 属性依赖id
        /// </summary>
        public int DependencyId { get; set; }
        /// <summary>
        /// 依赖关系计算核心代码
        ///一个c#表达式
        /// </summary>
        public string Code { get; set; }
        /// <summary>
        /// 依赖计算返回值
        ///这是一个表达式
        /// </summary>
        public string Relation { get; set; }

        public AttrDependency(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_AttrDependency, id);//public const string Config_AttrDependency = "cfg_AttrDependency"; 
			DependencyId = (int)dict["DependencyId"];
			Code = (string)dict["Code"];
			Relation = (string)dict["Relation"];
			InitData();
        }

        
        public AttrDependency(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_AttrDependency, cfg_id);//public const string Config_AttrDependency = "cfg_AttrDependency"; 
			DependencyId = (int)dict["DependencyId"];
			Code = (string)dict["Code"];
			Relation = (string)dict["Relation"];
			InitData();
        }

        public AttrDependency(Dictionary<string, object> dict)
        {
			DependencyId = (int)dict["DependencyId"];
			Code = (string)dict["Code"];
			Relation = (string)dict["Relation"];
			InitData();
        }
        #endregion
    }
}
