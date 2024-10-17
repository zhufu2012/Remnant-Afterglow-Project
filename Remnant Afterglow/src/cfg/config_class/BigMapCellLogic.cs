using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 BigMapCellLogic 用于 节点绘制逻辑,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class BigMapCellLogic
    {
        #region 参数及初始化
        /// <summary>
        /// 地图节点id
        /// </summary>
        public int NodeId { get; set; }
        /// <summary>
        /// 地图节点描述
        /// </summary>
        public int NodeIdDescribe { get; set; }

        public BigMapCellLogic(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BigMapCellLogic, id);//public const string Config_BigMapCellLogic = "cfg_BigMapCellLogic"; 
			NodeId = (int)dict["NodeId"];
			NodeIdDescribe = (int)dict["NodeIdDescribe"];
			InitData();
        }

        
        public BigMapCellLogic(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BigMapCellLogic, cfg_id);//public const string Config_BigMapCellLogic = "cfg_BigMapCellLogic"; 
			NodeId = (int)dict["NodeId"];
			NodeIdDescribe = (int)dict["NodeIdDescribe"];
			InitData();
        }

        public BigMapCellLogic(Dictionary<string, object> dict)
        {
			NodeId = (int)dict["NodeId"];
			NodeIdDescribe = (int)dict["NodeIdDescribe"];
			InitData();
        }
        #endregion
    }
}
