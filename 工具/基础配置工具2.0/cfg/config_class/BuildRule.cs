using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 BuildRule 用于 建造规则,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class BuildRule
    {
        #region 参数及初始化
        /// <summary>        
        /// 建造规则ID
        /// </summary>
        public int BuildingID { get; set; }
        /// <summary>        
        /// 规则名称
        /// </summary>
        public string BuildingName { get; set; }
        /// <summary>        
        /// 检索标签
        /// </summary>
        public string searchTags { get; set; }
        /// <summary>        
        /// 检索队伍，自身|中立|盟友非自身|盟友|敌人|任何。  own|neutral|allyNotOwn|ally|enemy|any
        /// </summary>
        public string searchTeam { get; set; }
        /// <summary>        
        /// 搜索距离（像素距离）
        /// </summary>
        public int searchDistance { get; set; }
        /// <summary>        
        /// 最小数量
        /// </summary>
        public int minCount { get; set; }
        /// <summary>        
        /// 最大数量
        /// </summary>
        public int maxCount { get; set; }
        /// <summary>        
        /// 禁止放置
        /// </summary>
        public int blocksPlacement { get; set; }
        /// <summary>        
        /// 失败信息
        /// </summary>
        public int cannotPlaceMessage { get; set; }

        public BuildRule(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BuildRule, id);//public const string Config_BuildRule = "cfg_BuildRule"; 
			BuildingID = (int)dict["BuildingID"];
			BuildingName = (string)dict["BuildingName"];
			searchTags = (string)dict["searchTags"];
			searchTeam = (string)dict["searchTeam"];
			searchDistance = (int)dict["searchDistance"];
			minCount = (int)dict["minCount"];
			maxCount = (int)dict["maxCount"];
			blocksPlacement = (int)dict["blocksPlacement"];
			cannotPlaceMessage = (int)dict["cannotPlaceMessage"];
			InitData();
        }

        
        public BuildRule(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BuildRule, cfg_id);//public const string Config_BuildRule = "cfg_BuildRule"; 
			BuildingID = (int)dict["BuildingID"];
			BuildingName = (string)dict["BuildingName"];
			searchTags = (string)dict["searchTags"];
			searchTeam = (string)dict["searchTeam"];
			searchDistance = (int)dict["searchDistance"];
			minCount = (int)dict["minCount"];
			maxCount = (int)dict["maxCount"];
			blocksPlacement = (int)dict["blocksPlacement"];
			cannotPlaceMessage = (int)dict["cannotPlaceMessage"];
			InitData();
        }

        public BuildRule(Dictionary<string, object> dict)
        {
			BuildingID = (int)dict["BuildingID"];
			BuildingName = (string)dict["BuildingName"];
			searchTags = (string)dict["searchTags"];
			searchTeam = (string)dict["searchTeam"];
			searchDistance = (int)dict["searchDistance"];
			minCount = (int)dict["minCount"];
			maxCount = (int)dict["maxCount"];
			blocksPlacement = (int)dict["blocksPlacement"];
			cannotPlaceMessage = (int)dict["cannotPlaceMessage"];
			InitData();
        }
        #endregion
    }
}
