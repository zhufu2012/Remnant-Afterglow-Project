using System.Collections.Generic;
using Godot;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 MapDecorate 用于 地图装饰物配置,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class MapDecorate
    {
        #region 参数及初始化
        /// <summary>
        /// 装饰物id
        /// </summary>
        public int DecorateId { get; set; }
        /// <summary>
        /// 装饰物类型
        ///0 图片
        ///1 帧动画
        ///2 场景节点
        /// </summary>
        public int Type { get; set; }
        /// <summary>
        /// 装饰物所在ZIndex
        /// </summary>
        public int Zindex { get; set; }
        /// <summary>
        /// 装饰图片
        /// </summary>
        public Texture2D Png { get; set; }
        /// <summary>
        /// 装饰帧动画Id
        /// </summary>
        public Texture2D FrameAnimaId { get; set; }
        /// <summary>
        /// 装饰场景节点
        /// </summary>
        public string SceneNode { get; set; }

        public MapDecorate(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_MapDecorate, id);//public const string Config_MapDecorate = "cfg_MapDecorate"; 
			DecorateId = (int)dict["DecorateId"];
			Type = (int)dict["Type"];
			Zindex = (int)dict["Zindex"];
			Png = (Texture2D)dict["Png"];
			FrameAnimaId = (Texture2D)dict["FrameAnimaId"];
			SceneNode = (string)dict["SceneNode"];
			InitData();
        }

        
        public MapDecorate(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_MapDecorate, cfg_id);//public const string Config_MapDecorate = "cfg_MapDecorate"; 
			DecorateId = (int)dict["DecorateId"];
			Type = (int)dict["Type"];
			Zindex = (int)dict["Zindex"];
			Png = (Texture2D)dict["Png"];
			FrameAnimaId = (Texture2D)dict["FrameAnimaId"];
			SceneNode = (string)dict["SceneNode"];
			InitData();
        }

        public MapDecorate(Dictionary<string, object> dict)
        {
			DecorateId = (int)dict["DecorateId"];
			Type = (int)dict["Type"];
			Zindex = (int)dict["Zindex"];
			Png = (Texture2D)dict["Png"];
			FrameAnimaId = (Texture2D)dict["FrameAnimaId"];
			SceneNode = (string)dict["SceneNode"];
			InitData();
        }
        #endregion
    }
}
