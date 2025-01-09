using System.Collections.Generic;
using Godot;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 AnimaBullet 用于 子弹动画,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class AnimaBullet
    {
        #region 参数及初始化
        /// <summary>        
        /// 子弹标签
        /// </summary>
        public string BulletLabel { get; set; }
        /// <summary>        
        /// 帧动画类型
        ///1 默认动画
        ///6 子弹命中
        ///7 子弹消失
        /// </summary>
        public int AnimaType { get; set; }
        /// <summary>        
        /// 帧图坐标
        /// </summary>
        public Vector2I Coords { get; set; }
        /// <summary>        
        /// 单个帧
        ///横纵像素px
        /// </summary>
        public Vector2I LengWidth { get; set; }
        /// <summary>        
        /// 帧图最大序号
        ///第一张图是1
        /// </summary>
        public int MaxIndex { get; set; }
        /// <summary>        
        /// 帧图大小
        ///横向多少张图
        ///纵向多少张图
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
        public int FrameSpeed { get; set; }
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
        /// 
        /// </summary>
        public bool FlipH { get; set; }
        /// <summary>        
        /// 
        /// </summary>
        public bool FlipV { get; set; }

        public AnimaBullet(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_AnimaBullet, id);//public const string Config_AnimaBullet = "cfg_AnimaBullet"; 
			BulletLabel = (string)dict["BulletLabel"];
			AnimaType = (int)dict["AnimaType"];
			Coords = (Vector2I)dict["Coords"];
			LengWidth = (Vector2I)dict["LengWidth"];
			MaxIndex = (int)dict["MaxIndex"];
			Size = (Vector2I)dict["Size"];
			Offset = (Vector2)dict["Offset"];
			RelativeList = (List<List<int>>)dict["RelativeList"];
			FrameSpeed = (int)dict["FrameSpeed"];
			IsAutoplay = (bool)dict["IsAutoplay"];
			IsLoop = (bool)dict["IsLoop"];
			Picture = (Texture2D)dict["Picture"];
			FlipH = (bool)dict["FlipH"];
			FlipV = (bool)dict["FlipV"];
			InitData();
        }

        
        public AnimaBullet(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_AnimaBullet, cfg_id);//public const string Config_AnimaBullet = "cfg_AnimaBullet"; 
			BulletLabel = (string)dict["BulletLabel"];
			AnimaType = (int)dict["AnimaType"];
			Coords = (Vector2I)dict["Coords"];
			LengWidth = (Vector2I)dict["LengWidth"];
			MaxIndex = (int)dict["MaxIndex"];
			Size = (Vector2I)dict["Size"];
			Offset = (Vector2)dict["Offset"];
			RelativeList = (List<List<int>>)dict["RelativeList"];
			FrameSpeed = (int)dict["FrameSpeed"];
			IsAutoplay = (bool)dict["IsAutoplay"];
			IsLoop = (bool)dict["IsLoop"];
			Picture = (Texture2D)dict["Picture"];
			FlipH = (bool)dict["FlipH"];
			FlipV = (bool)dict["FlipV"];
			InitData();
        }

        public AnimaBullet(Dictionary<string, object> dict)
        {
			BulletLabel = (string)dict["BulletLabel"];
			AnimaType = (int)dict["AnimaType"];
			Coords = (Vector2I)dict["Coords"];
			LengWidth = (Vector2I)dict["LengWidth"];
			MaxIndex = (int)dict["MaxIndex"];
			Size = (Vector2I)dict["Size"];
			Offset = (Vector2)dict["Offset"];
			RelativeList = (List<List<int>>)dict["RelativeList"];
			FrameSpeed = (int)dict["FrameSpeed"];
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
