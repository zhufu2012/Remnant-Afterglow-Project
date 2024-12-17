using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 WaveBase 用于 波数配置,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class WaveBase
    {
        #region 参数及初始化
        /// <summary>        
        /// 刷怪点id
        /// </summary>
        public int BrushId { get; set; }
        /// <summary>        
        /// 波次Id
        ///（波数从1开始，一直
        ///到各刷新点中存在的
        ///最大波数为止）
        /// </summary>
        public int WaveId { get; set; }
        /// <summary>        
        /// 波次名称
        /// </summary>
        public string WaveName { get; set; }
        /// <summary>        
        /// 刷新类型
        ///0 不刷新怪
        ///1 固定方式 使用WaveData
        ///2 随机刷新 使用WaveRandData
        /// </summary>
        public int WaveType { get; set; }
        /// <summary>        
        /// 刷新方式
        ///0 触发刷新，点击开始才刷新
        ///1.直接全部刷新
        ///2.定时刷新间隔
        /// </summary>
        public int WaveWay { get; set; }
        /// <summary>        
        /// 刷新提示
        /// </summary>
        public string WaveDes { get; set; }
        /// <summary>        
        /// 刷新数据列表
        ///(组序号,cfg_UnitBase的单位id，阵营id，数量)
        ///刷新方式为1，就是直接全部刷新
        ///刷新方式为2，就是从组序号1开始刷新
        ///每隔WaveTime帧刷新下一组
        ///
        ///注意！刷新数据列表1 和刷新数据列表2的组序号可以重复
        /// </summary>
        public List<List<int>> WaveData { get; set; }
        /// <summary>        
        /// 波数随机刷新数据列表
        ///()
        /// </summary>
        public List<List<int>> WaveRandData { get; set; }
        /// <summary>        
        /// 
        ///一个组一个组
        ///定时刷新间隔时间
        ///单位帧
        /// </summary>
        public int WaveTime { get; set; }

        public WaveBase(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_WaveBase, id);//public const string Config_WaveBase = "cfg_WaveBase"; 
			BrushId = (int)dict["BrushId"];
			WaveId = (int)dict["WaveId"];
			WaveName = (string)dict["WaveName"];
			WaveType = (int)dict["WaveType"];
			WaveWay = (int)dict["WaveWay"];
			WaveDes = (string)dict["WaveDes"];
			WaveData = (List<List<int>>)dict["WaveData"];
			WaveRandData = (List<List<int>>)dict["WaveRandData"];
			WaveTime = (int)dict["WaveTime"];
			InitData();
        }

        
        public WaveBase(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_WaveBase, cfg_id);//public const string Config_WaveBase = "cfg_WaveBase"; 
			BrushId = (int)dict["BrushId"];
			WaveId = (int)dict["WaveId"];
			WaveName = (string)dict["WaveName"];
			WaveType = (int)dict["WaveType"];
			WaveWay = (int)dict["WaveWay"];
			WaveDes = (string)dict["WaveDes"];
			WaveData = (List<List<int>>)dict["WaveData"];
			WaveRandData = (List<List<int>>)dict["WaveRandData"];
			WaveTime = (int)dict["WaveTime"];
			InitData();
        }

        public WaveBase(Dictionary<string, object> dict)
        {
			BrushId = (int)dict["BrushId"];
			WaveId = (int)dict["WaveId"];
			WaveName = (string)dict["WaveName"];
			WaveType = (int)dict["WaveType"];
			WaveWay = (int)dict["WaveWay"];
			WaveDes = (string)dict["WaveDes"];
			WaveData = (List<List<int>>)dict["WaveData"];
			WaveRandData = (List<List<int>>)dict["WaveRandData"];
			WaveTime = (int)dict["WaveTime"];
			InitData();
        }
        #endregion
    }
}
