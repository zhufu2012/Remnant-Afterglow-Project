using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 BigMapEvent 用于 大地图节点事件,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class BigMapEvent
    {
        #region 参数及初始化
        /// <summary>
        /// 大地图节点事件id
        /// </summary>
        public int EventId { get; set; }
        /// <summary>
        /// 事件类型
        ///0 输出点击节点消息
        ///1 进入对应地图 参数1是地图生成id
        /// </summary>
        public int EventType { get; set; }
        /// <summary>
        /// 事件参数
        /// </summary>
        public float EventParam1 { get; set; }
        /// <summary>
        /// 事件参数
        /// </summary>
        public float EventParam2 { get; set; }
        /// <summary>
        /// 事件参数列表
        /// </summary>
        public List<List<float>> EventParamList { get; set; }

        public BigMapEvent(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BigMapEvent, id);//public const string Config_BigMapEvent = "cfg_BigMapEvent"; 
			EventId = (int)dict["EventId"];
			EventType = (int)dict["EventType"];
			EventParam1 = (float)dict["EventParam1"];
			EventParam2 = (float)dict["EventParam2"];
			EventParamList = (List<List<float>>)dict["EventParamList"];
			InitData();
        }

        
        public BigMapEvent(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BigMapEvent, cfg_id);//public const string Config_BigMapEvent = "cfg_BigMapEvent"; 
			EventId = (int)dict["EventId"];
			EventType = (int)dict["EventType"];
			EventParam1 = (float)dict["EventParam1"];
			EventParam2 = (float)dict["EventParam2"];
			EventParamList = (List<List<float>>)dict["EventParamList"];
			InitData();
        }

        public BigMapEvent(Dictionary<string, object> dict)
        {
			EventId = (int)dict["EventId"];
			EventType = (int)dict["EventType"];
			EventParam1 = (float)dict["EventParam1"];
			EventParam2 = (float)dict["EventParam2"];
			EventParamList = (List<List<float>>)dict["EventParamList"];
			InitData();
        }
        #endregion
    }
}
