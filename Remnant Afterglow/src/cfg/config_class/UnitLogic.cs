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
        ///0 常规陆军 使用导航层1
        ///在地面移动的陆军
        ///1 爬行单位 导航层1和2
        ///2 悬浮单位 导航层1和3
        ///3 空军-战斗机类型 导航层1-4
        ///指没有通常加速减速过程，向目标移动并且盘旋的空军
        ///也用于表示使用对应的导航层
        /// </summary>
        public int UnitAIType { get; set; }
        /// <summary>        
        /// 武器列表
        ///(武器id,坐标X，坐标Y) 坐标单位像素
        /// </summary>
        public List<List<int>> WeaponList { get; set; }
        /// <summary>        
        /// 攻击时是否可以移动
        ///默认 true
        /// </summary>
        public bool AttackIsMove { get; set; }
        /// <summary>        
        /// 强制攻击范围
        ///该范围内的敌对目标将被单位所有武器强制攻击
        ///该功能用于防止建筑阻挡寻路路径
        ///0表示不使用
        /// </summary>
        public float ForceAttackRange { get; set; }
        /// <summary>        
        /// 与寻路终点的最近距离
        ///寻路到与终点在该距离内时，认为是已经达到终点
        ///要求尽量大于
        ///ForceAttackRange强制攻击范围
        /// </summary>
        public float PathfindingDis { get; set; }
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
			UnitAIType = (int)dict["UnitAIType"];
			WeaponList = (List<List<int>>)dict["WeaponList"];
			AttackIsMove = (bool)dict["AttackIsMove"];
			ForceAttackRange = (float)dict["ForceAttackRange"];
			PathfindingDis = (float)dict["PathfindingDis"];
			IsRotateWeapon = (bool)dict["IsRotateWeapon"];
			ImmuneList = (List<int>)dict["ImmuneList"];
			InitData();
        }

        
        public UnitLogic(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_UnitLogic, cfg_id);//public const string Config_UnitLogic = "cfg_UnitLogic"; 
			ObjectId = (int)dict["ObjectId"];
			UnitAIType = (int)dict["UnitAIType"];
			WeaponList = (List<List<int>>)dict["WeaponList"];
			AttackIsMove = (bool)dict["AttackIsMove"];
			ForceAttackRange = (float)dict["ForceAttackRange"];
			PathfindingDis = (float)dict["PathfindingDis"];
			IsRotateWeapon = (bool)dict["IsRotateWeapon"];
			ImmuneList = (List<int>)dict["ImmuneList"];
			InitData();
        }

        public UnitLogic(Dictionary<string, object> dict)
        {
			ObjectId = (int)dict["ObjectId"];
			UnitAIType = (int)dict["UnitAIType"];
			WeaponList = (List<List<int>>)dict["WeaponList"];
			AttackIsMove = (bool)dict["AttackIsMove"];
			ForceAttackRange = (float)dict["ForceAttackRange"];
			PathfindingDis = (float)dict["PathfindingDis"];
			IsRotateWeapon = (bool)dict["IsRotateWeapon"];
			ImmuneList = (List<int>)dict["ImmuneList"];
			InitData();
        }
        #endregion
    }
}
