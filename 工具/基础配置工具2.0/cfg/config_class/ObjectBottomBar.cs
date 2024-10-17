using System.Collections.Generic;
Vector2namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 ObjectBottomBar 用于 底部栏,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class ObjectBottomBar
    {
        #region 参数及初始化
        /// <summary>
        /// 底部栏id
        /// </summary>
        public int BottomBarId { get; set; }
        /// <summary>
        /// 底部栏位置偏移
        ///(X,Y)
        /// </summary>
        public Vector2 BottomBarOffset { get; set; }

        public ObjectBottomBar(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_ObjectBottomBar, id);//public const string Config_ObjectBottomBar = "cfg_ObjectBottomBar"; 
			BottomBarId = (int)dict["BottomBarId"];
			BottomBarOffset = (Vector2)dict["BottomBarOffset"];
			InitData();
        }

        
        public ObjectBottomBar(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_ObjectBottomBar, cfg_id);//public const string Config_ObjectBottomBar = "cfg_ObjectBottomBar"; 
			BottomBarId = (int)dict["BottomBarId"];
			BottomBarOffset = (Vector2)dict["BottomBarOffset"];
			InitData();
        }

        public ObjectBottomBar(Dictionary<string, object> dict)
        {
			BottomBarId = (int)dict["BottomBarId"];
			BottomBarOffset = (Vector2)dict["BottomBarOffset"];
			InitData();
        }
        #endregion
    }
}
