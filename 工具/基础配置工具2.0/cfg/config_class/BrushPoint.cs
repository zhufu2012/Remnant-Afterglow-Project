using System.Collections.Generic;
using Godot;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 BrushPoint 用于 刷怪点数据,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class BrushPoint
    {
        #region 参数及初始化
        /// <summary>
        /// 刷怪点id
        ///同步另一个表
        ///cfg_Wave_刷怪波数
        /// </summary>
        public int BrushId { get; set; }
        /// <summary>
        /// 刷怪点所在地图位置
        ///
        ///（左上角位置X,左上角位置Y）|（横轴，纵轴）
        /// </summary>
        public List<Vector2I> BrushPosList { get; set; }
        /// <summary>
        /// 最终目标，这个刷怪点刷出的单位都走向这个目标点
        /// </summary>
        public Vector2I TargetPos { get; set; }
        /// <summary>
        /// 刷怪波数id列表
        /// </summary>
        public List<int> WaveIdList { get; set; }

        public BrushPoint(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BrushPoint, id);//public const string Config_BrushPoint = "cfg_BrushPoint"; 
			BrushId = (int)dict["BrushId"];
			BrushPosList = (List<Vector2I>)dict["BrushPosList"];
			TargetPos = (Vector2I)dict["TargetPos"];
			WaveIdList = (List<int>)dict["WaveIdList"];
			InitData();
        }

        
        public BrushPoint(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BrushPoint, cfg_id);//public const string Config_BrushPoint = "cfg_BrushPoint"; 
			BrushId = (int)dict["BrushId"];
			BrushPosList = (List<Vector2I>)dict["BrushPosList"];
			TargetPos = (Vector2I)dict["TargetPos"];
			WaveIdList = (List<int>)dict["WaveIdList"];
			InitData();
        }

        public BrushPoint(Dictionary<string, object> dict)
        {
			BrushId = (int)dict["BrushId"];
			BrushPosList = (List<Vector2I>)dict["BrushPosList"];
			TargetPos = (Vector2I)dict["TargetPos"];
			WaveIdList = (List<int>)dict["WaveIdList"];
			InitData();
        }
        #endregion
    }
}
