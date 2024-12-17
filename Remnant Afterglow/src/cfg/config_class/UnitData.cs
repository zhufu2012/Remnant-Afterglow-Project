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
        /// 实体id
        /// </summary>
        public int ObjectId { get; set; }
        /// <summary>        
        /// 单位名称
        /// </summary>
        public string UnitName { get; set; }
        /// <summary>        
        /// 动画类型列表
        ///注意默认移动方向是向上
        ///
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
			ObjectId = (int)dict["ObjectId"];
			UnitName = (string)dict["UnitName"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			ShadowSprite = (Texture2D)dict["ShadowSprite"];
			ShadowOffset = (Vector2)dict["ShadowOffset"];
			InitData();
        }

        
        public UnitData(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_UnitData, cfg_id);//public const string Config_UnitData = "cfg_UnitData"; 
			ObjectId = (int)dict["ObjectId"];
			UnitName = (string)dict["UnitName"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			ShadowSprite = (Texture2D)dict["ShadowSprite"];
			ShadowOffset = (Vector2)dict["ShadowOffset"];
			InitData();
        }

        public UnitData(Dictionary<string, object> dict)
        {
			ObjectId = (int)dict["ObjectId"];
			UnitName = (string)dict["UnitName"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			ShadowSprite = (Texture2D)dict["ShadowSprite"];
			ShadowOffset = (Vector2)dict["ShadowOffset"];
			InitData();
        }
        #endregion
    }
}
