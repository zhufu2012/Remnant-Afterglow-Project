using System.Collections.Generic;
using Godot;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 ObjectEffectImage 用于 实体效果图片,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class ObjectEffectImage
    {
        #region 参数及初始化
        /// <summary>
        /// 实体效果动画id
        /// </summary>
        public int EffectImageId { get; set; }
        /// <summary>
        /// 播放时，偏移中心的值
        ///（横,竖）
        /// </summary>
        public Vector2 Offset { get; set; }
        /// <summary>
        /// 所在图层-绘制顺序
        /// </summary>
        public int Index { get; set; }
        /// <summary>
        /// 效果类型
        ///0 无效果，随实体旋转
        ///1 无限旋转效果
        /// </summary>
        public int EffectType { get; set; }
        /// <summary>
        /// 效果参数
        ///效果类型 1：
        /// </summary>
        public List<int> EffectValueList { get; set; }
        /// <summary>
        /// 图片本身
        /// </summary>
        public Texture2D FrameAnimaDes { get; set; }

        public ObjectEffectImage(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_ObjectEffectImage, id);//public const string Config_ObjectEffectImage = "cfg_ObjectEffectImage"; 
			EffectImageId = (int)dict["EffectImageId"];
			Offset = (Vector2)dict["Offset"];
			Index = (int)dict["Index"];
			EffectType = (int)dict["EffectType"];
			EffectValueList = (List<int>)dict["EffectValueList"];
			FrameAnimaDes = (Texture2D)dict["FrameAnimaDes"];
			InitData();
        }

        
        public ObjectEffectImage(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_ObjectEffectImage, cfg_id);//public const string Config_ObjectEffectImage = "cfg_ObjectEffectImage"; 
			EffectImageId = (int)dict["EffectImageId"];
			Offset = (Vector2)dict["Offset"];
			Index = (int)dict["Index"];
			EffectType = (int)dict["EffectType"];
			EffectValueList = (List<int>)dict["EffectValueList"];
			FrameAnimaDes = (Texture2D)dict["FrameAnimaDes"];
			InitData();
        }

        public ObjectEffectImage(Dictionary<string, object> dict)
        {
			EffectImageId = (int)dict["EffectImageId"];
			Offset = (Vector2)dict["Offset"];
			Index = (int)dict["Index"];
			EffectType = (int)dict["EffectType"];
			EffectValueList = (List<int>)dict["EffectValueList"];
			FrameAnimaDes = (Texture2D)dict["FrameAnimaDes"];
			InitData();
        }
        #endregion
    }
}
