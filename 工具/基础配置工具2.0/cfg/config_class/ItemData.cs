using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 ItemData 用于 ,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class ItemData
    {
        #region 参数及初始化
        /// <summary>
        /// 道具id
        /// </summary>
        public int ItemId { get; set; }
        /// <summary>
        /// 道具名称
        /// </summary>
        public string ItemName { get; set; }
        /// <summary>
        /// 道具描述
        /// </summary>
        public string ItemDesc { get; set; }
        /// <summary>
        /// 道具类型
        /// </summary>
        public int ItemType { get; set; }
        /// <summary>
        /// 所在背包id
        /// </summary>
        public int BagId { get; set; }
        /// <summary>
        /// 创建存档时给与的数量
        ///为0表示创建存档时不给道具
        /// </summary>
        public int InitNum { get; set; }

        public ItemData(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_ItemData, id);//public const string Config_ItemData = "cfg_itemData"; 
			ItemId = (int)dict["ItemId"];
			ItemName = (string)dict["ItemName"];
			ItemDesc = (string)dict["ItemDesc"];
			ItemType = (int)dict["ItemType"];
			BagId = (int)dict["BagId"];
			InitNum = (int)dict["InitNum"];
			InitData();
        }

        
        public ItemData(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_ItemData, cfg_id);//public const string Config_ItemData = "cfg_itemData"; 
			ItemId = (int)dict["ItemId"];
			ItemName = (string)dict["ItemName"];
			ItemDesc = (string)dict["ItemDesc"];
			ItemType = (int)dict["ItemType"];
			BagId = (int)dict["BagId"];
			InitNum = (int)dict["InitNum"];
			InitData();
        }

        public ItemData(Dictionary<string, object> dict)
        {
			ItemId = (int)dict["ItemId"];
			ItemName = (string)dict["ItemName"];
			ItemDesc = (string)dict["ItemDesc"];
			ItemType = (int)dict["ItemType"];
			BagId = (int)dict["BagId"];
			InitNum = (int)dict["InitNum"];
			InitData();
        }
        #endregion
    }
}
