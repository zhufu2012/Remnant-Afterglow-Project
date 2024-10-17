using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 BaseObjectShow 用于 实体显示方式表,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class BaseObjectShow
    {
        #region 参数及初始化
        /// <summary>
        /// 实体显示id
        /// </summary>
        public int ObjectShow { get; set; }
        /// <summary>
        /// 底部栏项目id
        /// </summary>
        public int ObjectBottomId { get; set; }
        /// <summary>
        /// 左侧边栏项目id
        /// </summary>
        public int ObjectSideId { get; set; }

        public BaseObjectShow(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BaseObjectShow, id);//public const string Config_BaseObjectShow = "cfg_BaseObjectShow"; 
			ObjectShow = (int)dict["ObjectShow"];
			ObjectBottomId = (int)dict["ObjectBottomId"];
			ObjectSideId = (int)dict["ObjectSideId"];
			InitData();
        }

        
        public BaseObjectShow(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BaseObjectShow, cfg_id);//public const string Config_BaseObjectShow = "cfg_BaseObjectShow"; 
			ObjectShow = (int)dict["ObjectShow"];
			ObjectBottomId = (int)dict["ObjectBottomId"];
			ObjectSideId = (int)dict["ObjectSideId"];
			InitData();
        }

        public BaseObjectShow(Dictionary<string, object> dict)
        {
			ObjectShow = (int)dict["ObjectShow"];
			ObjectBottomId = (int)dict["ObjectBottomId"];
			ObjectSideId = (int)dict["ObjectSideId"];
			InitData();
        }
        #endregion
    }
}
