using System.Collections.Generic;
Vector2Vector2Inamespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 BrushPoint 用于 刷怪点数据,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class BrushPoint
    {
        #region 参数及初始化
        /// <summary>
        /// 刷新点id
        ///同步另一个表
        ///cfg_Wave_刷怪波数
        /// </summary>
        public int BrushId { get; set; }
        /// <summary>
        /// 刷新点是否显示
        /// </summary>
        public bool BrushShowType { get; set; }
        /// <summary>
        /// 刷新点坐标
        ///（坐标x,坐标y）
        /// </summary>
        public Vector2I BrushPos { get; set; }
        /// <summary>
        /// 刷新波数id列表
        /// </summary>
        public List<int> WaveIdList { get; set; }
        /// <summary>
        /// 刷新点使用选择，
        ///0，表示全图随机刷新
        ///1，表示在一个点刷新，读取Polygon第一个坐标
        ///2，表示多边形刷新
        ///读取Polygon所有坐标相连
        ///（至少一个点）
        ///3，表示圆形刷新
        ///
        /// </summary>
        public int ShapeSelect { get; set; }
        /// <summary>
        /// 刷新点 坐标列表(块坐标)
        ///该点坐标
        ///是相对于刷新点的坐标
        ///多个坐标点首尾相连成为一个多边形
        /// </summary>
        public List<Vector2I> Polygon { get; set; }
        /// <summary>
        /// 刷新半径，以刷新点
        ///为圆心的半径内
        /// </summary>
        public float Radius { get; set; }

        public BrushPoint(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BrushPoint, id);//public const string Config_BrushPoint = "cfg_BrushPoint"; 
			BrushId = (int)dict["BrushId"];
			BrushShowType = (bool)dict["BrushShowType"];
			BrushPos = (Vector2I)dict["BrushPos"];
			WaveIdList = (List<int>)dict["WaveIdList"];
			ShapeSelect = (int)dict["ShapeSelect"];
			Polygon = (List<Vector2I>)dict["Polygon"];
			Radius = (float)dict["Radius"];
			InitData();
        }

        
        public BrushPoint(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BrushPoint, cfg_id);//public const string Config_BrushPoint = "cfg_BrushPoint"; 
			BrushId = (int)dict["BrushId"];
			BrushShowType = (bool)dict["BrushShowType"];
			BrushPos = (Vector2I)dict["BrushPos"];
			WaveIdList = (List<int>)dict["WaveIdList"];
			ShapeSelect = (int)dict["ShapeSelect"];
			Polygon = (List<Vector2I>)dict["Polygon"];
			Radius = (float)dict["Radius"];
			InitData();
        }

        public BrushPoint(Dictionary<string, object> dict)
        {
			BrushId = (int)dict["BrushId"];
			BrushShowType = (bool)dict["BrushShowType"];
			BrushPos = (Vector2I)dict["BrushPos"];
			WaveIdList = (List<int>)dict["WaveIdList"];
			ShapeSelect = (int)dict["ShapeSelect"];
			Polygon = (List<Vector2I>)dict["Polygon"];
			Radius = (float)dict["Radius"];
			InitData();
        }
        #endregion
    }
}
