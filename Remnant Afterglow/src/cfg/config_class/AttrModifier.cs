using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 AttrModifier 用于 属性修饰器,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class AttrModifier
    {
        #region 参数及初始化
        /// <summary>
        /// 属性修饰器id
        /// </summary>
        public int ModifierId { get; set; }
        /// <summary>
        /// 修饰器过期帧数
        ///表示该修饰器几帧后移除
        ///0表示不移除
        /// </summary>
        public ulong ExpiryTick { get; set; }
        /// <summary>
        /// 修饰参数列表,注意一个修饰器中，每种修饰值类型只能存在最多一个
        ///(修饰值类型1，加法值，乘法值)|(修饰值类型2，加法值，乘法值)
        ///修饰值类型有四种 
        ///1：当前值 2：最小值 3：最大值 4：再生值
        ///加分值：就是对应修饰值类型 增加的值
        ///乘法值：就是对应修饰值类型 乘以的值
        ///修饰后的属性 value = ((value+加法值)*乘法值)
        ///
        /// </summary>
        public List<List<float>> ParamList { get; set; }

        public AttrModifier(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_AttrModifier, id);//public const string Config_AttrModifier = "cfg_AttrModifier"; 
			ModifierId = (int)dict["ModifierId"];
			ExpiryTick = (ulong)dict["ExpiryTick"];
			ParamList = (List<List<float>>)dict["ParamList"];
			InitData();
        }

        
        public AttrModifier(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_AttrModifier, cfg_id);//public const string Config_AttrModifier = "cfg_AttrModifier"; 
			ModifierId = (int)dict["ModifierId"];
			ExpiryTick = (ulong)dict["ExpiryTick"];
			ParamList = (List<List<float>>)dict["ParamList"];
			InitData();
        }

        public AttrModifier(Dictionary<string, object> dict)
        {
			ModifierId = (int)dict["ModifierId"];
			ExpiryTick = (ulong)dict["ExpiryTick"];
			ParamList = (List<List<float>>)dict["ParamList"];
			InitData();
        }
        #endregion
    }
}
