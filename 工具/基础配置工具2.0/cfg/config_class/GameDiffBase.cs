using System.Collections.Generic;
Texture2Dnamespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 GameDiffBase 用于 游戏难度相关,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class GameDiffBase
    {
        #region 参数及初始化
        /// <summary>
        /// 难度id
        /// </summary>
        public int DiffId { get; set; }
        /// <summary>
        /// 难度名称
        /// </summary>
        public string DiffName { get; set; }
        /// <summary>
        /// 难度描述
        /// </summary>
        public string DiffDes { get; set; }
        /// <summary>
        /// 难度标识图片
        /// </summary>
        public Texture2D DiffPng { get; set; }
        /// <summary>
        /// 是否使用
        /// </summary>
        public bool IsUser { get; set; }

        public GameDiffBase(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_GameDiffBase, id);//public const string Config_GameDiffBase = "cfg_GameDiffBase"; 
			DiffId = (int)dict["DiffId"];
			DiffName = (string)dict["DiffName"];
			DiffDes = (string)dict["DiffDes"];
			DiffPng = (Texture2D)dict["DiffPng"];
			IsUser = (bool)dict["IsUser"];
			InitData();
        }

        
        public GameDiffBase(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_GameDiffBase, cfg_id);//public const string Config_GameDiffBase = "cfg_GameDiffBase"; 
			DiffId = (int)dict["DiffId"];
			DiffName = (string)dict["DiffName"];
			DiffDes = (string)dict["DiffDes"];
			DiffPng = (Texture2D)dict["DiffPng"];
			IsUser = (bool)dict["IsUser"];
			InitData();
        }

        public GameDiffBase(Dictionary<string, object> dict)
        {
			DiffId = (int)dict["DiffId"];
			DiffName = (string)dict["DiffName"];
			DiffDes = (string)dict["DiffDes"];
			DiffPng = (Texture2D)dict["DiffPng"];
			IsUser = (bool)dict["IsUser"];
			InitData();
        }
        #endregion
    }
}
