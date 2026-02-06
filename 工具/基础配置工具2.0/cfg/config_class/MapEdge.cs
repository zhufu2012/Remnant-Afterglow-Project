using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 MapEdge 用于 地图边缘连接配置,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class MapEdge
    {
        #region 参数及初始化
        /// <summary>
        /// 地图生成用材料id
        ///不能为0（通常情况，请使用6号贴图来作为基准）
        /// </summary>
        public int MaterialId { get; set; }
        /// <summary>
        /// 边缘连接所用图集id
        ///需要图集按照一定顺序排列
        ///地块表cfg_MapImageSet_地图图像集id
        /// </summary>
        public int ImageSetId { get; set; }

        public MapEdge(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_MapEdge, id);//public const string Config_MapEdge = "cfg_MapEdge"; 
			MaterialId = (int)dict["MaterialId"];
			ImageSetId = (int)dict["ImageSetId"];
			InitData();
        }

        
        public MapEdge(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_MapEdge, cfg_id);//public const string Config_MapEdge = "cfg_MapEdge"; 
			MaterialId = (int)dict["MaterialId"];
			ImageSetId = (int)dict["ImageSetId"];
			InitData();
        }

        public MapEdge(Dictionary<string, object> dict)
        {
			MaterialId = (int)dict["MaterialId"];
			ImageSetId = (int)dict["ImageSetId"];
			InitData();
        }
        #endregion
    }
}
