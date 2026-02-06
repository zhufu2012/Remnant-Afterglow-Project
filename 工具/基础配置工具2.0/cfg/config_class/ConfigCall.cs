using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 ConfigCall 用于 配置调用关系表,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class ConfigCall
    {
        #region 参数及初始化
        /// <summary>
        /// 调用关系id
        /// </summary>
        public string CallId { get; set; }
        /// <summary>
        /// 读取子表名称
        /// </summary>
        public string ReadTableName { get; set; }
        /// <summary>
        /// 调用子表名称
        /// </summary>
        public string CallTableName { get; set; }
        /// <summary>
        /// 调用关系名称
        /// </summary>
        public string CallName { get; set; }
        /// <summary>
        /// 调用关系描述
        /// </summary>
        public string CallDescribe { get; set; }
        /// <summary>
        /// 调用关系
        /// </summary>
        public List<List<int>> CallCondition1 { get; set; }

        public ConfigCall(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_ConfigCall, id);//public const string Config_ConfigCall = "cfg_ConfigCall"; 
			CallId = (string)dict["CallId"];
			ReadTableName = (string)dict["ReadTableName"];
			CallTableName = (string)dict["CallTableName"];
			CallName = (string)dict["CallName"];
			CallDescribe = (string)dict["CallDescribe"];
			CallCondition1 = (List<List<int>>)dict["CallCondition1"];
			InitData();
        }

        
        public ConfigCall(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_ConfigCall, cfg_id);//public const string Config_ConfigCall = "cfg_ConfigCall"; 
			CallId = (string)dict["CallId"];
			ReadTableName = (string)dict["ReadTableName"];
			CallTableName = (string)dict["CallTableName"];
			CallName = (string)dict["CallName"];
			CallDescribe = (string)dict["CallDescribe"];
			CallCondition1 = (List<List<int>>)dict["CallCondition1"];
			InitData();
        }

        public ConfigCall(Dictionary<string, object> dict)
        {
			CallId = (string)dict["CallId"];
			ReadTableName = (string)dict["ReadTableName"];
			CallTableName = (string)dict["CallTableName"];
			CallName = (string)dict["CallName"];
			CallDescribe = (string)dict["CallDescribe"];
			CallCondition1 = (List<List<int>>)dict["CallCondition1"];
			InitData();
        }
        #endregion
    }
}
