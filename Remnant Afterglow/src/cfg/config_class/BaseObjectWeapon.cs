using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 BaseObjectWeapon 用于 实体武器表,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class BaseObjectWeapon
    {
        #region 参数及初始化
        /// <summary>        
        /// 实体id
        ///实体唯一id,不能为负数或0
        /// </summary>
        public int ObjectId { get; set; }
        /// <summary>        
        /// 总共多少个武器
        /// </summary>
        public int WeaponNum { get; set; }
        /// <summary>        
        /// 武器位列表
        ///（武器位,武器实体id,偏移位置x,偏移位置y）
        /// </summary>
        public List<List<int>> CampId { get; set; }

        public BaseObjectWeapon(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BaseObjectWeapon, id);//public const string Config_BaseObjectWeapon = "cfg_BaseObjectWeapon"; 
			ObjectId = (int)dict["ObjectId"];
			WeaponNum = (int)dict["WeaponNum"];
			CampId = (List<List<int>>)dict["CampId"];
			InitData();
        }

        
        public BaseObjectWeapon(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BaseObjectWeapon, cfg_id);//public const string Config_BaseObjectWeapon = "cfg_BaseObjectWeapon"; 
			ObjectId = (int)dict["ObjectId"];
			WeaponNum = (int)dict["WeaponNum"];
			CampId = (List<List<int>>)dict["CampId"];
			InitData();
        }

        public BaseObjectWeapon(Dictionary<string, object> dict)
        {
			ObjectId = (int)dict["ObjectId"];
			WeaponNum = (int)dict["WeaponNum"];
			CampId = (List<List<int>>)dict["CampId"];
			InitData();
        }
        #endregion
    }
}
