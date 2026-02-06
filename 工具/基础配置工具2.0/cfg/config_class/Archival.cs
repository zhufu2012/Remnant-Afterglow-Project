using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 Archival 用于 档案库主界面,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class Archival
    {
        #region 参数及初始化
        /// <summary>
        /// 主界面势力类型id
        /// </summary>
        public int ArchivalId { get; set; }
        /// <summary>
        /// 势力条目名称
        /// </summary>
        public string Name { get; set; }
        /// <summary>
        /// 默认是否解锁
        /// </summary>
        public bool IsDefine { get; set; }
        /// <summary>
        /// 子项id列表
        /// </summary>
        public List<int> ItemIdList { get; set; }

        public Archival(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_Archival, id);//public const string Config_Archival = "cfg_Archival"; 
			ArchivalId = (int)dict["ArchivalId"];
			Name = (string)dict["Name"];
			IsDefine = (bool)dict["IsDefine"];
			ItemIdList = (List<int>)dict["ItemIdList"];
			InitData();
        }

        
        public Archival(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_Archival, cfg_id);//public const string Config_Archival = "cfg_Archival"; 
			ArchivalId = (int)dict["ArchivalId"];
			Name = (string)dict["Name"];
			IsDefine = (bool)dict["IsDefine"];
			ItemIdList = (List<int>)dict["ItemIdList"];
			InitData();
        }

        public Archival(Dictionary<string, object> dict)
        {
			ArchivalId = (int)dict["ArchivalId"];
			Name = (string)dict["Name"];
			IsDefine = (bool)dict["IsDefine"];
			ItemIdList = (List<int>)dict["ItemIdList"];
			InitData();
        }
        #endregion
    }
}
