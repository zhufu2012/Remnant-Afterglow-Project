using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 Buff 用于 ,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class Buff
    {
        #region 参数及初始化
        /// <summary>
        /// 主键字段
        /// </summary>
        public int KetId { get; set; }
        /// <summary>
        /// buff名称
        /// </summary>
        public string buffName { get; set; }
        /// <summary>
        /// buff介绍
        /// </summary>
        public string buff111 { get; set; }
        /// <summary>
        /// 效果生效值
        /// </summary>
        public int EffectValue { get; set; }
        /// <summary>
        /// 效果随时间降低值（秒）
        /// </summary>
        public int ReduceValue { get; set; }

        public Buff(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_Buff, id);//public const string Config_Buff = "cfg_buff"; 
			KetId = (int)dict["KetId"];
			buffName = (string)dict["buffName"];
			buff111 = (string)dict["buff111"];
			EffectValue = (int)dict["EffectValue"];
			ReduceValue = (int)dict["ReduceValue"];
			InitData();
        }

        
        public Buff(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_Buff, cfg_id);//public const string Config_Buff = "cfg_buff"; 
			KetId = (int)dict["KetId"];
			buffName = (string)dict["buffName"];
			buff111 = (string)dict["buff111"];
			EffectValue = (int)dict["EffectValue"];
			ReduceValue = (int)dict["ReduceValue"];
			InitData();
        }

        public Buff(Dictionary<string, object> dict)
        {
			KetId = (int)dict["KetId"];
			buffName = (string)dict["buffName"];
			buff111 = (string)dict["buff111"];
			EffectValue = (int)dict["EffectValue"];
			ReduceValue = (int)dict["ReduceValue"];
			InitData();
        }
        #endregion
    }
}
