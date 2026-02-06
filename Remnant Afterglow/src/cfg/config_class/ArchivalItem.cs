using System.Collections.Generic;
using Godot;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 ArchivalItem 用于 档案库子项,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class ArchivalItem
    {
        #region 参数及初始化
        /// <summary>
        /// 档案子项id
        ///id为0表示配置的未知文档
        /// </summary>
        public int ItemId { get; set; }
        /// <summary>
        /// 势力条目名称
        /// </summary>
        public string Name { get; set; }
        /// <summary>
        /// 内容
        /// </summary>
        public string Content { get; set; }
        /// <summary>
        /// 外部显示图
        /// </summary>
        public Texture2D Image { get; set; }
        /// <summary>
        /// 默认是否解锁
        /// </summary>
        public bool IsDefine { get; set; }

        public ArchivalItem(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_ArchivalItem, id);//public const string Config_ArchivalItem = "cfg_ArchivalItem"; 
			ItemId = (int)dict["ItemId"];
			Name = (string)dict["Name"];
			Content = (string)dict["Content"];
			Image = (Texture2D)dict["Image"];
			IsDefine = (bool)dict["IsDefine"];
			InitData();
        }

        
        public ArchivalItem(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_ArchivalItem, cfg_id);//public const string Config_ArchivalItem = "cfg_ArchivalItem"; 
			ItemId = (int)dict["ItemId"];
			Name = (string)dict["Name"];
			Content = (string)dict["Content"];
			Image = (Texture2D)dict["Image"];
			IsDefine = (bool)dict["IsDefine"];
			InitData();
        }

        public ArchivalItem(Dictionary<string, object> dict)
        {
			ItemId = (int)dict["ItemId"];
			Name = (string)dict["Name"];
			Content = (string)dict["Content"];
			Image = (Texture2D)dict["Image"];
			IsDefine = (bool)dict["IsDefine"];
			InitData();
        }
        #endregion
    }
}
