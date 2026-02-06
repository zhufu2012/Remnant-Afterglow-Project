using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 BuffData 用于 buff基础数据,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class BuffData
    {
        #region 参数及初始化
        /// <summary>
        /// BuffId
        /// </summary>
        public int BuffId { get; set; }
        /// <summary>
        /// Buff名称
        /// </summary>
        public string BuffName { get; set; }
        /// <summary>
        /// Buff描述
        /// </summary>
        public string BuffDesc { get; set; }
        /// <summary>
        /// Buff类型
        ///
        ///
        ///
        ///100 属性修饰器buff
        ///
        /// </summary>
        public int BuffType { get; set; }
        /// <summary>
        /// Buff添加类型
        ///1 重置buff时间
        ///2 增加Buff层数
        ///3 增加Buff层数且重置Buff时间
        /// </summary>
        public int BuffMutilAddType { get; set; }
        /// <summary>
        /// Buff标签id列表
        ///cfg_BuffTag_buff标签数据id
        ///
        /// </summary>
        public HashSet<int> BuffTagIdList { get; set; }
        /// <summary>
        /// 是否为永久Buff
        /// </summary>
        public bool IsPermanent { get; set; }
        /// <summary>
        /// Buff持续时间
        ///帧数
        /// </summary>
        public int Duration { get; set; }
        /// <summary>
        /// Buff持续时间结束后是否清除全部层数？
        ///仅清除一层且Buff还有剩余层数，则Buff持续时间重置
        ///否则清除全部层数，并且移除Buff
        /// </summary>
        public bool IsRemoveAllLayer { get; set; }
        /// <summary>
        /// 是否开启了buff周期计时
        /// </summary>
        public bool RunTickTimer { get; set; }
        /// <summary>
        /// buff生效周期（帧）
        ///
        ///
        /// </summary>
        public int TickInterval { get; set; }
        /// <summary>
        /// buff最大层数
        /// </summary>
        public int MaxLayer { get; set; }
        /// <summary>
        /// Buff添加事件id列表
        ///添加buff后直接运行的事件
        /// </summary>
        public List<int> StartEventIdList { get; set; }
        /// <summary>
        /// buff生效额外触发事件id列表
        ///(生效类型,触发条件类型,参数1，参数2，参数3，触发事件id1,触发事件id2,触发事件id3...可以不断加,按顺序运行)
        ///生效类型:0 buff拥有者-实体  1 buff来源-来源
        ///触发条件类型:
        ///1.普通触发，无参数，直接触发事件
        ///
        ///举例:(0,1,0,0,0,1,2,3,4,5)
        ///意思是：buff生效时，直接触发事件 1，2，3，4，5 按顺序运行，事件在buff拥有者身上触发
        /// </summary>
        public List<List<int>> EventIdList { get; set; }
        /// <summary>
        /// 参数1
        /// </summary>
        public int Param1 { get; set; }
        /// <summary>
        /// 参数2
        /// </summary>
        public int Param2 { get; set; }
        /// <summary>
        /// 参数3
        /// </summary>
        public int Param3 { get; set; }

        public BuffData(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BuffData, id);//public const string Config_BuffData = "cfg_BuffData"; 
			BuffId = (int)dict["BuffId"];
			BuffName = (string)dict["BuffName"];
			BuffDesc = (string)dict["BuffDesc"];
			BuffType = (int)dict["BuffType"];
			BuffMutilAddType = (int)dict["BuffMutilAddType"];
			BuffTagIdList = (HashSet<int>)dict["BuffTagIdList"];
			IsPermanent = (bool)dict["IsPermanent"];
			Duration = (int)dict["Duration"];
			IsRemoveAllLayer = (bool)dict["IsRemoveAllLayer"];
			RunTickTimer = (bool)dict["RunTickTimer"];
			TickInterval = (int)dict["TickInterval"];
			MaxLayer = (int)dict["MaxLayer"];
			StartEventIdList = (List<int>)dict["StartEventIdList"];
			EventIdList = (List<List<int>>)dict["EventIdList"];
			Param1 = (int)dict["Param1"];
			Param2 = (int)dict["Param2"];
			Param3 = (int)dict["Param3"];
			InitData();
        }

        
        public BuffData(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BuffData, cfg_id);//public const string Config_BuffData = "cfg_BuffData"; 
			BuffId = (int)dict["BuffId"];
			BuffName = (string)dict["BuffName"];
			BuffDesc = (string)dict["BuffDesc"];
			BuffType = (int)dict["BuffType"];
			BuffMutilAddType = (int)dict["BuffMutilAddType"];
			BuffTagIdList = (HashSet<int>)dict["BuffTagIdList"];
			IsPermanent = (bool)dict["IsPermanent"];
			Duration = (int)dict["Duration"];
			IsRemoveAllLayer = (bool)dict["IsRemoveAllLayer"];
			RunTickTimer = (bool)dict["RunTickTimer"];
			TickInterval = (int)dict["TickInterval"];
			MaxLayer = (int)dict["MaxLayer"];
			StartEventIdList = (List<int>)dict["StartEventIdList"];
			EventIdList = (List<List<int>>)dict["EventIdList"];
			Param1 = (int)dict["Param1"];
			Param2 = (int)dict["Param2"];
			Param3 = (int)dict["Param3"];
			InitData();
        }

        public BuffData(Dictionary<string, object> dict)
        {
			BuffId = (int)dict["BuffId"];
			BuffName = (string)dict["BuffName"];
			BuffDesc = (string)dict["BuffDesc"];
			BuffType = (int)dict["BuffType"];
			BuffMutilAddType = (int)dict["BuffMutilAddType"];
			BuffTagIdList = (HashSet<int>)dict["BuffTagIdList"];
			IsPermanent = (bool)dict["IsPermanent"];
			Duration = (int)dict["Duration"];
			IsRemoveAllLayer = (bool)dict["IsRemoveAllLayer"];
			RunTickTimer = (bool)dict["RunTickTimer"];
			TickInterval = (int)dict["TickInterval"];
			MaxLayer = (int)dict["MaxLayer"];
			StartEventIdList = (List<int>)dict["StartEventIdList"];
			EventIdList = (List<List<int>>)dict["EventIdList"];
			Param1 = (int)dict["Param1"];
			Param2 = (int)dict["Param2"];
			Param3 = (int)dict["Param3"];
			InitData();
        }
        #endregion
    }
}
