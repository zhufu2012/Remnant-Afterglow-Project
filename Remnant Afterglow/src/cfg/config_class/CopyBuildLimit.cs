using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 CopyBuildLimit 用于 关卡建造限制,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class CopyBuildLimit
    {
        #region 参数及初始化
        /// <summary>        
        /// 战役id
        ///cfg_ChapterBase_战役基础数据表id
        /// </summary>
        public int ChapterId { get; set; }
        /// <summary>        
        /// 关卡id
        /// </summary>
        public int CopyId { get; set; }
        /// <summary>        
        /// 限制建筑最高等级
        ///写5就是不限制
        /// </summary>
        public int LimitLv { get; set; }
        /// <summary>        
        /// 是否为挑战关卡
        ///是挑战关卡，才使用LimitBuildItemIdList字段
        ///不是挑战关卡，默认全部可建造
        /// </summary>
        public bool IsChallenge { get; set; }
        /// <summary>        
        /// 可建造项列表
        ///cfg_MapBuildItem_建造项数据
        /// </summary>
        public List<int> LimitBuildItemIdList { get; set; }

        public CopyBuildLimit(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_CopyBuildLimit, id);//public const string Config_CopyBuildLimit = "cfg_CopyBuildLimit"; 
			ChapterId = (int)dict["ChapterId"];
			CopyId = (int)dict["CopyId"];
			LimitLv = (int)dict["LimitLv"];
			IsChallenge = (bool)dict["IsChallenge"];
			LimitBuildItemIdList = (List<int>)dict["LimitBuildItemIdList"];
			InitData();
        }

        
        public CopyBuildLimit(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_CopyBuildLimit, cfg_id);//public const string Config_CopyBuildLimit = "cfg_CopyBuildLimit"; 
			ChapterId = (int)dict["ChapterId"];
			CopyId = (int)dict["CopyId"];
			LimitLv = (int)dict["LimitLv"];
			IsChallenge = (bool)dict["IsChallenge"];
			LimitBuildItemIdList = (List<int>)dict["LimitBuildItemIdList"];
			InitData();
        }

        public CopyBuildLimit(Dictionary<string, object> dict)
        {
			ChapterId = (int)dict["ChapterId"];
			CopyId = (int)dict["CopyId"];
			LimitLv = (int)dict["LimitLv"];
			IsChallenge = (bool)dict["IsChallenge"];
			LimitBuildItemIdList = (List<int>)dict["LimitBuildItemIdList"];
			InitData();
        }
        #endregion
    }
}
