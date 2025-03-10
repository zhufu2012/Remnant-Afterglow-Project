using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 MapPhysicsLayer 用于 物理层配置,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class MapPhysicsLayer
    {
        #region 参数及初始化
        /// <summary>        
        /// 物理层id
        ///取值1-32
        ///
        ///24及以上为建造系统使用的特殊层（不导出）
        ///拥有24及以上层的建筑或单位在地图上某位置时，对应位置不可建造
        /// </summary>
        public int PhysicsLayerId { get; set; }
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

        public MapPhysicsLayer(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_MapPhysicsLayer, id);//public const string Config_MapPhysicsLayer = "cfg_MapPhysicsLayer"; 
			PhysicsLayerId = (int)dict["PhysicsLayerId"];
			LayerName = (string)dict["LayerName"];
			LayerShowDes = (string)dict["LayerShowDes"];
			InitData();
        }

        
        public MapPhysicsLayer(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_MapPhysicsLayer, cfg_id);//public const string Config_MapPhysicsLayer = "cfg_MapPhysicsLayer"; 
			PhysicsLayerId = (int)dict["PhysicsLayerId"];
			LayerName = (string)dict["LayerName"];
			LayerShowDes = (string)dict["LayerShowDes"];
			InitData();
        }

        public MapPhysicsLayer(Dictionary<string, object> dict)
        {
			PhysicsLayerId = (int)dict["PhysicsLayerId"];
			LayerName = (string)dict["LayerName"];
			LayerShowDes = (string)dict["LayerShowDes"];
			InitData();
        }
        #endregion
    }
}
