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
        /// 刷新点id
        ///同步另一个表
        ///cfg_Wave_刷怪波数
        /// </summary>
        public int BrushId { get; set; }
        /// <summary>        
        /// 刷新点边缘是否显示
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
        /// 刷新点形状:
        ///1，表示矩形刷新 (Widht,Height)
        ///2，表示圆形刷新 (Radiu)
        ///
        /// </summary>
        public int ShapeType { get; set; }
        /// <summary>        
        /// 刷新点形状参数:
        /// (都是以一个地图块的长度为单位)
        ///
        /// </summary>
        public List<List<int>> ShapeParame { get; set; }

        public BrushPoint(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BrushPoint, id);//public const string Config_BrushPoint = "cfg_BrushPoint"; 
			BrushId = (int)dict["BrushId"];
			BrushShowType = (bool)dict["BrushShowType"];
			BrushPos = (Vector2I)dict["BrushPos"];
			WaveIdList = (List<int>)dict["WaveIdList"];
			ShapeType = (int)dict["ShapeType"];
			ShapeParame = (List<List<int>>)dict["ShapeParame"];
			InitData();
        }

        
        public BrushPoint(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BrushPoint, cfg_id);//public const string Config_BrushPoint = "cfg_BrushPoint"; 
			BrushId = (int)dict["BrushId"];
			BrushShowType = (bool)dict["BrushShowType"];
			BrushPos = (Vector2I)dict["BrushPos"];
			WaveIdList = (List<int>)dict["WaveIdList"];
			ShapeType = (int)dict["ShapeType"];
			ShapeParame = (List<List<int>>)dict["ShapeParame"];
			InitData();
        }

        public BrushPoint(Dictionary<string, object> dict)
        {
			BrushId = (int)dict["BrushId"];
			BrushShowType = (bool)dict["BrushShowType"];
			BrushPos = (Vector2I)dict["BrushPos"];
			WaveIdList = (List<int>)dict["WaveIdList"];
			ShapeType = (int)dict["ShapeType"];
			ShapeParame = (List<List<int>>)dict["ShapeParame"];
			InitData();
        }
        #endregion
    }
}
