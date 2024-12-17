using System.Collections.Generic;
using Godot;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 TowerData 用于 炮塔基础表,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class TowerData
    {
        #region 参数及初始化
        /// <summary>        
        /// 实体id
        /// </summary>
        public int ObjectId { get; set; }
        /// <summary>        
        /// 炮塔名称
        /// </summary>
        public string TowerName { get; set; }
        /// <summary>        
        /// 炮塔占地(横轴，纵轴)
        ///（算直径吧，比较好算，按像素算，
        ///大多数单位都是敌人，也无所谓碰撞体精确了）(左上是)
        /// </summary>
        public Vector2I TowerSize { get; set; }
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
        /// 武器列表
        ///(武器id,坐标X，坐标Y) 坐标单位像素
        /// </summary>
        public List<List<int>> WeaponList { get; set; }
        /// <summary>        
        /// 武器
        ///动画类型列表
        /// </summary>
        public List<int> AnimaTypeList { get; set; }

        public TowerData(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_TowerData, id);//public const string Config_TowerData = "cfg_TowerData"; 
			ObjectId = (int)dict["ObjectId"];
			TowerName = (string)dict["TowerName"];
			TowerSize = (Vector2I)dict["TowerSize"];
			BuildingRules = (List<int>)dict["BuildingRules"];
			BuildProgress = (int)dict["BuildProgress"];
			WeaponList = (List<List<int>>)dict["WeaponList"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			InitData();
        }

        
        public TowerData(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_TowerData, cfg_id);//public const string Config_TowerData = "cfg_TowerData"; 
			ObjectId = (int)dict["ObjectId"];
			TowerName = (string)dict["TowerName"];
			TowerSize = (Vector2I)dict["TowerSize"];
			BuildingRules = (List<int>)dict["BuildingRules"];
			BuildProgress = (int)dict["BuildProgress"];
			WeaponList = (List<List<int>>)dict["WeaponList"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			InitData();
        }

        public TowerData(Dictionary<string, object> dict)
        {
			ObjectId = (int)dict["ObjectId"];
			TowerName = (string)dict["TowerName"];
			TowerSize = (Vector2I)dict["TowerSize"];
			BuildingRules = (List<int>)dict["BuildingRules"];
			BuildProgress = (int)dict["BuildProgress"];
			WeaponList = (List<List<int>>)dict["WeaponList"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			InitData();
        }
        #endregion
    }
}
