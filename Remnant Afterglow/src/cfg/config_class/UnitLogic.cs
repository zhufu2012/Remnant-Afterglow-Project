using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 UnitLogic 用于 单位逻辑表,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class UnitLogic
    {
        #region 参数及初始化
        /// <summary>        
        /// 实体id
        /// </summary>
        public int ObjectId { get; set; }
        /// <summary>        
        /// 单位类型
        ///1 陆军
        /// </summary>
        public int Type { get; set; }
        /// <summary>        
        /// 是否可以旋转武器
        ///表示武器能够跟随目标旋转
        /// </summary>
        public bool IsRotateWeapon { get; set; }
        /// <summary>        
        /// 免疫buffId列表
        /// </summary>
        public List<int> ImmuneList { get; set; }

        public UnitLogic(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_UnitLogic, id);//public const string Config_UnitLogic = "cfg_UnitLogic"; 
			ObjectId = (int)dict["ObjectId"];
			Type = (int)dict["Type"];
			IsRotateWeapon = (bool)dict["IsRotateWeapon"];
			ImmuneList = (List<int>)dict["ImmuneList"];
			InitData();
        }

        
        public UnitLogic(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_UnitLogic, cfg_id);//public const string Config_UnitLogic = "cfg_UnitLogic"; 
			ObjectId = (int)dict["ObjectId"];
			Type = (int)dict["Type"];
			IsRotateWeapon = (bool)dict["IsRotateWeapon"];
			ImmuneList = (List<int>)dict["ImmuneList"];
			InitData();
        }

        public UnitLogic(Dictionary<string, object> dict)
        {
			ObjectId = (int)dict["ObjectId"];
			Type = (int)dict["Type"];
			IsRotateWeapon = (bool)dict["IsRotateWeapon"];
			ImmuneList = (List<int>)dict["ImmuneList"];
			InitData();
        }
        #endregion
    }
}
