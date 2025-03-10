using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 BulletLogic 用于 子弹逻辑数据表,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class BulletLogic
    {
        #region 参数及初始化
        /// <summary>        
        /// 子弹标签
        ///也是子弹脚本中子弹label的名称
        /// </summary>
        public string BulletLabel { get; set; }
        /// <summary>        
        /// 子弹名称
        /// </summary>
        public string BulletName { get; set; }
        /// <summary>        
        /// 对护盾伤害
        /// </summary>
        public int ShieldHarm { get; set; }
        /// <summary>        
        /// 对装甲伤害
        /// </summary>
        public int ArmourHarm { get; set; }
        /// <summary>        
        /// 对结构伤害
        ///
        /// </summary>
        public int StructureHarm { get; set; }
        /// <summary>        
        /// 穿透伤害
        ///直接对结构造成杀伤
        /// </summary>
        public int ElementHarm { get; set; }
        /// <summary>        
        /// 击中运行事件id列表
        /// </summary>
        public List<int> HitEvent { get; set; }
        /// <summary>        
        /// 子弹最大存在时间，
        ///单位：秒
        ///
        /// </summary>
        public float MaxLifeTime { get; set; }
        /// <summary>        
        /// 子弹最大飞行距离
        /// </summary>
        public float MaxDistance { get; set; }
        /// <summary>        
        /// 反弹次数
        /// </summary>
        public float BounceCount { get; set; }
        /// <summary>        
        /// 子弹穿透次数
        /// </summary>
        public float Penetration { get; set; }

        public BulletLogic(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BulletLogic, id);//public const string Config_BulletLogic = "cfg_BulletLogic"; 
			BulletLabel = (string)dict["BulletLabel"];
			BulletName = (string)dict["BulletName"];
			ShieldHarm = (int)dict["ShieldHarm"];
			ArmourHarm = (int)dict["ArmourHarm"];
			StructureHarm = (int)dict["StructureHarm"];
			ElementHarm = (int)dict["ElementHarm"];
			HitEvent = (List<int>)dict["HitEvent"];
			MaxLifeTime = (float)dict["MaxLifeTime"];
			MaxDistance = (float)dict["MaxDistance"];
			BounceCount = (float)dict["BounceCount"];
			Penetration = (float)dict["Penetration"];
			InitData();
        }

        
        public BulletLogic(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BulletLogic, cfg_id);//public const string Config_BulletLogic = "cfg_BulletLogic"; 
			BulletLabel = (string)dict["BulletLabel"];
			BulletName = (string)dict["BulletName"];
			ShieldHarm = (int)dict["ShieldHarm"];
			ArmourHarm = (int)dict["ArmourHarm"];
			StructureHarm = (int)dict["StructureHarm"];
			ElementHarm = (int)dict["ElementHarm"];
			HitEvent = (List<int>)dict["HitEvent"];
			MaxLifeTime = (float)dict["MaxLifeTime"];
			MaxDistance = (float)dict["MaxDistance"];
			BounceCount = (float)dict["BounceCount"];
			Penetration = (float)dict["Penetration"];
			InitData();
        }

        public BulletLogic(Dictionary<string, object> dict)
        {
			BulletLabel = (string)dict["BulletLabel"];
			BulletName = (string)dict["BulletName"];
			ShieldHarm = (int)dict["ShieldHarm"];
			ArmourHarm = (int)dict["ArmourHarm"];
			StructureHarm = (int)dict["StructureHarm"];
			ElementHarm = (int)dict["ElementHarm"];
			HitEvent = (List<int>)dict["HitEvent"];
			MaxLifeTime = (float)dict["MaxLifeTime"];
			MaxDistance = (float)dict["MaxDistance"];
			BounceCount = (float)dict["BounceCount"];
			Penetration = (float)dict["Penetration"];
			InitData();
        }
        #endregion
    }
}
