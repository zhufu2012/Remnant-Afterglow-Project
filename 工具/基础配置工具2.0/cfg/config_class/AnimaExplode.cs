using System.Collections.Generic;
using Godot;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 AnimaExplode 用于 爆炸动画,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class AnimaExplode
    {
        #region 参数及初始化
        /// <summary>        
        /// 爆炸id
        ///
        /// </summary>
        public int ExplodeId { get; set; }
        /// <summary>        
        /// 帧动画类型
        /// </summary>
        public int AnimaType { get; set; }
        /// <summary>        
        /// 帧图坐标
        /// </summary>
        public Vector2I Coords { get; set; }
        /// <summary>        
        /// 单个帧图
        ///长宽（横纵）
        /// </summary>
        public Vector2I LengWidth { get; set; }
        /// <summary>        
        /// 帧图最大序号
        ///第一张图是1
        /// </summary>
        public int MaxIndex { get; set; }
        /// <summary>        
        /// 帧图大小
        ///（横,纵）
        /// </summary>
        public Vector2I Size { get; set; }
        /// <summary>        
        /// 持续时间,
        ///单位毫秒
        /// </summary>
        public int DurationMs { get; set; }
        /// <summary>        
        /// 帧数
        /// </summary>
        public int FrameCount { get; set; }
        /// <summary>        
        /// 是否自动播放
        /// </summary>
        public bool IsAutoplay { get; set; }
        /// <summary>        
        /// 是否循环播放
        /// </summary>
        public bool IsLoop { get; set; }
        /// <summary>        
        /// 帧图
        /// </summary>
        public Texture2D Picture { get; set; }

        public AnimaExplode(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_AnimaExplode, id);//public const string Config_AnimaExplode = "cfg_AnimaExplode"; 
			ExplodeId = (int)dict["ExplodeId"];
			AnimaType = (int)dict["AnimaType"];
			Coords = (Vector2I)dict["Coords"];
			LengWidth = (Vector2I)dict["LengWidth"];
			MaxIndex = (int)dict["MaxIndex"];
			Size = (Vector2I)dict["Size"];
			DurationMs = (int)dict["DurationMs"];
			FrameCount = (int)dict["FrameCount"];
			IsAutoplay = (bool)dict["IsAutoplay"];
			IsLoop = (bool)dict["IsLoop"];
			Picture = (Texture2D)dict["Picture"];
			InitData();
        }

        
        public AnimaExplode(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_AnimaExplode, cfg_id);//public const string Config_AnimaExplode = "cfg_AnimaExplode"; 
			ExplodeId = (int)dict["ExplodeId"];
			AnimaType = (int)dict["AnimaType"];
			Coords = (Vector2I)dict["Coords"];
			LengWidth = (Vector2I)dict["LengWidth"];
			MaxIndex = (int)dict["MaxIndex"];
			Size = (Vector2I)dict["Size"];
			DurationMs = (int)dict["DurationMs"];
			FrameCount = (int)dict["FrameCount"];
			IsAutoplay = (bool)dict["IsAutoplay"];
			IsLoop = (bool)dict["IsLoop"];
			Picture = (Texture2D)dict["Picture"];
			InitData();
        }

        public AnimaExplode(Dictionary<string, object> dict)
        {
			ExplodeId = (int)dict["ExplodeId"];
			AnimaType = (int)dict["AnimaType"];
			Coords = (Vector2I)dict["Coords"];
			LengWidth = (Vector2I)dict["LengWidth"];
			MaxIndex = (int)dict["MaxIndex"];
			Size = (Vector2I)dict["Size"];
			DurationMs = (int)dict["DurationMs"];
			FrameCount = (int)dict["FrameCount"];
			IsAutoplay = (bool)dict["IsAutoplay"];
			IsLoop = (bool)dict["IsLoop"];
			Picture = (Texture2D)dict["Picture"];
			InitData();
        }
        #endregion
    }
}
