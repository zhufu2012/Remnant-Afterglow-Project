using Godot.Community.ManagedAttributes;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 事件触发类型
    /// 0 添加属性后直接触发
    /// 1 移除属性后触发
    /// 2 等于某值触发（参数1是触发值）
    /// 3 大于某值触发 （参数1是触发值）
    /// 4 小于某值触发 （参数1是触发值）
    /// 5 大于等于某值触发 （参数1是触发值）
    /// 6 小于等于某值触发 （参数1是触发值）
    /// 7 周期性达到触发 （参数1是周期（帧））
    /// 8 随机触发（参数1是触发值，参数2是最大随机值，随机数在1到参数2之间，小于触发值就触发）
    /// </summary>
    public enum AttrEventTouchType
    {
        StartRun = 0,
        RemoveRun = 1,
        EqualValue = 2,
        BiggerValue = 3,
        LessValue = 4,
        EqualOrBiggerValue = 5,
        EqualOrLessValue = 6,
        Cycle = 7,
        Rand = 8
    }
    /// <summary>
    /// 事件类型 
    /// #BASEVALUE 是 0
    /// 0 仅输出文字，调试用（输出事件id:触发时间戳:AttrEventDescribe字段）
    /// 1 修饰器事件 为属性增加修饰器（加属性或者改属性，可永久或者临时）
    /// 2 触发事件的事件 触发这个表的其他事件(可以用于延时触发其他事件，别写自己的id)
    /// 3 播放音效事件 播放音效
    /// 4 播放动画事件 播放动画
    /// 5 播放脚本动画
    /// </summary>
    public enum AttrEventType
    {
        LogEvent = 0,
        ModifierEvent = 1,
        Event = 2,
        Sound = 3,
        Animation = 4,
        ScriptAnimation = 5
    }

    public partial class AttributeEvent
    {
        #region 参数及初始化
        /// <summary>        
        /// 单位属性事件id
        /// </summary>
        public int AttrEventId { get; set; }
        /// <summary>        
        /// 单位属性事件描述
        /// </summary>
        public string AttrEventDescribe { get; set; }
        /// <summary>        
        /// 事件类型 #BASEVALUE 是 0
        ///0 仅输出文字，调试用（输出事件id:触发时间戳:AttrEventDescribe字段）
        ///1 修饰器事件 为属性增加修饰器（加属性或者改属性，可永久或者临时）
        ///参数1是 属性加值（不需要使用写0，正负都行）
        ///参数2是 属性乘值（不需要使用写 1，正负都行，大于1相当于乘以，小于1用于除以）
        ///2 触发事件的事件 触发这个表的其他事件(可以用于延时触发其他事件，别写自己的id)
        ///3 播放音效事件 播放音效
        ///4 播放动画事件 播放动画
        ///5 播放脚本动画
        /// </summary>
        public AttrEventType EventType { get; set; }

        /// <summary>        
        /// 延时时间
        ///事件类型为2  这是从当前时间开始的时长（帧数）
        ///
        /// </summary>
        public ulong DelayTime { get; set; }
        /// <summary>        
        /// 参数1
        /// </summary>
        public float Param1 { get; set; }
        /// <summary>        
        /// 参数2
        /// </summary>
        public float Param2 { get; set; }
        /// <summary>        
        /// 参数3
        /// </summary>
        public float Param3 { get; set; }
        /// <summary>        
        /// 参数列表
        ///事件类型为1时（参数1，参数2，参数3）
        ///参数1（0 当前值，1最小值，2最大值，3再生值）
        ///参数2是 属性加值（不需要使用写0，正负都行）
        ///参数3是 属性乘值（不需要使用写 1，正负都行，大于1相当于乘以，小于1用于除以）
        /// </summary>
        public List<List<float>> ParamList { get; set; }

        public AttributeEvent(int id)//祝福注释-这里可以优化为先保存到缓存中
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_AttrEvent, id);
            AttrEventId = (int)dict["AttrEventId"];
            AttrEventDescribe = (string)dict["AttrEventDescribe"];
            EventType = (AttrEventType)dict["EventType"];
            DelayTime = (ulong)dict["DelayTime"];
            Param1 = (float)dict["Param1"];
            Param2 = (float)dict["Param2"];
            Param3 = (float)dict["Param3"];
            ParamList = (List<List<float>>)dict["ParamList"];
        }

        public AttributeEvent(Dictionary<string, object> dict)//祝福注释-这里可以优化为先保存到缓存中
        {
            AttrEventId = (int)dict["AttrEventId"];
            AttrEventDescribe = (string)dict["AttrEventDescribe"];
            EventType = (AttrEventType)dict["EventType"];
            DelayTime = (ulong)dict["DelayTime"];
            Param1 = (float)dict["Param1"];
            Param2 = (float)dict["Param2"];
            Param3 = (float)dict["Param3"];
            ParamList = (List<List<float>>)dict["ParamList"];
        }

        public void RunEvent(int event_id, FloatManagedAttribute attr)
        {

        }
        #endregion
    }
}