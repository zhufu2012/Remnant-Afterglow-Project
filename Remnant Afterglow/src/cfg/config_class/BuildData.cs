using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 BuildData 用于 建筑及炮塔数据,拓展请在expand_class文件下使用partial拓展
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
        /// 建筑描述
        ///
        /// </summary>
        public string Describe { get; set; }
        /// <summary>        
        /// 建筑类型
        ///0 建筑
        ///1 炮塔
        ///默认为建筑
        /// </summary>
        public int Type { get; set; }
        /// <summary>        
        /// 建筑归属
        ///（该建筑默认属于那方阵营）
        ///导用cfg_Troops_阵营
        /// </summary>
        public int DefaultCamp { get; set; }
        /// <summary>        
        /// 建造价格
        ///(货币id，数量)
        ///cfg_MoneyBase_货币界面显示配置
        ///目前只有1，2，3可用（与图有关系）
        /// </summary>
        public List<List<int>> Price { get; set; }
        /// <summary>        
        /// 生产周期时长（秒）
        ///0 表示无生产周期
        /// </summary>
        public int WeekLength { get; set; }
        /// <summary>        
        /// 周期生产资源数
        ///(货币id，数量)
        ///cfg_MoneyBase_货币
        /// </summary>
        public List<List<int>> WeekResources { get; set; }
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
        /// 最大建造进度
        ///每秒增加60的建造进度
        /// </summary>
        public int BuildProgress { get; set; }
        /// <summary>        
        /// 动画类型列表
        /// </summary>
        public List<int> AnimaTypeList { get; set; }
        /// <summary>        
        /// 武器列表
        ///(武器id,坐标X，坐标Y) 坐标单位像素
        /// </summary>
        public List<List<int>> WeaponList { get; set; }

        public BuildData(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BuildData, id);//public const string Config_BuildData = "cfg_BuildData"; 
			ObjectId = (int)dict["ObjectId"];
			BuildingName = (string)dict["BuildingName"];
			Describe = (string)dict["Describe"];
			Type = (int)dict["Type"];
			DefaultCamp = (int)dict["DefaultCamp"];
			Price = (List<List<int>>)dict["Price"];
			WeekLength = (int)dict["WeekLength"];
			WeekResources = (List<List<int>>)dict["WeekResources"];
			BuildingSize = (int)dict["BuildingSize"];
			BuildingRules = (List<int>)dict["BuildingRules"];
			BuildProgress = (int)dict["BuildProgress"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			WeaponList = (List<List<int>>)dict["WeaponList"];
			InitData();
        }

        
        public BuildData(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BuildData, cfg_id);//public const string Config_BuildData = "cfg_BuildData"; 
			ObjectId = (int)dict["ObjectId"];
			BuildingName = (string)dict["BuildingName"];
			Describe = (string)dict["Describe"];
			Type = (int)dict["Type"];
			DefaultCamp = (int)dict["DefaultCamp"];
			Price = (List<List<int>>)dict["Price"];
			WeekLength = (int)dict["WeekLength"];
			WeekResources = (List<List<int>>)dict["WeekResources"];
			BuildingSize = (int)dict["BuildingSize"];
			BuildingRules = (List<int>)dict["BuildingRules"];
			BuildProgress = (int)dict["BuildProgress"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			WeaponList = (List<List<int>>)dict["WeaponList"];
			InitData();
        }

        public BuildData(Dictionary<string, object> dict)
        {
			ObjectId = (int)dict["ObjectId"];
			BuildingName = (string)dict["BuildingName"];
			Describe = (string)dict["Describe"];
			Type = (int)dict["Type"];
			DefaultCamp = (int)dict["DefaultCamp"];
			Price = (List<List<int>>)dict["Price"];
			WeekLength = (int)dict["WeekLength"];
			WeekResources = (List<List<int>>)dict["WeekResources"];
			BuildingSize = (int)dict["BuildingSize"];
			BuildingRules = (List<int>)dict["BuildingRules"];
			BuildProgress = (int)dict["BuildProgress"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			WeaponList = (List<List<int>>)dict["WeaponList"];
			InitData();
        }
        #endregion
    }
}
