using System.Collections.Generic;
using Godot;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 AnimaBuild2 用于 建筑动画,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class AnimaBuild2
    {
        #region 参数及初始化
        /// <summary>
        /// 实体id
        ///建筑
        /// </summary>
        public int ObjectId { get; set; }
        /// <summary>
        /// 帧动画类型
        ///1 默认动画
        ///5 工作动画
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
        /// 帧图最大序号（帧）
        ///第一张图是1
        /// </summary>
        public int MaxIndex { get; set; }
        /// <summary>
        /// 帧图大小
        ///（横,纵）
        /// </summary>
        public Vector2I Size { get; set; }
        /// <summary>
        /// 播放时,偏移中心的值
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
        /// 设置动画播放速度
        ///5是默认值，表示一秒5帧
        /// </summary>
        public int SpeedFps { get; set; }
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

        public AnimaBuild2(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_AnimaBuild2, id);//public const string Config_AnimaBuild2 = "cfg_AnimaBuild2"; 
			ObjectId = (int)dict["ObjectId"];
			AnimaType = (int)dict["AnimaType"];
			Coords = (Vector2I)dict["Coords"];
			LengWidth = (Vector2I)dict["LengWidth"];
			MaxIndex = (int)dict["MaxIndex"];
			Size = (Vector2I)dict["Size"];
			Offset = (Vector2)dict["Offset"];
			RelativeList = (List<List<float>>)dict["RelativeList"];
			SpeedFps = (int)dict["SpeedFps"];
			Picture = (Texture2D)dict["Picture"];
			FlipH = (bool)dict["FlipH"];
			FlipV = (bool)dict["FlipV"];
			InitData();
        }

        
        public AnimaBuild2(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_AnimaBuild2, cfg_id);//public const string Config_AnimaBuild2 = "cfg_AnimaBuild2"; 
			ObjectId = (int)dict["ObjectId"];
			AnimaType = (int)dict["AnimaType"];
			Coords = (Vector2I)dict["Coords"];
			LengWidth = (Vector2I)dict["LengWidth"];
			MaxIndex = (int)dict["MaxIndex"];
			Size = (Vector2I)dict["Size"];
			Offset = (Vector2)dict["Offset"];
			RelativeList = (List<List<float>>)dict["RelativeList"];
			SpeedFps = (int)dict["SpeedFps"];
			Picture = (Texture2D)dict["Picture"];
			FlipH = (bool)dict["FlipH"];
			FlipV = (bool)dict["FlipV"];
			InitData();
        }

        public AnimaBuild2(Dictionary<string, object> dict)
        {
			ObjectId = (int)dict["ObjectId"];
			AnimaType = (int)dict["AnimaType"];
			Coords = (Vector2I)dict["Coords"];
			LengWidth = (Vector2I)dict["LengWidth"];
			MaxIndex = (int)dict["MaxIndex"];
			Size = (Vector2I)dict["Size"];
			Offset = (Vector2)dict["Offset"];
			RelativeList = (List<List<float>>)dict["RelativeList"];
			SpeedFps = (int)dict["SpeedFps"];
			Picture = (Texture2D)dict["Picture"];
			FlipH = (bool)dict["FlipH"];
			FlipV = (bool)dict["FlipV"];
			InitData();
        }
        #endregion
    }
}
