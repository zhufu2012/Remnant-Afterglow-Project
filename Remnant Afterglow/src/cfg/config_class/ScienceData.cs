using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 ScienceData 用于 科技激活相关数据,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class ScienceData
    {
        #region 参数及初始化
        /// <summary>
        /// 科技id
        /// </summary>
        public int ScienceId { get; set; }
        /// <summary>
        /// 科技所属范围
        ///cfg_ScienceType_科技类型配置id
        ///如果不存在，会单看一个界面放置
        /// </summary>
        public int ScienceRangeId { get; set; }
        /// <summary>
        /// 科技类型
        ///0 通用类型（仅解锁建造列表）
        ///1 建筑属性增强（科技参数列表与解锁建造列表） 
        ///2 炮塔属性增强（科技参数列表与解锁建造列表）
        /// </summary>
        public int ScienceType { get; set; }
        /// <summary>
        /// 是否默认已解锁
        ///创建存档就解锁
        /// </summary>
        public bool IsUnlock { get; set; }
        /// <summary>
        /// 科技解锁所需货币
        /// </summary>
        public List<List<int>> UnlockCurrList { get; set; }
        /// <summary>
        /// 解锁建筑项id列表
        ///cfg_MapBuildList_建造子列表id
        /// </summary>
        public List<int> MapBuildIDList { get; set; }
        /// <summary>
        /// 科技参数1
        /// </summary>
        public int ScienceParam1 { get; set; }
        /// <summary>
        /// 科技参数列表
        /// </summary>
        public List<List<int>> ScienceParamList { get; set; }

        public ScienceData(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_ScienceData, id);//public const string Config_ScienceData = "cfg_ScienceData"; 
			ScienceId = (int)dict["ScienceId"];
			ScienceRangeId = (int)dict["ScienceRangeId"];
			ScienceType = (int)dict["ScienceType"];
			IsUnlock = (bool)dict["IsUnlock"];
			UnlockCurrList = (List<List<int>>)dict["UnlockCurrList"];
			MapBuildIDList = (List<int>)dict["MapBuildIDList"];
			ScienceParam1 = (int)dict["ScienceParam1"];
			ScienceParamList = (List<List<int>>)dict["ScienceParamList"];
			InitData();
        }

        
        public ScienceData(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_ScienceData, cfg_id);//public const string Config_ScienceData = "cfg_ScienceData"; 
			ScienceId = (int)dict["ScienceId"];
			ScienceRangeId = (int)dict["ScienceRangeId"];
			ScienceType = (int)dict["ScienceType"];
			IsUnlock = (bool)dict["IsUnlock"];
			UnlockCurrList = (List<List<int>>)dict["UnlockCurrList"];
			MapBuildIDList = (List<int>)dict["MapBuildIDList"];
			ScienceParam1 = (int)dict["ScienceParam1"];
			ScienceParamList = (List<List<int>>)dict["ScienceParamList"];
			InitData();
        }

        public ScienceData(Dictionary<string, object> dict)
        {
			ScienceId = (int)dict["ScienceId"];
			ScienceRangeId = (int)dict["ScienceRangeId"];
			ScienceType = (int)dict["ScienceType"];
			IsUnlock = (bool)dict["IsUnlock"];
			UnlockCurrList = (List<List<int>>)dict["UnlockCurrList"];
			MapBuildIDList = (List<int>)dict["MapBuildIDList"];
			ScienceParam1 = (int)dict["ScienceParam1"];
			ScienceParamList = (List<List<int>>)dict["ScienceParamList"];
			InitData();
        }
        #endregion
    }
}
