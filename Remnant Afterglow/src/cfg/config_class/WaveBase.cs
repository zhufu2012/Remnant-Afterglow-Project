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
        /// 刷新单位组
        ///(单位组id1,刷新次数1)|(单位组id2,刷新次数2)
        /// </summary>
        public List<List<int>> WaveUnitGroup { get; set; }

        public WaveBase(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_WaveBase, id);//public const string Config_WaveBase = "cfg_WaveBase"; 
			BrushId = (int)dict["BrushId"];
			WaveId = (int)dict["WaveId"];
			WaveName = (string)dict["WaveName"];
			WaveUnitGroup = (List<List<int>>)dict["WaveUnitGroup"];
			InitData();
        }

        
        public WaveBase(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_WaveBase, cfg_id);//public const string Config_WaveBase = "cfg_WaveBase"; 
			BrushId = (int)dict["BrushId"];
			WaveId = (int)dict["WaveId"];
			WaveName = (string)dict["WaveName"];
			WaveUnitGroup = (List<List<int>>)dict["WaveUnitGroup"];
			InitData();
        }

        public WaveBase(Dictionary<string, object> dict)
        {
			BrushId = (int)dict["BrushId"];
			WaveId = (int)dict["WaveId"];
			WaveName = (string)dict["WaveName"];
			WaveUnitGroup = (List<List<int>>)dict["WaveUnitGroup"];
			InitData();
        }
        #endregion
    }
}
