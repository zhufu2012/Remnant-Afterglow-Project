using System.Collections.Generic;
using Godot;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 CampBase 用于 阵营基础数据,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class CampBase
    {
        #region 参数及初始化
        /// <summary>        
        /// 阵营id
        /// </summary>
        public int CampId { get; set; }
        /// <summary>        
        /// 阵营名称
        /// </summary>
        public string CampName { get; set; }
        /// <summary>        
        /// 阵营描述
        /// </summary>
        public string CampDes { get; set; }
        /// <summary>        
        /// 默认盟友阵营列表
        ///不会攻击盟友
        /// </summary>
        public List<int> AllyList { get; set; }
        /// <summary>        
        /// 默认中立阵营列表
        ///不会主动攻击中立
        ///攻击了就变成敌对阵营
        /// </summary>
        public List<int> NeutralList { get; set; }
        /// <summary>        
        /// 默认敌对阵营列表
        ///主动攻击敌对阵营
        ///有攻击先后顺序
        /// </summary>
        public List<int> HostileList { get; set; }
        /// <summary>        
        /// 阵营标识图片
        /// </summary>
        public Texture2D CampPng { get; set; }
        /// <summary>        
        /// 是否使用
        /// </summary>
        public bool IsUser { get; set; }

        public CampBase(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_CampBase, id);//public const string Config_CampBase = "cfg_CampBase"; 
			CampId = (int)dict["CampId"];
			CampName = (string)dict["CampName"];
			CampDes = (string)dict["CampDes"];
			AllyList = (List<int>)dict["AllyList"];
			NeutralList = (List<int>)dict["NeutralList"];
			HostileList = (List<int>)dict["HostileList"];
			CampPng = (Texture2D)dict["CampPng"];
			IsUser = (bool)dict["IsUser"];
			InitData();
        }

        
        public CampBase(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_CampBase, cfg_id);//public const string Config_CampBase = "cfg_CampBase"; 
			CampId = (int)dict["CampId"];
			CampName = (string)dict["CampName"];
			CampDes = (string)dict["CampDes"];
			AllyList = (List<int>)dict["AllyList"];
			NeutralList = (List<int>)dict["NeutralList"];
			HostileList = (List<int>)dict["HostileList"];
			CampPng = (Texture2D)dict["CampPng"];
			IsUser = (bool)dict["IsUser"];
			InitData();
        }

        public CampBase(Dictionary<string, object> dict)
        {
			CampId = (int)dict["CampId"];
			CampName = (string)dict["CampName"];
			CampDes = (string)dict["CampDes"];
			AllyList = (List<int>)dict["AllyList"];
			NeutralList = (List<int>)dict["NeutralList"];
			HostileList = (List<int>)dict["HostileList"];
			CampPng = (Texture2D)dict["CampPng"];
			IsUser = (bool)dict["IsUser"];
			InitData();
        }
        #endregion
    }
}
