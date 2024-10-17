using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 BuildData 用于 建筑建筑数据,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class BuildData
    {
        #region 参数及初始化
        /// <summary>
        /// 建筑ID（每个建筑特有的记号）
        /// </summary>
        public int BuildingID { get; set; }
        /// <summary>
        /// 建筑名称
        /// </summary>
        public string BuildingName { get; set; }
        /// <summary>
        /// 属性模板列表
        ///属性是cfg_AttributeTemplate_属性模板表与cfg_AttributeData_实体属性表覆盖的结果
        /// </summary>
        public List<int> TempLateList { get; set; }
        /// <summary>
        /// 实体id
        ///用于属性等配置
        ///(要求唯一)
        /// </summary>
        public int ObjectId { get; set; }
        /// <summary>
        /// 建筑归属
        ///（该建筑默认属于那方阵营）
        ///导用cfg_Troops_阵营
        /// </summary>
        public int DefaultCamp { get; set; }
        /// <summary>
        /// 建筑占地边长，1是1格 2是4格
        ///
        /// </summary>
        public int BuildingSize { get; set; }
        /// <summary>
        /// 建造规则
        /// </summary>
        public List<int> BuildingRules { get; set; }
        /// <summary>
        /// 动画类型列表
        /// </summary>
        public List<int> AnimaTypeList { get; set; }

        public BuildData(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BuildData, id);//public const string Config_BuildData = "cfg_BuildData"; 
			BuildingID = (int)dict["BuildingID"];
			BuildingName = (string)dict["BuildingName"];
			TempLateList = (List<int>)dict["TempLateList"];
			ObjectId = (int)dict["ObjectId"];
			DefaultCamp = (int)dict["DefaultCamp"];
			BuildingSize = (int)dict["BuildingSize"];
			BuildingRules = (List<int>)dict["BuildingRules"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			InitData();
        }

        
        public BuildData(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BuildData, cfg_id);//public const string Config_BuildData = "cfg_BuildData"; 
			BuildingID = (int)dict["BuildingID"];
			BuildingName = (string)dict["BuildingName"];
			TempLateList = (List<int>)dict["TempLateList"];
			ObjectId = (int)dict["ObjectId"];
			DefaultCamp = (int)dict["DefaultCamp"];
			BuildingSize = (int)dict["BuildingSize"];
			BuildingRules = (List<int>)dict["BuildingRules"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			InitData();
        }

        public BuildData(Dictionary<string, object> dict)
        {
			BuildingID = (int)dict["BuildingID"];
			BuildingName = (string)dict["BuildingName"];
			TempLateList = (List<int>)dict["TempLateList"];
			ObjectId = (int)dict["ObjectId"];
			DefaultCamp = (int)dict["DefaultCamp"];
			BuildingSize = (int)dict["BuildingSize"];
			BuildingRules = (List<int>)dict["BuildingRules"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			InitData();
        }
        #endregion
    }
}
