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
        /// 建造列表标签id
        /// </summary>
        public int BuildLableId { get; set; }
        /// <summary>        
        /// 建造项id
        /// </summary>
        public string BuildItemId { get; set; }
        /// <summary>        
        /// 建造的实体id
        /// </summary>
        public int ObjectId { get; set; }
        /// <summary>        
        /// 显示条件
        ///
        /// </summary>
        public List<List<int>> ShowCondition { get; set; }
        /// <summary>        
        /// 子列表图标
        /// </summary>
        public Texture2D LablePng { get; set; }

        public MapBuildItem(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_MapBuildItem, id);//public const string Config_MapBuildItem = "cfg_MapBuildItem"; 
			BuildLableId = (int)dict["BuildLableId"];
			BuildItemId = (string)dict["BuildItemId"];
			ObjectId = (int)dict["ObjectId"];
			ShowCondition = (List<List<int>>)dict["ShowCondition"];
			LablePng = (Texture2D)dict["LablePng"];
			InitData();
        }

        
        public MapBuildItem(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_MapBuildItem, cfg_id);//public const string Config_MapBuildItem = "cfg_MapBuildItem"; 
			BuildLableId = (int)dict["BuildLableId"];
			BuildItemId = (string)dict["BuildItemId"];
			ObjectId = (int)dict["ObjectId"];
			ShowCondition = (List<List<int>>)dict["ShowCondition"];
			LablePng = (Texture2D)dict["LablePng"];
			InitData();
        }

        public MapBuildItem(Dictionary<string, object> dict)
        {
			BuildLableId = (int)dict["BuildLableId"];
			BuildItemId = (string)dict["BuildItemId"];
			ObjectId = (int)dict["ObjectId"];
			ShowCondition = (List<List<int>>)dict["ShowCondition"];
			LablePng = (Texture2D)dict["LablePng"];
			InitData();
        }
        #endregion
    }
}
