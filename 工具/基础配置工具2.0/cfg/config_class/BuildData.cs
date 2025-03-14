using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 BuildData 用于 建筑数据,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class BuildData
    {
        #region 参数及初始化
        /// <summary>        
        /// 实体id
        /// </summary>
        public int ObjectId { get; set; }
        /// <summary>        
        /// 建筑名称
        /// </summary>
        public string BuildingName { get; set; }
        /// <summary>        
        /// 建筑归属
        ///（该建筑默认属于那方阵营）
        ///导用cfg_Troops_阵营
        /// </summary>
        public int DefaultCamp { get; set; }
        /// <summary>        
        /// 建筑占地边长（正方形），
        ///1是1格 2是4格
        ///
        /// </summary>
        public int BuildingSize { get; set; }
        /// <summary>        
        /// 建造规则
        ///cfg_BuildRule_建造
        ///规则id列表
        /// </summary>
        public List<int> BuildingRules { get; set; }
        /// <summary>        
        /// 
        /// </summary>
        public int BuildProgress { get; set; }
        /// <summary>        
        /// 
        /// </summary>
        public List<int> AnimaTypeList { get; set; }

        public BuildData(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BuildData, id);//public const string Config_BuildData = "cfg_BuildData"; 
			ObjectId = (int)dict["ObjectId"];
			BuildingName = (string)dict["BuildingName"];
			DefaultCamp = (int)dict["DefaultCamp"];
			BuildingSize = (int)dict["BuildingSize"];
			BuildingRules = (List<int>)dict["BuildingRules"];
			BuildProgress = (int)dict["BuildProgress"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			InitData();
        }

        
        public BuildData(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BuildData, cfg_id);//public const string Config_BuildData = "cfg_BuildData"; 
			ObjectId = (int)dict["ObjectId"];
			BuildingName = (string)dict["BuildingName"];
			DefaultCamp = (int)dict["DefaultCamp"];
			BuildingSize = (int)dict["BuildingSize"];
			BuildingRules = (List<int>)dict["BuildingRules"];
			BuildProgress = (int)dict["BuildProgress"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			InitData();
        }

        public BuildData(Dictionary<string, object> dict)
        {
			ObjectId = (int)dict["ObjectId"];
			BuildingName = (string)dict["BuildingName"];
			DefaultCamp = (int)dict["DefaultCamp"];
			BuildingSize = (int)dict["BuildingSize"];
			BuildingRules = (List<int>)dict["BuildingRules"];
			BuildProgress = (int)dict["BuildProgress"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			InitData();
        }
        #endregion
    }
}
