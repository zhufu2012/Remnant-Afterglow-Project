using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 MapNavigate 用于 地图导航层,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class MapNavigate
    {
        #region 参数及初始化
        /// <summary>        
        /// 导航层id
        ///取值1-32
        /// </summary>
        public int NavigateLayerId { get; set; }
        /// <summary>        
        /// 图层显示名称
        ///编辑器中用于显示
        /// </summary>
        public string LayerName { get; set; }
        /// <summary>        
        /// 图层显示描述
        ///编辑器中用于显示
        /// </summary>
        public string LayerShowDes { get; set; }

        public MapNavigate(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_MapNavigate, id);//public const string Config_MapNavigate = "cfg_MapNavigate"; 
			NavigateLayerId = (int)dict["NavigateLayerId"];
			LayerName = (string)dict["LayerName"];
			LayerShowDes = (string)dict["LayerShowDes"];
			InitData();
        }

        
        public MapNavigate(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_MapNavigate, cfg_id);//public const string Config_MapNavigate = "cfg_MapNavigate"; 
			NavigateLayerId = (int)dict["NavigateLayerId"];
			LayerName = (string)dict["LayerName"];
			LayerShowDes = (string)dict["LayerShowDes"];
			InitData();
        }

        public MapNavigate(Dictionary<string, object> dict)
        {
			NavigateLayerId = (int)dict["NavigateLayerId"];
			LayerName = (string)dict["LayerName"];
			LayerShowDes = (string)dict["LayerShowDes"];
			InitData();
        }
        #endregion
    }
}
