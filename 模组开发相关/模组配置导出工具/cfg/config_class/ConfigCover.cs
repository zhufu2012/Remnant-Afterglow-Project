using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 ConfigCover 用于 配置覆盖关系表,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class ConfigCover
    {
        #region 参数及初始化
        /// <summary>        
        /// 覆盖关系id
        /// </summary>
        public string CoverId { get; set; }
        /// <summary>        
        /// 覆盖关系名称
        /// </summary>
        public string CoverName { get; set; }
        /// <summary>        
        /// 覆盖关系描述
        /// </summary>
        public string CoverDescribe { get; set; }
        /// <summary>        
        /// （覆盖类型，开局覆盖方式，之后的覆盖方式），不在这个表中的数据，默认是(0,3,0),即永远可以覆盖原数据，可以添加新数据
        ///覆盖类型：0 全局，值覆盖方式永远使用开局覆盖方式
        ///1及以上表示，对应表覆盖方式可以使用多少次
        ///举例：(4,2,0)   表示读取到的前4个同名文件 都可以覆盖原数据，不可添加新数据
        ///前面已经有4个同名文件覆盖过后，就不可覆盖原数据，不可添加新数据
        ///
        ///覆盖方式：
        ///0 不可覆盖原数据，不可添加新数据
        ///1，不可覆盖原数据，可添加新数据
        ///2，可以覆盖原数据，不可添加新数据
        ///3，可以覆盖原数据，可以添加新数据
        ///4，如果存在mod覆盖这个表，完全使用覆盖该数据的mod的数据
        /// </summary>
        public List<int> CoverType { get; set; }
        /// <summary>        
        /// 对应子表名称
        ///
        /// </summary>
        public string CoverTableName { get; set; }

        public ConfigCover(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_ConfigCover, id);//public const string Config_ConfigCover = "cfg_ConfigCover"; 
			CoverId = (string)dict["CoverId"];
			CoverName = (string)dict["CoverName"];
			CoverDescribe = (string)dict["CoverDescribe"];
			CoverType = (List<int>)dict["CoverType"];
			CoverTableName = (string)dict["CoverTableName"];
			InitData();
        }

        
        public ConfigCover(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_ConfigCover, cfg_id);//public const string Config_ConfigCover = "cfg_ConfigCover"; 
			CoverId = (string)dict["CoverId"];
			CoverName = (string)dict["CoverName"];
			CoverDescribe = (string)dict["CoverDescribe"];
			CoverType = (List<int>)dict["CoverType"];
			CoverTableName = (string)dict["CoverTableName"];
			InitData();
        }

        public ConfigCover(Dictionary<string, object> dict)
        {
			CoverId = (string)dict["CoverId"];
			CoverName = (string)dict["CoverName"];
			CoverDescribe = (string)dict["CoverDescribe"];
			CoverType = (List<int>)dict["CoverType"];
			CoverTableName = (string)dict["CoverTableName"];
			InitData();
        }
        #endregion
    }
}
