using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 MapPassType 用于 地图可通过类型,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class MapPassType
    {
        #region 参数及初始化
        /// <summary>
        /// 可通过id
        /// </summary>
        public int PassTypeId { get; set; }
        /// <summary>
        /// 是否可建造
        /// </summary>
        public bool IsBuild { get; set; }
        /// <summary>
        /// 是否可通行
        /// </summary>
        public bool IsPass { get; set; }
        /// <summary>
        /// 可攻击类型
        ///1 无视
        ///2 武器直射类型禁止
        /// </summary>
        public int ExamineType { get; set; }
        /// <summary>
        /// 通过代价
        ///寻路计算时，
        ///通过该地形的代价
        /// </summary>
        public int PassCost { get; set; }
        /// <summary>
        /// 周围地块通行代价增益
        ///周围8个块代价进行增加或减少
        /// </summary>
        public int PassCostAdd { get; set; }
        /// <summary>
        /// 通过类型
        ///0无影响
        ///1单位到上面就会停止主动移动
        ///2会直接阻止任何陆军和
        ///爬行单位通过该地块
        /// </summary>
        public int Type { get; set; }
        /// <summary>
        /// 陆军通过时速度参数
        ///通过效率-陆军和爬行通过该地块时移动速度的比例，是个乘率，乘以单位的通过能力，1为没有减速，数字越小减速越多，0为无效
        /// </summary>
        public float PassSpeedParm { get; set; }
        /// <summary>
        /// 对其上建筑影响
        /// </summary>
        public string BuildInfluence { get; set; }
        /// <summary>
        /// 对其上单位影响
        /// </summary>
        public string UnitInfluence { get; set; }

        public MapPassType(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_MapPassType, id);//public const string Config_MapPassType = "cfg_MapPassType"; 
			PassTypeId = (int)dict["PassTypeId"];
			IsBuild = (bool)dict["IsBuild"];
			IsPass = (bool)dict["IsPass"];
			ExamineType = (int)dict["ExamineType"];
			PassCost = (int)dict["PassCost"];
			PassCostAdd = (int)dict["PassCostAdd"];
			Type = (int)dict["Type"];
			PassSpeedParm = (float)dict["PassSpeedParm"];
			BuildInfluence = (string)dict["BuildInfluence"];
			UnitInfluence = (string)dict["UnitInfluence"];
			InitData();
        }

        
        public MapPassType(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_MapPassType, cfg_id);//public const string Config_MapPassType = "cfg_MapPassType"; 
			PassTypeId = (int)dict["PassTypeId"];
			IsBuild = (bool)dict["IsBuild"];
			IsPass = (bool)dict["IsPass"];
			ExamineType = (int)dict["ExamineType"];
			PassCost = (int)dict["PassCost"];
			PassCostAdd = (int)dict["PassCostAdd"];
			Type = (int)dict["Type"];
			PassSpeedParm = (float)dict["PassSpeedParm"];
			BuildInfluence = (string)dict["BuildInfluence"];
			UnitInfluence = (string)dict["UnitInfluence"];
			InitData();
        }

        public MapPassType(Dictionary<string, object> dict)
        {
			PassTypeId = (int)dict["PassTypeId"];
			IsBuild = (bool)dict["IsBuild"];
			IsPass = (bool)dict["IsPass"];
			ExamineType = (int)dict["ExamineType"];
			PassCost = (int)dict["PassCost"];
			PassCostAdd = (int)dict["PassCostAdd"];
			Type = (int)dict["Type"];
			PassSpeedParm = (float)dict["PassSpeedParm"];
			BuildInfluence = (string)dict["BuildInfluence"];
			UnitInfluence = (string)dict["UnitInfluence"];
			InitData();
        }
        #endregion
    }
}
