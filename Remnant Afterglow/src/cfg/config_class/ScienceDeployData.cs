using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 ScienceDeployData 用于 科技配置数据,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class ScienceDeployData
    {
        #region 参数及初始化
        /// <summary>
        /// 战役id
        ///cfg_ChapterBase_战役基础数据表id
        /// </summary>
        public int ChapterId { get; set; }
        /// <summary>
        /// 常规字段
        /// </summary>
        public int Key2Id { get; set; }
        /// <summary>
        /// 最后一个字段
        /// </summary>
        public int CopyId { get; set; }

        public ScienceDeployData(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_ScienceDeployData, id);//public const string Config_ScienceDeployData = "cfg_ScienceDeployData"; 
			ChapterId = (int)dict["ChapterId"];
			Key2Id = (int)dict["Key2Id"];
			CopyId = (int)dict["CopyId"];
			InitData();
        }

        
        public ScienceDeployData(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_ScienceDeployData, cfg_id);//public const string Config_ScienceDeployData = "cfg_ScienceDeployData"; 
			ChapterId = (int)dict["ChapterId"];
			Key2Id = (int)dict["Key2Id"];
			CopyId = (int)dict["CopyId"];
			InitData();
        }

        public ScienceDeployData(Dictionary<string, object> dict)
        {
			ChapterId = (int)dict["ChapterId"];
			Key2Id = (int)dict["Key2Id"];
			CopyId = (int)dict["CopyId"];
			InitData();
        }
        #endregion
    }
}
