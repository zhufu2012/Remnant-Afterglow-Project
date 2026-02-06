using System.Collections.Generic;
using Godot;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 ChapterCopyBase 用于 战役关卡基础数据,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class ChapterCopyBase
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
        /// 关卡的描述数据id
        ///cfg_ChapterCopyUI_章节关卡描述数据
        /// </summary>
        public int CopyUiId { get; set; }
        /// <summary>
        /// 关卡类型
        ///0 常规刷怪关
        /// </summary>
        public int CopyType { get; set; }
        /// <summary>
        /// 地图相机id
        /// </summary>
        public int CameraId { get; set; }
        /// <summary>
        /// 地图文件名称，可以带文件夹
        ///默认路径在这里 Remnant Afterglow\map\
        ///举例：1.map
        ///2.map
        ///key/3.map
        ///无法仅填写#BASEVALUE
        /// </summary>
        public string MapName { get; set; }
        /// <summary>
        /// 关卡节点
        ///位置坐标
        /// </summary>
        public Vector2I Pos { get; set; }
        /// <summary>
        /// 关卡在大地图上
        ///显示用节点id
        ///cfg_BigMapMaterial_大地图节点的id
        ///
        /// </summary>
        public int NodeId { get; set; }
        /// <summary>
        /// 全局属性模板Id列表
        ///每帧运行一次
        ///cfg_GlobalAttrTem_属性模板表
        /// </summary>
        public List<int> GloTemList { get; set; }
        /// <summary>
        /// 后继关卡id列表
        ///通关该关卡后会解锁的
        ///关卡id
        ///(非关卡的地图相邻才能打)
        ///
        /// </summary>
        public List<int> CopyIdList { get; set; }

        public ChapterCopyBase(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_ChapterCopyBase, id);//public const string Config_ChapterCopyBase = "cfg_ChapterCopyBase"; 
			ChapterId = (int)dict["ChapterId"];
			CopyId = (int)dict["CopyId"];
			CopyUiId = (int)dict["CopyUiId"];
			CopyType = (int)dict["CopyType"];
			CameraId = (int)dict["CameraId"];
			MapName = (string)dict["MapName"];
			Pos = (Vector2I)dict["Pos"];
			NodeId = (int)dict["NodeId"];
			GloTemList = (List<int>)dict["GloTemList"];
			CopyIdList = (List<int>)dict["CopyIdList"];
			InitData();
        }

        
        public ChapterCopyBase(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_ChapterCopyBase, cfg_id);//public const string Config_ChapterCopyBase = "cfg_ChapterCopyBase"; 
			ChapterId = (int)dict["ChapterId"];
			CopyId = (int)dict["CopyId"];
			CopyUiId = (int)dict["CopyUiId"];
			CopyType = (int)dict["CopyType"];
			CameraId = (int)dict["CameraId"];
			MapName = (string)dict["MapName"];
			Pos = (Vector2I)dict["Pos"];
			NodeId = (int)dict["NodeId"];
			GloTemList = (List<int>)dict["GloTemList"];
			CopyIdList = (List<int>)dict["CopyIdList"];
			InitData();
        }

        public ChapterCopyBase(Dictionary<string, object> dict)
        {
			ChapterId = (int)dict["ChapterId"];
			CopyId = (int)dict["CopyId"];
			CopyUiId = (int)dict["CopyUiId"];
			CopyType = (int)dict["CopyType"];
			CameraId = (int)dict["CameraId"];
			MapName = (string)dict["MapName"];
			Pos = (Vector2I)dict["Pos"];
			NodeId = (int)dict["NodeId"];
			GloTemList = (List<int>)dict["GloTemList"];
			CopyIdList = (List<int>)dict["CopyIdList"];
			InitData();
        }
        #endregion
    }
}
