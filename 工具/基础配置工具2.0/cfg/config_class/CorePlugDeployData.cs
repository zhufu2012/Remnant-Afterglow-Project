using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 CorePlugDeployData 用于 核心插件配置数据,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class CorePlugDeployData
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

        public CorePlugDeployData(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_CorePlugDeployData, id);//public const string Config_CorePlugDeployData = "cfg_CorePlugDeployData"; 
			ChapterId = (int)dict["ChapterId"];
			Key2Id = (int)dict["Key2Id"];
			CopyId = (int)dict["CopyId"];
			InitData();
        }

        
        public CorePlugDeployData(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_CorePlugDeployData, cfg_id);//public const string Config_CorePlugDeployData = "cfg_CorePlugDeployData"; 
			ChapterId = (int)dict["ChapterId"];
			Key2Id = (int)dict["Key2Id"];
			CopyId = (int)dict["CopyId"];
			InitData();
        }

        public CorePlugDeployData(Dictionary<string, object> dict)
        {
			ChapterId = (int)dict["ChapterId"];
			Key2Id = (int)dict["Key2Id"];
			CopyId = (int)dict["CopyId"];
			InitData();
        }
        #endregion
    }
}
