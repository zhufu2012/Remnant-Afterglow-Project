using System.Collections.Generic;
Texture2Dnamespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 MapBuildList 用于 建造子列表,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class MapBuildList
    {
        #region 参数及初始化
        /// <summary>
        /// 建造列表标签id
        /// </summary>
        public int BuildLableId { get; set; }
        /// <summary>
        /// 建造子列表id
        /// </summary>
        public string BuildListId { get; set; }
        /// <summary>
        /// 建筑类型
        ///1 炮塔  建筑id是cfg_TowerData_炮塔基础
        ///2 建筑  建筑id是cfg_BuildData_建筑基础
        /// </summary>
        public int Type { get; set; }
        /// <summary>
        /// 建筑id
        /// </summary>
        public int Id { get; set; }
        /// <summary>
        /// 子列表图标
        /// </summary>
        public Texture2D LablePng { get; set; }

        public MapBuildList(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_MapBuildList, id);//public const string Config_MapBuildList = "cfg_MapBuildList"; 
			BuildLableId = (int)dict["BuildLableId"];
			BuildListId = (string)dict["BuildListId"];
			Type = (int)dict["Type"];
			Id = (int)dict["Id"];
			LablePng = (Texture2D)dict["LablePng"];
			InitData();
        }

        
        public MapBuildList(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_MapBuildList, cfg_id);//public const string Config_MapBuildList = "cfg_MapBuildList"; 
			BuildLableId = (int)dict["BuildLableId"];
			BuildListId = (string)dict["BuildListId"];
			Type = (int)dict["Type"];
			Id = (int)dict["Id"];
			LablePng = (Texture2D)dict["LablePng"];
			InitData();
        }

        public MapBuildList(Dictionary<string, object> dict)
        {
			BuildLableId = (int)dict["BuildLableId"];
			BuildListId = (string)dict["BuildListId"];
			Type = (int)dict["Type"];
			Id = (int)dict["Id"];
			LablePng = (Texture2D)dict["LablePng"];
			InitData();
        }
        #endregion
    }
}
