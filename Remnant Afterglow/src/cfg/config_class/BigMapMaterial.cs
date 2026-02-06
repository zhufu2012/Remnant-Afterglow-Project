using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 BigMapMaterial 用于 大地图节点,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class BigMapMaterial
    {
        #region 参数及初始化
        /// <summary>
        /// 地图节点id
        /// </summary>
        public int NodeId { get; set; }
        /// <summary>
        /// 地图节点类型
        ///暂不使用
        /// </summary>
        public int NodeType { get; set; }
        /// <summary>
        /// 节点所用图集id
        ///地块表的cfg_MapImageSet_地图图像集id
        /// </summary>
        public int ImageSetId { get; set; }
        /// <summary>
        /// 所在图集序号
        /// </summary>
        public int ImageSetIndex { get; set; }
        /// <summary>
        /// 节点绘制逻辑id列表
        /// </summary>
        public List<int> LogicIdList { get; set; }
        /// <summary>
        /// 是否可选中
        /// </summary>
        public bool IsSelect { get; set; }
        /// <summary>
        /// 是否可点击
        /// </summary>
        public bool IsClick { get; set; }
        /// <summary>
        /// 地图节点 点击事件列表
        ///cfg_BigMapEvent_大地图节点事件的id列表
        /// </summary>
        public List<int> NodeClickEventList { get; set; }
        /// <summary>
        /// 地图节点 进入事件列表
        ///
        ///cfg_BigMapEvent_大地图节点事件的id列表
        /// </summary>
        public List<int> NodeEnterEventList { get; set; }

        public BigMapMaterial(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BigMapMaterial, id);//public const string Config_BigMapMaterial = "cfg_BigMapMaterial"; 
			NodeId = (int)dict["NodeId"];
			NodeType = (int)dict["NodeType"];
			ImageSetId = (int)dict["ImageSetId"];
			ImageSetIndex = (int)dict["ImageSetIndex"];
			LogicIdList = (List<int>)dict["LogicIdList"];
			IsSelect = (bool)dict["IsSelect"];
			IsClick = (bool)dict["IsClick"];
			NodeClickEventList = (List<int>)dict["NodeClickEventList"];
			NodeEnterEventList = (List<int>)dict["NodeEnterEventList"];
			InitData();
        }

        
        public BigMapMaterial(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BigMapMaterial, cfg_id);//public const string Config_BigMapMaterial = "cfg_BigMapMaterial"; 
			NodeId = (int)dict["NodeId"];
			NodeType = (int)dict["NodeType"];
			ImageSetId = (int)dict["ImageSetId"];
			ImageSetIndex = (int)dict["ImageSetIndex"];
			LogicIdList = (List<int>)dict["LogicIdList"];
			IsSelect = (bool)dict["IsSelect"];
			IsClick = (bool)dict["IsClick"];
			NodeClickEventList = (List<int>)dict["NodeClickEventList"];
			NodeEnterEventList = (List<int>)dict["NodeEnterEventList"];
			InitData();
        }

        public BigMapMaterial(Dictionary<string, object> dict)
        {
			NodeId = (int)dict["NodeId"];
			NodeType = (int)dict["NodeType"];
			ImageSetId = (int)dict["ImageSetId"];
			ImageSetIndex = (int)dict["ImageSetIndex"];
			LogicIdList = (List<int>)dict["LogicIdList"];
			IsSelect = (bool)dict["IsSelect"];
			IsClick = (bool)dict["IsClick"];
			NodeClickEventList = (List<int>)dict["NodeClickEventList"];
			NodeEnterEventList = (List<int>)dict["NodeEnterEventList"];
			InitData();
        }
        #endregion
    }
}
