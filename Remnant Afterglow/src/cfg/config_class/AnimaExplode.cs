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
        /// 播放时，偏移中心的值
        ///（横,竖）
        /// </summary>
        public Vector2 Offset { get; set; }
        /// <summary>        
        /// 各帧相对持续时间
        ///各帧默认为1
        ///持续时间为1的帧的显示长度是持续时间为2的帧的两倍
        ///例子:(1,2)|(3,1)
        ///表示第一帧相对持续时间为2
        ///表示第三帧相对持续时间为1
        /// </summary>
        public List<List<float>> RelativeList { get; set; }
        /// <summary>        
        /// 设置动画播放倍数
        ///2表示两倍播放，0.5表示半速播放
        /// </summary>
        public int FrameSpeed { get; set; }
        /// <summary>        
        /// 设置动画的播放速度
        ///单位:
        /// </summary>
        public int PlaySpeed { get; set; }
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
        /// <summary>        
        /// 不水平翻转
        ///不填默认为True
        /// </summary>
        public bool FlipH { get; set; }
        /// <summary>        
        /// 不垂直翻转
        ///不填默认为True
        /// </summary>
        public bool FlipV { get; set; }

        public AnimaExplode(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_AnimaExplode, id);//public const string Config_AnimaExplode = "cfg_AnimaExplode"; 
			ExplodeId = (int)dict["ExplodeId"];
			AnimaType = (int)dict["AnimaType"];
			Coords = (Vector2I)dict["Coords"];
			LengWidth = (Vector2I)dict["LengWidth"];
			MaxIndex = (int)dict["MaxIndex"];
			Offset = (Vector2)dict["Offset"];
			RelativeList = (List<List<float>>)dict["RelativeList"];
			FrameSpeed = (int)dict["FrameSpeed"];
			PlaySpeed = (int)dict["PlaySpeed"];
			IsAutoplay = (bool)dict["IsAutoplay"];
			IsLoop = (bool)dict["IsLoop"];
			Picture = (Texture2D)dict["Picture"];
			FlipH = (bool)dict["FlipH"];
			FlipV = (bool)dict["FlipV"];
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
			Offset = (Vector2)dict["Offset"];
			RelativeList = (List<List<float>>)dict["RelativeList"];
			FrameSpeed = (int)dict["FrameSpeed"];
			PlaySpeed = (int)dict["PlaySpeed"];
			IsAutoplay = (bool)dict["IsAutoplay"];
			IsLoop = (bool)dict["IsLoop"];
			Picture = (Texture2D)dict["Picture"];
			FlipH = (bool)dict["FlipH"];
			FlipV = (bool)dict["FlipV"];
			InitData();
        }

        public AnimaExplode(Dictionary<string, object> dict)
        {
			ExplodeId = (int)dict["ExplodeId"];
			AnimaType = (int)dict["AnimaType"];
			Coords = (Vector2I)dict["Coords"];
			LengWidth = (Vector2I)dict["LengWidth"];
			MaxIndex = (int)dict["MaxIndex"];
			Offset = (Vector2)dict["Offset"];
			RelativeList = (List<List<float>>)dict["RelativeList"];
			FrameSpeed = (int)dict["FrameSpeed"];
			PlaySpeed = (int)dict["PlaySpeed"];
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
