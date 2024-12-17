using System.Collections.Generic;
using Godot;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 ChapterBase 用于 战役基础数据,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class ChapterBase
    {
        #region 参数及初始化
        /// <summary>        
        /// 战役id
        ///按数字从1开始排序
        /// </summary>
        public int ChapterId { get; set; }
        /// <summary>        
        /// 章节名称
        /// </summary>
        public string ChapterName { get; set; }
        /// <summary>        
        /// 章节描述文字1
        /// </summary>
        public string Describe1 { get; set; }
        /// <summary>        
        /// 章节描述文字2
        /// </summary>
        public string Describe2 { get; set; }
        /// <summary>        
        /// 章节类型
        ///暂不使用
        /// </summary>
        public int ChapterType { get; set; }
        /// <summary>        
        /// 战役所用大地图id
        /// </summary>
        public int BigMapBaseId { get; set; }
        /// <summary>        
        /// 地图相机id
        /// </summary>
        public int CameraId { get; set; }
        /// <summary>        
        /// 战役图片
        /// </summary>
        public Texture2D ChapterImage { get; set; }
        /// <summary>        
        /// 战役初始关卡列表
        ///一开始就解锁的关卡
        ///
        /// </summary>
        public List<int> ChapterStartCopy { get; set; }
        /// <summary>        
        /// 战役初始就占领的位置列表
        /// </summary>
        public List<Vector2I> UnLockList { get; set; }

        public ChapterBase(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_ChapterBase, id);//public const string Config_ChapterBase = "cfg_ChapterBase"; 
			ChapterId = (int)dict["ChapterId"];
			ChapterName = (string)dict["ChapterName"];
			Describe1 = (string)dict["Describe1"];
			Describe2 = (string)dict["Describe2"];
			ChapterType = (int)dict["ChapterType"];
			BigMapBaseId = (int)dict["BigMapBaseId"];
			CameraId = (int)dict["CameraId"];
			ChapterImage = (Texture2D)dict["ChapterImage"];
			ChapterStartCopy = (List<int>)dict["ChapterStartCopy"];
			UnLockList = (List<Vector2I>)dict["UnLockList"];
			InitData();
        }

        
        public ChapterBase(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_ChapterBase, cfg_id);//public const string Config_ChapterBase = "cfg_ChapterBase"; 
			ChapterId = (int)dict["ChapterId"];
			ChapterName = (string)dict["ChapterName"];
			Describe1 = (string)dict["Describe1"];
			Describe2 = (string)dict["Describe2"];
			ChapterType = (int)dict["ChapterType"];
			BigMapBaseId = (int)dict["BigMapBaseId"];
			CameraId = (int)dict["CameraId"];
			ChapterImage = (Texture2D)dict["ChapterImage"];
			ChapterStartCopy = (List<int>)dict["ChapterStartCopy"];
			UnLockList = (List<Vector2I>)dict["UnLockList"];
			InitData();
        }

        public ChapterBase(Dictionary<string, object> dict)
        {
			ChapterId = (int)dict["ChapterId"];
			ChapterName = (string)dict["ChapterName"];
			Describe1 = (string)dict["Describe1"];
			Describe2 = (string)dict["Describe2"];
			ChapterType = (int)dict["ChapterType"];
			BigMapBaseId = (int)dict["BigMapBaseId"];
			CameraId = (int)dict["CameraId"];
			ChapterImage = (Texture2D)dict["ChapterImage"];
			ChapterStartCopy = (List<int>)dict["ChapterStartCopy"];
			UnLockList = (List<Vector2I>)dict["UnLockList"];
			InitData();
        }
        #endregion
    }
}
