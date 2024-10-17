using System.Collections.Generic;
Vector2Vector2Inamespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 TowerData 用于 炮塔基础表,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class TowerData
    {
        #region 参数及初始化
        /// <summary>
        /// 炮塔ID
        ///（每个建筑特有的记号）
        /// </summary>
        public int TowerId { get; set; }
        /// <summary>
        /// 炮塔名称
        /// </summary>
        public string TowerName { get; set; }
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
        /// 炮塔归属
        ///（该建筑默认属于那方阵营）导用cfg_Troops_阵营
        /// </summary>
        public int CampId { get; set; }
        /// <summary>
        /// 炮塔占地(横轴，纵轴)
        ///（算直径吧，比较好算，按像素算，
        ///大多数单位都是敌人，也无所谓碰撞体精确了）(左上是)
        /// </summary>
        public Vector2I TowerSize { get; set; }
        /// <summary>
        /// 武器列表
        ///(武器id,阵营id(0是炮塔阵营，非0为对应阵营),坐标X，坐标Y) 坐标单位像素
        /// </summary>
        public List<List<int>> WeaponList { get; set; }
        /// <summary>
        /// 炮塔
        ///动画类型列表
        /// </summary>
        public List<int> AnimaTypeList { get; set; }

        public TowerData(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_TowerData, id);//public const string Config_TowerData = "cfg_TowerData"; 
			TowerId = (int)dict["TowerId"];
			TowerName = (string)dict["TowerName"];
			TempLateList = (List<int>)dict["TempLateList"];
			ObjectId = (int)dict["ObjectId"];
			CampId = (int)dict["CampId"];
			TowerSize = (Vector2I)dict["TowerSize"];
			WeaponList = (List<List<int>>)dict["WeaponList"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			InitData();
        }

        
        public TowerData(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_TowerData, cfg_id);//public const string Config_TowerData = "cfg_TowerData"; 
			TowerId = (int)dict["TowerId"];
			TowerName = (string)dict["TowerName"];
			TempLateList = (List<int>)dict["TempLateList"];
			ObjectId = (int)dict["ObjectId"];
			CampId = (int)dict["CampId"];
			TowerSize = (Vector2I)dict["TowerSize"];
			WeaponList = (List<List<int>>)dict["WeaponList"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			InitData();
        }

        public TowerData(Dictionary<string, object> dict)
        {
			TowerId = (int)dict["TowerId"];
			TowerName = (string)dict["TowerName"];
			TempLateList = (List<int>)dict["TempLateList"];
			ObjectId = (int)dict["ObjectId"];
			CampId = (int)dict["CampId"];
			TowerSize = (Vector2I)dict["TowerSize"];
			WeaponList = (List<List<int>>)dict["WeaponList"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			InitData();
        }
        #endregion
    }
}
