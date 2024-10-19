using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 CopyBrush 用于 战役关卡刷怪数据,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class CopyBrush
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
        /// 关卡类型
        ///0 通用类型，造塔刷怪，
        ///且无玩家实体
        ///
        /// </summary>
        public int CopyType { get; set; }
        /// <summary>        
        /// 总波数
        /// </summary>
        public int WaveNum { get; set; }
        /// <summary>        
        /// 刷怪默认时间
        ///（秒）
        /// </summary>
        public int BrushSpace { get; set; }
        /// <summary>        
        /// 刷新前间隔时间列表
        ///(1,10) 表示第一波10秒后刷新
        ///不写默认为BrushSpace的秒数
        ///(波数，第一波间隔)|(波数，第二波间隔) 
        ///
        /// </summary>
        public List<List<int>> BrushSpaceList { get; set; }
        /// <summary>        
        /// 刷怪点id列表
        ///cfg_BrushPoint_刷怪点表id
        /// </summary>
        public List<int> BrushIdList { get; set; }

        public CopyBrush(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_CopyBrush, id);//public const string Config_CopyBrush = "cfg_CopyBrush"; 
			ChapterId = (int)dict["ChapterId"];
			CopyId = (int)dict["CopyId"];
			CopyType = (int)dict["CopyType"];
			WaveNum = (int)dict["WaveNum"];
			BrushSpace = (int)dict["BrushSpace"];
			BrushSpaceList = (List<List<int>>)dict["BrushSpaceList"];
			BrushIdList = (List<int>)dict["BrushIdList"];
			InitData();
        }

        
        public CopyBrush(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_CopyBrush, cfg_id);//public const string Config_CopyBrush = "cfg_CopyBrush"; 
			ChapterId = (int)dict["ChapterId"];
			CopyId = (int)dict["CopyId"];
			CopyType = (int)dict["CopyType"];
			WaveNum = (int)dict["WaveNum"];
			BrushSpace = (int)dict["BrushSpace"];
			BrushSpaceList = (List<List<int>>)dict["BrushSpaceList"];
			BrushIdList = (List<int>)dict["BrushIdList"];
			InitData();
        }

        public CopyBrush(Dictionary<string, object> dict)
        {
			ChapterId = (int)dict["ChapterId"];
			CopyId = (int)dict["CopyId"];
			CopyType = (int)dict["CopyType"];
			WaveNum = (int)dict["WaveNum"];
			BrushSpace = (int)dict["BrushSpace"];
			BrushSpaceList = (List<List<int>>)dict["BrushSpaceList"];
			BrushIdList = (List<int>)dict["BrushIdList"];
			InitData();
        }
        #endregion
    }
}
