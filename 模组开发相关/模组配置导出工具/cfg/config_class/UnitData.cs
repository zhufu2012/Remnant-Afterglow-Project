using System.Collections.Generic;
using Godot;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 UnitData 用于 单位基础表,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class UnitData
    {
        #region 参数及初始化
        /// <summary>        
        /// 单位ID
        ///（每个建筑特有的记号）
        /// </summary>
        public int UnitId { get; set; }
        /// <summary>        
        /// 单位名称
        /// </summary>
        public string UnitName { get; set; }
        /// <summary>        
        /// 属性模板列表
        ///属性是cfg_AttributeTemplate_属性模板表与cfg_AttributeData_实体属性表覆盖的结果
        /// </summary>
        public List<int> TempLateList { get; set; }
        /// <summary>        
        /// 实体id
        ///用于属性等配置(要求唯一)
        /// </summary>
        public int ObjectId { get; set; }
        /// <summary>        
        /// 单位体积
        ///（算直径吧，比较好算，按像素算，
        ///大多数单位都是敌人，也无所谓碰撞体精确了）
        /// </summary>
        public int UnitSize { get; set; }
        /// <summary>        
        /// 单位归属
        ///（该建筑默认属于那方阵营）导用cfg_Troops_阵营
        /// </summary>
        public int CampId { get; set; }
        /// <summary>        
        /// 动画类型列表
        /// </summary>
        public List<int> AnimaTypeList { get; set; }
        /// <summary>        
        /// 阴影图像
        /// </summary>
        public Texture2D ShadowSprite { get; set; }
        /// <summary>        
        /// 阴影偏移
        /// </summary>
        public Vector2 ShadowOffset { get; set; }

        public UnitData(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_UnitData, id);//public const string Config_UnitData = "cfg_UnitData"; 
			UnitId = (int)dict["UnitId"];
			UnitName = (string)dict["UnitName"];
			TempLateList = (List<int>)dict["TempLateList"];
			ObjectId = (int)dict["ObjectId"];
			UnitSize = (int)dict["UnitSize"];
			CampId = (int)dict["CampId"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			ShadowSprite = (Texture2D)dict["ShadowSprite"];
			ShadowOffset = (Vector2)dict["ShadowOffset"];
			InitData();
        }

        
        public UnitData(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_UnitData, cfg_id);//public const string Config_UnitData = "cfg_UnitData"; 
			UnitId = (int)dict["UnitId"];
			UnitName = (string)dict["UnitName"];
			TempLateList = (List<int>)dict["TempLateList"];
			ObjectId = (int)dict["ObjectId"];
			UnitSize = (int)dict["UnitSize"];
			CampId = (int)dict["CampId"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			ShadowSprite = (Texture2D)dict["ShadowSprite"];
			ShadowOffset = (Vector2)dict["ShadowOffset"];
			InitData();
        }

        public UnitData(Dictionary<string, object> dict)
        {
			UnitId = (int)dict["UnitId"];
			UnitName = (string)dict["UnitName"];
			TempLateList = (List<int>)dict["TempLateList"];
			ObjectId = (int)dict["ObjectId"];
			UnitSize = (int)dict["UnitSize"];
			CampId = (int)dict["CampId"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			ShadowSprite = (Texture2D)dict["ShadowSprite"];
			ShadowOffset = (Vector2)dict["ShadowOffset"];
			InitData();
        }
        #endregion
    }
}
