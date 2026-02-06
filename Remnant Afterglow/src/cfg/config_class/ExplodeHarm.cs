using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 ExplodeHarm 用于 爆炸伤害数据,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class ExplodeHarm
    {
        #region 参数及初始化
        /// <summary>
        /// 爆炸id
        /// </summary>
        public int ExplodeId { get; set; }
        /// <summary>
        /// 造成的伤害
        /// </summary>
        public int Harm { get; set; }
        /// <summary>
        /// 伤害半径
        /// </summary>
        public int HitRadius { get; set; }
        /// <summary>
        /// 击退半径
        /// </summary>
        public float RepelledRadius { get; set; }
        /// <summary>
        /// 最大击退速度
        /// </summary>
        public float MaxRepelled { get; set; }

        public ExplodeHarm(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_ExplodeHarm, id);//public const string Config_ExplodeHarm = "cfg_ExplodeHarm"; 
			ExplodeId = (int)dict["ExplodeId"];
			Harm = (int)dict["Harm"];
			HitRadius = (int)dict["HitRadius"];
			RepelledRadius = (float)dict["RepelledRadius"];
			MaxRepelled = (float)dict["MaxRepelled"];
			InitData();
        }

        
        public ExplodeHarm(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_ExplodeHarm, cfg_id);//public const string Config_ExplodeHarm = "cfg_ExplodeHarm"; 
			ExplodeId = (int)dict["ExplodeId"];
			Harm = (int)dict["Harm"];
			HitRadius = (int)dict["HitRadius"];
			RepelledRadius = (float)dict["RepelledRadius"];
			MaxRepelled = (float)dict["MaxRepelled"];
			InitData();
        }

        public ExplodeHarm(Dictionary<string, object> dict)
        {
			ExplodeId = (int)dict["ExplodeId"];
			Harm = (int)dict["Harm"];
			HitRadius = (int)dict["HitRadius"];
			RepelledRadius = (float)dict["RepelledRadius"];
			MaxRepelled = (float)dict["MaxRepelled"];
			InitData();
        }
        #endregion
    }
}
