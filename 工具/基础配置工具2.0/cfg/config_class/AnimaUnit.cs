using System.Collections.Generic;
using Godot;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 AnimaUnit 用于 单位帧动画配置,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class AnimaUnit
    {
        #region 参数及初始化
        /// <summary>        
        /// 实体id
        ///单位
        /// </summary>
        public int ObjectId { get; set; }
        /// <summary>        
        /// 帧动画类型
        ///1 默认动画
        ///2 移动动画
        ///3 攻击动画
        ///10 死亡动画
        ///播放时发现没有该动画就播放默认动画
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
        /// 
        /// </summary>
        public Vector2 Offset { get; set; }
        /// <summary>        
        /// 
        /// </summary>
        public List<List<int>> RelativeList { get; set; }
        /// <summary>        
        /// 
        /// </summary>
        public int SpeedScale { get; set; }
        /// <summary>        
        /// 是否自动播放
        ///一个实体的动画只能有最多一个自动播放
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
        /// <summary>        
        /// 
        /// </summary>
        public bool FlipH { get; set; }
        /// <summary>        
        /// 
        /// </summary>
        public bool FlipV { get; set; }

        public AnimaUnit(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_AnimaUnit, id);//public const string Config_AnimaUnit = "cfg_AnimaUnit"; 
			ObjectId = (int)dict["ObjectId"];
			AnimaType = (int)dict["AnimaType"];
			Coords = (Vector2I)dict["Coords"];
			LengWidth = (Vector2I)dict["LengWidth"];
			MaxIndex = (int)dict["MaxIndex"];
			Size = (Vector2I)dict["Size"];
			Offset = (Vector2)dict["Offset"];
			RelativeList = (List<List<int>>)dict["RelativeList"];
			SpeedScale = (int)dict["SpeedScale"];
			IsAutoplay = (bool)dict["IsAutoplay"];
			IsLoop = (bool)dict["IsLoop"];
			Picture = (Texture2D)dict["Picture"];
			FlipH = (bool)dict["FlipH"];
			FlipV = (bool)dict["FlipV"];
			InitData();
        }

        
        public AnimaUnit(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_AnimaUnit, cfg_id);//public const string Config_AnimaUnit = "cfg_AnimaUnit"; 
			ObjectId = (int)dict["ObjectId"];
			AnimaType = (int)dict["AnimaType"];
			Coords = (Vector2I)dict["Coords"];
			LengWidth = (Vector2I)dict["LengWidth"];
			MaxIndex = (int)dict["MaxIndex"];
			Size = (Vector2I)dict["Size"];
			Offset = (Vector2)dict["Offset"];
			RelativeList = (List<List<int>>)dict["RelativeList"];
			SpeedScale = (int)dict["SpeedScale"];
			IsAutoplay = (bool)dict["IsAutoplay"];
			IsLoop = (bool)dict["IsLoop"];
			Picture = (Texture2D)dict["Picture"];
			FlipH = (bool)dict["FlipH"];
			FlipV = (bool)dict["FlipV"];
			InitData();
        }

        public AnimaUnit(Dictionary<string, object> dict)
        {
			ObjectId = (int)dict["ObjectId"];
			AnimaType = (int)dict["AnimaType"];
			Coords = (Vector2I)dict["Coords"];
			LengWidth = (Vector2I)dict["LengWidth"];
			MaxIndex = (int)dict["MaxIndex"];
			Size = (Vector2I)dict["Size"];
			Offset = (Vector2)dict["Offset"];
			RelativeList = (List<List<int>>)dict["RelativeList"];
			SpeedScale = (int)dict["SpeedScale"];
			IsAutoplay = (bool)dict["IsAutoplay"];
			IsLoop = (bool)dict["IsLoop"];
			Picture = (Texture2D)dict["Picture"];
			FlipH = (bool)dict["FlipH"];
			FlipV = (bool)dict["FlipV"];
			InitData();
        }
        #endregion
    }
}
