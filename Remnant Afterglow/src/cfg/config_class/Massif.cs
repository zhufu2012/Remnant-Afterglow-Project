using System.Collections.Generic;
Texture2Dnamespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 Massif 用于 资源地块,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class Massif
    {
        #region 参数及初始化
        /// <summary>
        /// 地块id
        /// </summary>
        public int MassifId { get; set; }
        /// <summary>
        /// 地块名称
        /// </summary>
        public string MassifName { get; set; }
        /// <summary>
        /// 可通过类型id
        ///数据是cfg_MapPassType的id
        /// </summary>
        public int PassTypeId { get; set; }
        /// <summary>
        /// 地块大小 
        ///图片大小(长，宽)
        /// </summary>
        public List<float> MassifSize { get; set; }
        /// <summary>
        /// 可产出资源列表
        ///资源表的cfg_ziyuan_资源的id列表
        ///
        /// </summary>
        public int ItemIdList { get; set; }
        /// <summary>
        /// 蕴含实际资源数量
        /// </summary>
        public int NumberResources { get; set; }
        /// <summary>
        /// 地块图片
        /// </summary>
        public Texture2D PlotPictures { get; set; }
        /// <summary>
        /// 被开采效率
        /// </summary>
        public float TheEfficiencyMining { get; set; }
        /// <summary>
        /// 开采标签id
        /// </summary>
        public int TheExtractionLabelPprovided { get; set; }

        public Massif(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_Massif, id);//public const string Config_Massif = "cfg_Massif"; 
			MassifId = (int)dict["MassifId"];
			MassifName = (string)dict["MassifName"];
			PassTypeId = (int)dict["PassTypeId"];
			MassifSize = (List<float>)dict["MassifSize"];
			ItemIdList = (int)dict["ItemIdList"];
			NumberResources = (int)dict["NumberResources"];
			PlotPictures = (Texture2D)dict["PlotPictures"];
			TheEfficiencyMining = (float)dict["TheEfficiencyMining"];
			TheExtractionLabelPprovided = (int)dict["TheExtractionLabelPprovided"];
			InitData();
        }

        
        public Massif(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_Massif, cfg_id);//public const string Config_Massif = "cfg_Massif"; 
			MassifId = (int)dict["MassifId"];
			MassifName = (string)dict["MassifName"];
			PassTypeId = (int)dict["PassTypeId"];
			MassifSize = (List<float>)dict["MassifSize"];
			ItemIdList = (int)dict["ItemIdList"];
			NumberResources = (int)dict["NumberResources"];
			PlotPictures = (Texture2D)dict["PlotPictures"];
			TheEfficiencyMining = (float)dict["TheEfficiencyMining"];
			TheExtractionLabelPprovided = (int)dict["TheExtractionLabelPprovided"];
			InitData();
        }

        public Massif(Dictionary<string, object> dict)
        {
			MassifId = (int)dict["MassifId"];
			MassifName = (string)dict["MassifName"];
			PassTypeId = (int)dict["PassTypeId"];
			MassifSize = (List<float>)dict["MassifSize"];
			ItemIdList = (int)dict["ItemIdList"];
			NumberResources = (int)dict["NumberResources"];
			PlotPictures = (Texture2D)dict["PlotPictures"];
			TheEfficiencyMining = (float)dict["TheEfficiencyMining"];
			TheExtractionLabelPprovided = (int)dict["TheExtractionLabelPprovided"];
			InitData();
        }
        #endregion
    }
}
