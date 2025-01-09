using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 MapEdge 用于 地图边缘连接配置,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class MapEdge
    {
        #region 参数及初始化
        /// <summary>        
        /// 地图生成用材料id
        /// </summary>
        public int MaterialId { get; set; }
        /// <summary>        
        /// 边缘类型
        ///0    0000  四周无本材料
        ///1    0001  下端有
        ///2    0010  左端有
        ///3    0011  左下有
        ///4    0100  上端有
        ///5    0101  上下有
        ///6    0110  左上有
        ///7    0111  左上下有
        ///8    1000  右端有
        ///9    1001  右下有
        ///10   1010 左右有
        ///11   1011 左右下有
        ///12   1100 右上有
        ///13   1101 右上下有
        ///14   1110 左右上有
        ///15   1111 四边都有
        /// </summary>
        public int EdgeId { get; set; }
        /// <summary>        
        /// 材料所用图集id
        ///地块表的cfg_MapImageSet_地图图像集id
        /// </summary>
        public int ImageSetId { get; set; }
        /// <summary>        
        /// 所在图集序号
        /// </summary>
        public int ImageSetIndex { get; set; }

        public MapEdge(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_MapEdge, id);//public const string Config_MapEdge = "cfg_MapEdge"; 
			MaterialId = (int)dict["MaterialId"];
			EdgeId = (int)dict["EdgeId"];
			ImageSetId = (int)dict["ImageSetId"];
			ImageSetIndex = (int)dict["ImageSetIndex"];
			InitData();
        }

        
        public MapEdge(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_MapEdge, cfg_id);//public const string Config_MapEdge = "cfg_MapEdge"; 
			MaterialId = (int)dict["MaterialId"];
			EdgeId = (int)dict["EdgeId"];
			ImageSetId = (int)dict["ImageSetId"];
			ImageSetIndex = (int)dict["ImageSetIndex"];
			InitData();
        }

        public MapEdge(Dictionary<string, object> dict)
        {
			MaterialId = (int)dict["MaterialId"];
			EdgeId = (int)dict["EdgeId"];
			ImageSetId = (int)dict["ImageSetId"];
			ImageSetIndex = (int)dict["ImageSetIndex"];
			InitData();
        }
        #endregion
    }
}
