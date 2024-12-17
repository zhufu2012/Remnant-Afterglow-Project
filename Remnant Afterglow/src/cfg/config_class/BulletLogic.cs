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
        /// 子弹属性伤害
        /// </summary>
        public List<List<float>> AttrHarm { get; set; }
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
        /// 反弹次数区间
        /// </summary>
        public float BounceCount { get; set; }
        /// <summary>        
        /// 子弹穿透次数区间
        /// </summary>
        public float Penetration { get; set; }

        public BulletLogic(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BulletLogic, id);//public const string Config_BulletLogic = "cfg_BulletLogic"; 
			BulletLabel = (string)dict["BulletLabel"];
			BulletName = (string)dict["BulletName"];
			AttrHarm = (List<List<float>>)dict["AttrHarm"];
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
			AttrHarm = (List<List<float>>)dict["AttrHarm"];
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
			AttrHarm = (List<List<float>>)dict["AttrHarm"];
			MaxLifeTime = (float)dict["MaxLifeTime"];
			MaxDistance = (float)dict["MaxDistance"];
			BounceCount = (float)dict["BounceCount"];
			Penetration = (float)dict["Penetration"];
			InitData();
        }
        #endregion
    }
}
