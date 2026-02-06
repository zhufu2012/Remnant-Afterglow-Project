using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 BagData 用于 ,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class BagData
    {
        #region 参数及初始化
        /// <summary>
        /// 背包id
        /// </summary>
        public int BagId { get; set; }
        /// <summary>
        /// 背包名称
        /// </summary>
        public string BagName { get; set; }
        /// <summary>
        /// 背包描述
        /// </summary>
        public string BagDesc { get; set; }
        /// <summary>
        /// 背包类型
        ///0 系统背包
        ///（无法看见)
        ///1 常规玩家背包
        ///（可以看见）
        /// </summary>
        public int BagType { get; set; }

        public BagData(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BagData, id);//public const string Config_BagData = "cfg_bagData"; 
			BagId = (int)dict["BagId"];
			BagName = (string)dict["BagName"];
			BagDesc = (string)dict["BagDesc"];
			BagType = (int)dict["BagType"];
			InitData();
        }

        
        public BagData(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BagData, cfg_id);//public const string Config_BagData = "cfg_bagData"; 
			BagId = (int)dict["BagId"];
			BagName = (string)dict["BagName"];
			BagDesc = (string)dict["BagDesc"];
			BagType = (int)dict["BagType"];
			InitData();
        }

        public BagData(Dictionary<string, object> dict)
        {
			BagId = (int)dict["BagId"];
			BagName = (string)dict["BagName"];
			BagDesc = (string)dict["BagDesc"];
			BagType = (int)dict["BagType"];
			InitData();
        }
        #endregion
    }
}
