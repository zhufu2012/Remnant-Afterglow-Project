using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 MapWall 用于 地图墙壁表,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class MapWall
    {
        #region 参数及初始化
        /// <summary>
        /// 墙壁生成方式id
        /// </summary>
        public int WallId { get; set; }
        /// <summary>
        /// 墙壁描述
        /// </summary>
        public string WallDescribe { get; set; }

        public MapWall(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_MapWall, id);//public const string Config_MapWall = "cfg_MapWall"; 
			WallId = (int)dict["WallId"];
			WallDescribe = (string)dict["WallDescribe"];
			InitData();
        }

        
        public MapWall(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_MapWall, cfg_id);//public const string Config_MapWall = "cfg_MapWall"; 
			WallId = (int)dict["WallId"];
			WallDescribe = (string)dict["WallDescribe"];
			InitData();
        }

        public MapWall(Dictionary<string, object> dict)
        {
			WallId = (int)dict["WallId"];
			WallDescribe = (string)dict["WallDescribe"];
			InitData();
        }
        #endregion
    }
}
