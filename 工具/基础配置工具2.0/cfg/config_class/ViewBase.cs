using System.Collections.Generic;
Texture2DVector2Colornamespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 ViewBase 用于 界面基础配置,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class ViewBase
    {
        #region 参数及初始化
        /// <summary>
        /// 界面id
        /// </summary>
        public int ViewId { get; set; }
        /// <summary>
        /// 界面名称
        /// </summary>
        public string ViewName { get; set; }
        /// <summary>
        /// 界面显示层级
        ///Zindex
        /// </summary>
        public int Zindex { get; set; }
        /// <summary>
        /// 界面大小设置方式
        ///1 固定大小
        ///2 比例大小
        /// </summary>
        public int SizeType { get; set; }
        /// <summary>
        /// 界面大小
        ///大小设置方式为1是 横纵轴像素(x,y)
        /// 为2 是屏幕比例最大为1（0.8,0.8）
        /// </summary>
        public Vector2 ViewSize { get; set; }
        /// <summary>
        /// 界面位置
        /// </summary>
        public Vector2 ViewPos { get; set; }
        /// <summary>
        /// 界面背景颜色
        /// </summary>
        public Color BackdropColor { get; set; }
        /// <summary>
        /// 界面背景图片
        /// </summary>
        public Texture2D BackdropPng { get; set; }

        public ViewBase(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_ViewBase, id);//public const string Config_ViewBase = "cfg_ViewBase"; 
			ViewId = (int)dict["ViewId"];
			ViewName = (string)dict["ViewName"];
			Zindex = (int)dict["Zindex"];
			SizeType = (int)dict["SizeType"];
			ViewSize = (Vector2)dict["ViewSize"];
			ViewPos = (Vector2)dict["ViewPos"];
			BackdropColor = (Color)dict["BackdropColor"];
			BackdropPng = (Texture2D)dict["BackdropPng"];
			InitData();
        }

        
        public ViewBase(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_ViewBase, cfg_id);//public const string Config_ViewBase = "cfg_ViewBase"; 
			ViewId = (int)dict["ViewId"];
			ViewName = (string)dict["ViewName"];
			Zindex = (int)dict["Zindex"];
			SizeType = (int)dict["SizeType"];
			ViewSize = (Vector2)dict["ViewSize"];
			ViewPos = (Vector2)dict["ViewPos"];
			BackdropColor = (Color)dict["BackdropColor"];
			BackdropPng = (Texture2D)dict["BackdropPng"];
			InitData();
        }

        public ViewBase(Dictionary<string, object> dict)
        {
			ViewId = (int)dict["ViewId"];
			ViewName = (string)dict["ViewName"];
			Zindex = (int)dict["Zindex"];
			SizeType = (int)dict["SizeType"];
			ViewSize = (Vector2)dict["ViewSize"];
			ViewPos = (Vector2)dict["ViewPos"];
			BackdropColor = (Color)dict["BackdropColor"];
			BackdropPng = (Texture2D)dict["BackdropPng"];
			InitData();
        }
        #endregion
    }
}
