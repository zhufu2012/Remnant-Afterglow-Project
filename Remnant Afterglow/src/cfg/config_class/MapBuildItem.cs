using System.Collections.Generic;
using Godot;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 MapBuildItem 用于 建造项数据,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class MapBuildItem
    {
        #region 参数及初始化
        /// <summary>
        /// 建造项id
        /// </summary>
        public int BuildItemId { get; set; }
        /// <summary>
        /// 建造列表标签id
        /// </summary>
        public int BuildLableId { get; set; }
        /// <summary>
        /// 建造的实体id
        /// </summary>
        public int ObjectId { get; set; }
        /// <summary>
        /// 是否需要科技解锁
        ///
        /// </summary>
        public bool IsNeedScience { get; set; }
        /// <summary>
        /// 子列表图标
        /// </summary>
        public Texture2D LablePng { get; set; }

        public MapBuildItem(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_MapBuildItem, id);//public const string Config_MapBuildItem = "cfg_MapBuildItem"; 
			BuildItemId = (int)dict["BuildItemId"];
			BuildLableId = (int)dict["BuildLableId"];
			ObjectId = (int)dict["ObjectId"];
			IsNeedScience = (bool)dict["IsNeedScience"];
			LablePng = (Texture2D)dict["LablePng"];
			InitData();
        }

        
        public MapBuildItem(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_MapBuildItem, cfg_id);//public const string Config_MapBuildItem = "cfg_MapBuildItem"; 
			BuildItemId = (int)dict["BuildItemId"];
			BuildLableId = (int)dict["BuildLableId"];
			ObjectId = (int)dict["ObjectId"];
			IsNeedScience = (bool)dict["IsNeedScience"];
			LablePng = (Texture2D)dict["LablePng"];
			InitData();
        }

        public MapBuildItem(Dictionary<string, object> dict)
        {
			BuildItemId = (int)dict["BuildItemId"];
			BuildLableId = (int)dict["BuildLableId"];
			ObjectId = (int)dict["ObjectId"];
			IsNeedScience = (bool)dict["IsNeedScience"];
			LablePng = (Texture2D)dict["LablePng"];
			InitData();
        }
        #endregion
    }
}
