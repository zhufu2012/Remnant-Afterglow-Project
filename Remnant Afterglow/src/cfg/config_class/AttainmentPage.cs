using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 AttainmentPage 用于 数据库成就分页,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class AttainmentPage
    {
        #region 参数及初始化
        /// <summary>
        /// 成就分页id
        ///按这个id顺序从小到大排序
        /// </summary>
        public int PageId { get; set; }
        /// <summary>
        /// 分页名称
        /// </summary>
        public string PageName { get; set; }

        public AttainmentPage(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_AttainmentPage, id);//public const string Config_AttainmentPage = "cfg_AttainmentPage"; 
			PageId = (int)dict["PageId"];
			PageName = (string)dict["PageName"];
			InitData();
        }

        
        public AttainmentPage(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_AttainmentPage, cfg_id);//public const string Config_AttainmentPage = "cfg_AttainmentPage"; 
			PageId = (int)dict["PageId"];
			PageName = (string)dict["PageName"];
			InitData();
        }

        public AttainmentPage(Dictionary<string, object> dict)
        {
			PageId = (int)dict["PageId"];
			PageName = (string)dict["PageName"];
			InitData();
        }
        #endregion
    }
}
