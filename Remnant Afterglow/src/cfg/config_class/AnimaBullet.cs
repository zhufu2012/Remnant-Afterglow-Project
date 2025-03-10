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
        ///20 子弹命中
        ///21 子弹消失
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
			RelativeList = (List<List<float>>)dict["RelativeList"];
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
			RelativeList = (List<List<float>>)dict["RelativeList"];
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
			RelativeList = (List<List<float>>)dict["RelativeList"];
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
