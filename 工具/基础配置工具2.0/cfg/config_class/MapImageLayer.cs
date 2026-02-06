using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 MapImageLayer 用于 图像层配置,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class MapImageLayer
    {
        #region 参数及初始化
        /// <summary>
        /// 地图层id
        ///图层id高的显示在上面
        /// </summary>
        public int ImageLayerId { get; set; }
        /// <summary>
        /// 图层显示名称
        ///编辑器中用于显示
        /// </summary>
        public string LayerName { get; set; }
        /// <summary>
        /// 图层显示描述
        ///编辑器中用于显示
        /// </summary>
        public string LayerShowDes { get; set; }

        public MapImageLayer(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_MapImageLayer, id);//public const string Config_MapImageLayer = "cfg_MapImageLayer"; 
			ImageLayerId = (int)dict["ImageLayerId"];
			LayerName = (string)dict["LayerName"];
			LayerShowDes = (string)dict["LayerShowDes"];
			InitData();
        }

        
        public MapImageLayer(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_MapImageLayer, cfg_id);//public const string Config_MapImageLayer = "cfg_MapImageLayer"; 
			ImageLayerId = (int)dict["ImageLayerId"];
			LayerName = (string)dict["LayerName"];
			LayerShowDes = (string)dict["LayerShowDes"];
			InitData();
        }

        public MapImageLayer(Dictionary<string, object> dict)
        {
			ImageLayerId = (int)dict["ImageLayerId"];
			LayerName = (string)dict["LayerName"];
			LayerShowDes = (string)dict["LayerShowDes"];
			InitData();
        }
        #endregion
    }
}
