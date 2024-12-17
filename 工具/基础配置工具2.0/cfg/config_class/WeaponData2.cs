using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 WeaponData2 用于 武器数据2,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class WeaponData2
    {
        #region 参数及初始化
        /// <summary>        
        /// 实体id
        /// </summary>
        public int ObjectId { get; set; }
        /// <summary>        
        /// 武器射程
        ///单位（1/20格）
        /// </summary>
        public float Range { get; set; }
        /// <summary>        
        /// 武器周期发射量
        ///指武器在一个 开火-间隔-开火-间隔-开火-冷却开始-冷却完成的过程中，总共开火多少次
        ///
        /// </summary>
        public int LaunchTotal { get; set; }
        /// <summary>        
        /// 武器单个周期内每次发射间间隔(帧数)
        ///0 表示无间隔，一次性射出
        ///武器周期发射总量
        ///1 表示每1帧射出武器单次发射数，然后隔对应帧后继续发射，直到发射完就开始冷却
        /// </summary>
        public int EmissionInterval { get; set; }
        /// <summary>        
        /// 武器的开火点列表
        ///子弹生成的位置列表
        ///(偏移中心坐标x,偏移中心坐标y)单位像素
        /// </summary>
        public List<List<float>> FirePointList { get; set; }
        /// <summary>        
        /// 武器每个开火点单次发射数
        ///
        ///发射时，播放武器开火动画（无开火动画播放默认动画）
        /// </summary>
        public int EmissionNum { get; set; }
        /// <summary>        
        /// 武器冷却时间(帧数)
        ///
        ///冷却时，要播放冷却动画（无冷却动画播放默认动画）
        /// </summary>
        public int CoolTime { get; set; }
        /// <summary>        
        /// 初始偏移角度
        ///尽量与动画中炮塔方向一致
        ///正上方为0
        /// </summary>
        public float StartAngle { get; set; }
        /// <summary>        
        /// 武器转动速度
        ///1表示每秒转1度
        ///90表示每秒转90度（1/4圆）
        /// </summary>
        public float RotationSpeed { get; set; }
        /// <summary>        
        /// 当前散射半径
        ///指子弹射出时，偏移炮口方向的上下角度半径
        /// </summary>
        public float CurrScatteringRange { get; set; }

        public WeaponData2(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_WeaponData2, id);//public const string Config_WeaponData2 = "cfg_WeaponData2"; 
			ObjectId = (int)dict["ObjectId"];
			Range = (float)dict["Range"];
			LaunchTotal = (int)dict["LaunchTotal"];
			EmissionInterval = (int)dict["EmissionInterval"];
			FirePointList = (List<List<float>>)dict["FirePointList"];
			EmissionNum = (int)dict["EmissionNum"];
			CoolTime = (int)dict["CoolTime"];
			StartAngle = (float)dict["StartAngle"];
			RotationSpeed = (float)dict["RotationSpeed"];
			CurrScatteringRange = (float)dict["CurrScatteringRange"];
			InitData();
        }

        
        public WeaponData2(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_WeaponData2, cfg_id);//public const string Config_WeaponData2 = "cfg_WeaponData2"; 
			ObjectId = (int)dict["ObjectId"];
			Range = (float)dict["Range"];
			LaunchTotal = (int)dict["LaunchTotal"];
			EmissionInterval = (int)dict["EmissionInterval"];
			FirePointList = (List<List<float>>)dict["FirePointList"];
			EmissionNum = (int)dict["EmissionNum"];
			CoolTime = (int)dict["CoolTime"];
			StartAngle = (float)dict["StartAngle"];
			RotationSpeed = (float)dict["RotationSpeed"];
			CurrScatteringRange = (float)dict["CurrScatteringRange"];
			InitData();
        }

        public WeaponData2(Dictionary<string, object> dict)
        {
			ObjectId = (int)dict["ObjectId"];
			Range = (float)dict["Range"];
			LaunchTotal = (int)dict["LaunchTotal"];
			EmissionInterval = (int)dict["EmissionInterval"];
			FirePointList = (List<List<float>>)dict["FirePointList"];
			EmissionNum = (int)dict["EmissionNum"];
			CoolTime = (int)dict["CoolTime"];
			StartAngle = (float)dict["StartAngle"];
			RotationSpeed = (float)dict["RotationSpeed"];
			CurrScatteringRange = (float)dict["CurrScatteringRange"];
			InitData();
        }
        #endregion
    }
}
