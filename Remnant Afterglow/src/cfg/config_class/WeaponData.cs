using System.Collections.Generic;
using Godot;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 WeaponData 用于 武器数据1,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class WeaponData
    {
        #region 参数及初始化
        /// <summary>        
        /// 实体id
        /// </summary>
        public int ObjectId { get; set; }
        /// <summary>        
        /// 武器名称
        /// </summary>
        public string Name { get; set; }
        /// <summary>        
        /// 武器描述
        /// </summary>
        public string Describe { get; set; }
        /// <summary>        
        /// 武器类型
        ///1 射弹类型
        ///2 激光类型
        /// </summary>
        public int Type { get; set; }
        /// <summary>        
        /// 武器弹道类型
        ///0 无类型
        ///1 直射，
        ///攻击路径上检测是否有悬崖之类的地块，有就不发射
        /// </summary>
        public int Ballistc { get; set; }
        /// <summary>        
        /// 武器被选中时，
        ///是否显示射程范围
        /// </summary>
        public bool ShowRange { get; set; }
        /// <summary>        
        /// 射程范围颜色
        /// </summary>
        public Color RangeColor { get; set; }
        /// <summary>        
        /// 动画类型列表
        ///cfg_AnimaWeapon_武器动画id列表
        /// </summary>
        public List<int> AnimaTypeList { get; set; }

        public WeaponData(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_WeaponData, id);//public const string Config_WeaponData = "cfg_WeaponData"; 
			ObjectId = (int)dict["ObjectId"];
			Name = (string)dict["Name"];
			Describe = (string)dict["Describe"];
			Type = (int)dict["Type"];
			Ballistc = (int)dict["Ballistc"];
			ShowRange = (bool)dict["ShowRange"];
			RangeColor = (Color)dict["RangeColor"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			InitData();
        }

        
        public WeaponData(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_WeaponData, cfg_id);//public const string Config_WeaponData = "cfg_WeaponData"; 
			ObjectId = (int)dict["ObjectId"];
			Name = (string)dict["Name"];
			Describe = (string)dict["Describe"];
			Type = (int)dict["Type"];
			Ballistc = (int)dict["Ballistc"];
			ShowRange = (bool)dict["ShowRange"];
			RangeColor = (Color)dict["RangeColor"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			InitData();
        }

        public WeaponData(Dictionary<string, object> dict)
        {
			ObjectId = (int)dict["ObjectId"];
			Name = (string)dict["Name"];
			Describe = (string)dict["Describe"];
			Type = (int)dict["Type"];
			Ballistc = (int)dict["Ballistc"];
			ShowRange = (bool)dict["ShowRange"];
			RangeColor = (Color)dict["RangeColor"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			InitData();
        }
        #endregion
    }
}
