using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 WeaponBase 用于 武器数据,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class WeaponBase
    {
        #region 参数及初始化
        /// <summary>        
        /// 武器id
        /// </summary>
        public int WeaponId { get; set; }
        /// <summary>        
        /// 武器类型
        ///1 射弹类型
        ///2 激光类型
        /// </summary>
        public int Type { get; set; }
        /// <summary>        
        /// 武器射程
        ///单位（1/20格）
        /// </summary>
        public float Range { get; set; }
        /// <summary>        
        /// 武器单次发射总量
        /// </summary>
        public int LaunchTotal { get; set; }
        /// <summary>        
        /// 武器单次发射内间隔(帧数)
        ///0 表示无间隔，一次性射出
        ///1 表示每1帧射出单次发射数个，直到发射完就开始冷却
        ///并且播放冷却动画（无冷却动画播放默认动画）
        /// </summary>
        public int EmissionInterval { get; set; }
        /// <summary>        
        /// 武器单次发射数
        /// </summary>
        public int EmissionNum { get; set; }
        /// <summary>        
        /// 武器冷却时间
        ///(帧数)
        /// </summary>
        public int CoolTime { get; set; }
        /// <summary>        
        /// 武器的开火点列表
        ///子弹生成的位置列表
        ///(坐标x,坐标y)单位像素
        /// </summary>
        public List<List<float>> FirePointList { get; set; }
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
        /// </summary>
        public float CurrScatteringRange { get; set; }

        public WeaponBase(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_WeaponBase, id);//public const string Config_WeaponBase = "cfg_WeaponBase"; 
			WeaponId = (int)dict["WeaponId"];
			Type = (int)dict["Type"];
			Range = (float)dict["Range"];
			LaunchTotal = (int)dict["LaunchTotal"];
			EmissionInterval = (int)dict["EmissionInterval"];
			EmissionNum = (int)dict["EmissionNum"];
			CoolTime = (int)dict["CoolTime"];
			FirePointList = (List<List<float>>)dict["FirePointList"];
			StartAngle = (float)dict["StartAngle"];
			RotationSpeed = (float)dict["RotationSpeed"];
			CurrScatteringRange = (float)dict["CurrScatteringRange"];
			InitData();
        }

        
        public WeaponBase(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_WeaponBase, cfg_id);//public const string Config_WeaponBase = "cfg_WeaponBase"; 
			WeaponId = (int)dict["WeaponId"];
			Type = (int)dict["Type"];
			Range = (float)dict["Range"];
			LaunchTotal = (int)dict["LaunchTotal"];
			EmissionInterval = (int)dict["EmissionInterval"];
			EmissionNum = (int)dict["EmissionNum"];
			CoolTime = (int)dict["CoolTime"];
			FirePointList = (List<List<float>>)dict["FirePointList"];
			StartAngle = (float)dict["StartAngle"];
			RotationSpeed = (float)dict["RotationSpeed"];
			CurrScatteringRange = (float)dict["CurrScatteringRange"];
			InitData();
        }

        public WeaponBase(Dictionary<string, object> dict)
        {
			WeaponId = (int)dict["WeaponId"];
			Type = (int)dict["Type"];
			Range = (float)dict["Range"];
			LaunchTotal = (int)dict["LaunchTotal"];
			EmissionInterval = (int)dict["EmissionInterval"];
			EmissionNum = (int)dict["EmissionNum"];
			CoolTime = (int)dict["CoolTime"];
			FirePointList = (List<List<float>>)dict["FirePointList"];
			StartAngle = (float)dict["StartAngle"];
			RotationSpeed = (float)dict["RotationSpeed"];
			CurrScatteringRange = (float)dict["CurrScatteringRange"];
			InitData();
        }
        #endregion
    }
}
