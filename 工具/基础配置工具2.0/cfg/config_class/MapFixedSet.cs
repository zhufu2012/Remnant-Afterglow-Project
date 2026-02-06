using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 MapFixedSet 用于 固定地图图集 ,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class MapFixedSet
    {
        #region 参数及初始化
        /// <summary>
        /// 固定地图编辑用图集id
        ///逻辑图集id默认为1
        /// </summary>
        public int EditImageSetId { get; set; }
        /// <summary>
        /// 编辑图集的名称
        /// </summary>
        public string EditSetName { get; set; }
        /// <summary>
        /// 所在图层
        ///具体看 图层相关.xlsx的
        ///cfg_MapImageLayer_图像层配置表
        /// </summary>
        public int ImageLayer { get; set; }
        /// <summary>
        /// 固定地图材料id列表
        ///cfg_MapFixedMaterial_固定地图用材料
        /// </summary>
        public List<int> MaterialIdList { get; set; }

        public MapFixedSet(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_MapFixedSet, id);//public const string Config_MapFixedSet = "cfg_MapFixedSet"; 
			EditImageSetId = (int)dict["EditImageSetId"];
			EditSetName = (string)dict["EditSetName"];
			ImageLayer = (int)dict["ImageLayer"];
			MaterialIdList = (List<int>)dict["MaterialIdList"];
			InitData();
        }

        
        public MapFixedSet(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_MapFixedSet, cfg_id);//public const string Config_MapFixedSet = "cfg_MapFixedSet"; 
			EditImageSetId = (int)dict["EditImageSetId"];
			EditSetName = (string)dict["EditSetName"];
			ImageLayer = (int)dict["ImageLayer"];
			MaterialIdList = (List<int>)dict["MaterialIdList"];
			InitData();
        }

        public MapFixedSet(Dictionary<string, object> dict)
        {
			EditImageSetId = (int)dict["EditImageSetId"];
			EditSetName = (string)dict["EditSetName"];
			ImageLayer = (int)dict["ImageLayer"];
			MaterialIdList = (List<int>)dict["MaterialIdList"];
			InitData();
        }
        #endregion
    }
}
