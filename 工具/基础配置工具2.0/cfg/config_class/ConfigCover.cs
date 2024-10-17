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
        /// 可处理覆盖次数：
        ///表中没有的数据默认为-1
        ///
        ///-1 表示永远处理
        ///0 不处理 
        ///1及以上表示，指对应表可以处理多少次覆盖
        ///
        /// </summary>
        public int HandleNum { get; set; }
        /// <summary>
        /// 覆盖方式：
        ///表中没有的数据默认为3
        ///0 不可覆盖原数据，不可添加新数据
        ///1，不可覆盖原数据，可添加新数据
        ///2，可以覆盖原数据，不可添加新数据
        ///3，可以覆盖原数据，可以添加新数据
        ///4，如果存在mod覆盖这个表，完全使用覆盖该数据的mod的数据
        ///
        ///举例1：可处理覆盖次数:2,覆盖方式:2  表示从加载的mod中遇到的前两个该配置表，都不可覆盖原数据，但可以添加新数据
        ///
        ///举例2：可处理覆盖次数:-1,覆盖方式:4 表示使用最后一个该配置表的数据(覆盖原数据)
        /// </summary>
        public int CoverType { get; set; }
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
			HandleNum = (int)dict["HandleNum"];
			CoverType = (int)dict["CoverType"];
			CoverTableName = (string)dict["CoverTableName"];
			InitData();
        }

        
        public ConfigCover(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_ConfigCover, cfg_id);//public const string Config_ConfigCover = "cfg_ConfigCover"; 
			CoverId = (string)dict["CoverId"];
			CoverName = (string)dict["CoverName"];
			CoverDescribe = (string)dict["CoverDescribe"];
			HandleNum = (int)dict["HandleNum"];
			CoverType = (int)dict["CoverType"];
			CoverTableName = (string)dict["CoverTableName"];
			InitData();
        }

        public ConfigCover(Dictionary<string, object> dict)
        {
			CoverId = (string)dict["CoverId"];
			CoverName = (string)dict["CoverName"];
			CoverDescribe = (string)dict["CoverDescribe"];
			HandleNum = (int)dict["HandleNum"];
			CoverType = (int)dict["CoverType"];
			CoverTableName = (string)dict["CoverTableName"];
			InitData();
        }
        #endregion
    }
}
