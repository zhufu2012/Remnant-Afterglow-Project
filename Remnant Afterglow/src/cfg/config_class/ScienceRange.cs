using System.Collections.Generic;
using Godot;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 ScienceRange 用于 科技范围配置,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class ScienceRange
    {
        #region 参数及初始化
        /// <summary>        
        /// 科技范围id
        /// </summary>
        public int ScienceRangeId { get; set; }
        /// <summary>        
        /// 科技范围名称
        /// </summary>
        public string ScienceRangeName { get; set; }
        /// <summary>        
        /// 显示货币id列表
        ///按顺序显示
        ///cfg_MoneyBase_货币界面显示配置id
        /// </summary>
        public List<int> ShowMoneyList { get; set; }
        /// <summary>        
        /// 位置偏移量
        /// </summary>
        public Vector2I Offset { get; set; }
        /// <summary>        
        /// 节点间横纵向间隙
        /// </summary>
        public Vector2I Interval { get; set; }
        /// <summary>        
        /// 科技节点大小
        ///（横轴，纵轴）
        /// </summary>
        public Vector2I NodeSize { get; set; }
        /// <summary>        
        /// 科技范围描述
        /// </summary>
        public string ScienceRangeDes { get; set; }

        public ScienceRange(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_ScienceRange, id);//public const string Config_ScienceRange = "cfg_ScienceRange"; 
			ScienceRangeId = (int)dict["ScienceRangeId"];
			ScienceRangeName = (string)dict["ScienceRangeName"];
			ShowMoneyList = (List<int>)dict["ShowMoneyList"];
			Offset = (Vector2I)dict["Offset"];
			Interval = (Vector2I)dict["Interval"];
			NodeSize = (Vector2I)dict["NodeSize"];
			ScienceRangeDes = (string)dict["ScienceRangeDes"];
			InitData();
        }

        
        public ScienceRange(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_ScienceRange, cfg_id);//public const string Config_ScienceRange = "cfg_ScienceRange"; 
			ScienceRangeId = (int)dict["ScienceRangeId"];
			ScienceRangeName = (string)dict["ScienceRangeName"];
			ShowMoneyList = (List<int>)dict["ShowMoneyList"];
			Offset = (Vector2I)dict["Offset"];
			Interval = (Vector2I)dict["Interval"];
			NodeSize = (Vector2I)dict["NodeSize"];
			ScienceRangeDes = (string)dict["ScienceRangeDes"];
			InitData();
        }

        public ScienceRange(Dictionary<string, object> dict)
        {
			ScienceRangeId = (int)dict["ScienceRangeId"];
			ScienceRangeName = (string)dict["ScienceRangeName"];
			ShowMoneyList = (List<int>)dict["ShowMoneyList"];
			Offset = (Vector2I)dict["Offset"];
			Interval = (Vector2I)dict["Interval"];
			NodeSize = (Vector2I)dict["NodeSize"];
			ScienceRangeDes = (string)dict["ScienceRangeDes"];
			InitData();
        }
        #endregion
    }
}
