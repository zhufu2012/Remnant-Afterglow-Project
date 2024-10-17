using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 ItemDeployData 用于 道具配置界面数据,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class ItemDeployData
    {
        #region 参数及初始化
        /// <summary>
        /// 战役id
        ///cfg_ChapterBase_战役基础数据表id
        /// </summary>
        public int ChapterId { get; set; }
        /// <summary>
        /// 可配置道具框数量
        /// </summary>
        public int DeployNum { get; set; }

        public ItemDeployData(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_ItemDeployData, id);//public const string Config_ItemDeployData = "cfg_ItemDeployData"; 
			ChapterId = (int)dict["ChapterId"];
			DeployNum = (int)dict["DeployNum"];
			InitData();
        }

        
        public ItemDeployData(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_ItemDeployData, cfg_id);//public const string Config_ItemDeployData = "cfg_ItemDeployData"; 
			ChapterId = (int)dict["ChapterId"];
			DeployNum = (int)dict["DeployNum"];
			InitData();
        }

        public ItemDeployData(Dictionary<string, object> dict)
        {
			ChapterId = (int)dict["ChapterId"];
			DeployNum = (int)dict["DeployNum"];
			InitData();
        }
        #endregion
    }
}
