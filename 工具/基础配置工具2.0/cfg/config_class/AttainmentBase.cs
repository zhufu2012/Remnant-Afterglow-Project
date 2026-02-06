using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 AttainmentBase 用于 数据库成就相关配置,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class AttainmentBase
    {
        #region 参数及初始化
        /// <summary>
        /// 成就id
        /// </summary>
        public int AttainmentId { get; set; }
        /// <summary>
        /// 成就显示名称
        /// </summary>
        public string ShowName { get; set; }
        /// <summary>
        /// 成就分页
        ///cfg_AttainmentPage_数据库成就分页id
        /// </summary>
        public int PageId { get; set; }
        /// <summary>
        /// 成就解锁条件
        /// </summary>
        public List<List<int>> UnlockCondList { get; set; }
        /// <summary>
        /// 成就内容
        ///BBCode文本
        /// </summary>
        public string Content { get; set; }
        /// <summary>
        /// 成就未解锁时，
        ///显示的解锁条件文字
        /// </summary>
        public string UnlockCondStr { get; set; }

        public AttainmentBase(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_AttainmentBase, id);//public const string Config_AttainmentBase = "cfg_AttainmentBase"; 
			AttainmentId = (int)dict["AttainmentId"];
			ShowName = (string)dict["ShowName"];
			PageId = (int)dict["PageId"];
			UnlockCondList = (List<List<int>>)dict["UnlockCondList"];
			Content = (string)dict["Content"];
			UnlockCondStr = (string)dict["UnlockCondStr"];
			InitData();
        }

        
        public AttainmentBase(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_AttainmentBase, cfg_id);//public const string Config_AttainmentBase = "cfg_AttainmentBase"; 
			AttainmentId = (int)dict["AttainmentId"];
			ShowName = (string)dict["ShowName"];
			PageId = (int)dict["PageId"];
			UnlockCondList = (List<List<int>>)dict["UnlockCondList"];
			Content = (string)dict["Content"];
			UnlockCondStr = (string)dict["UnlockCondStr"];
			InitData();
        }

        public AttainmentBase(Dictionary<string, object> dict)
        {
			AttainmentId = (int)dict["AttainmentId"];
			ShowName = (string)dict["ShowName"];
			PageId = (int)dict["PageId"];
			UnlockCondList = (List<List<int>>)dict["UnlockCondList"];
			Content = (string)dict["Content"];
			UnlockCondStr = (string)dict["UnlockCondStr"];
			InitData();
        }
        #endregion
    }
}
