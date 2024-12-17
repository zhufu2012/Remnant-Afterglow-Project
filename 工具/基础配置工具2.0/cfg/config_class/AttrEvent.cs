using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 AttrEvent 用于 属性事件,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class AttrEvent
    {
        #region 参数及初始化
        /// <summary>        
        /// 事件id
        /// </summary>
        public int AttrEventId { get; set; }
        /// <summary>        
        /// 事件描述
        /// </summary>
        public string AttrEventDescribe { get; set; }
        /// <summary>        
        /// 事件类型 #BASEVALUE 是 0
        ///0 仅输出文字，调试用（输出事件id:触发时间戳:AttrEventDescribe字段）
        ///1 用于添加对应属性的事件：
        ///    参数1为cfg_AttributeData_实体属性表ObjectId
        ///    参数2为cfg_AttributeData_实体属性表AttributeId 
        ///2 用于添加对应修饰器的事件：
        ///
        ///3 触发其他事件 
        ///10 播放音效事件 播放音效
        ///11 播放动画事件 播放动画
        ///12 播放脚本动画
        /// </summary>
        public int EventType { get; set; }
        /// <summary>        
        /// 延时触发自身事件(单位:帧)
        ///0 表示即刻触发
        ///1及以上表示延时x帧触发
        /// </summary>
        public int Delay { get; set; }
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
        /// <summary>        
        /// 参数列表
        /// </summary>
        public List<List<float>> ParamList { get; set; }

        public AttrEvent(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_AttrEvent, id);//public const string Config_AttrEvent = "cfg_AttrEvent"; 
			AttrEventId = (int)dict["AttrEventId"];
			AttrEventDescribe = (string)dict["AttrEventDescribe"];
			EventType = (int)dict["EventType"];
			Delay = (int)dict["Delay"];
			Param1 = (int)dict["Param1"];
			Param2 = (int)dict["Param2"];
			Param3 = (int)dict["Param3"];
			ParamList = (List<List<float>>)dict["ParamList"];
			InitData();
        }

        
        public AttrEvent(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_AttrEvent, cfg_id);//public const string Config_AttrEvent = "cfg_AttrEvent"; 
			AttrEventId = (int)dict["AttrEventId"];
			AttrEventDescribe = (string)dict["AttrEventDescribe"];
			EventType = (int)dict["EventType"];
			Delay = (int)dict["Delay"];
			Param1 = (int)dict["Param1"];
			Param2 = (int)dict["Param2"];
			Param3 = (int)dict["Param3"];
			ParamList = (List<List<float>>)dict["ParamList"];
			InitData();
        }

        public AttrEvent(Dictionary<string, object> dict)
        {
			AttrEventId = (int)dict["AttrEventId"];
			AttrEventDescribe = (string)dict["AttrEventDescribe"];
			EventType = (int)dict["EventType"];
			Delay = (int)dict["Delay"];
			Param1 = (int)dict["Param1"];
			Param2 = (int)dict["Param2"];
			Param3 = (int)dict["Param3"];
			ParamList = (List<List<float>>)dict["ParamList"];
			InitData();
        }
        #endregion
    }
}
