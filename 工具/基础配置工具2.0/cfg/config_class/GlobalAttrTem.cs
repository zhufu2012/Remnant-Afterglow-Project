using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 GlobalAttrTem 用于 属性模板表,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class GlobalAttrTem
    {
        #region 参数及初始化
        /// <summary>
        /// 全局属性模板id
        /// </summary>
        public int TempLateId { get; set; }
        /// <summary>
        /// 标签名称
        /// </summary>
        public string TempLateName { get; set; }
        /// <summary>
        /// 是否其属性是否可以覆盖之前的属性
        ///写在前面的标签属性先添加，
        ///不允许会文字报错
        ///（非程序报错），允许不报错
        /// </summary>
        public bool IsCover { get; set; }

        public GlobalAttrTem(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_GlobalAttrTem, id);//public const string Config_GlobalAttrTem = "cfg_GlobalAttrTem"; 
			TempLateId = (int)dict["TempLateId"];
			TempLateName = (string)dict["TempLateName"];
			IsCover = (bool)dict["IsCover"];
			InitData();
        }

        
        public GlobalAttrTem(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_GlobalAttrTem, cfg_id);//public const string Config_GlobalAttrTem = "cfg_GlobalAttrTem"; 
			TempLateId = (int)dict["TempLateId"];
			TempLateName = (string)dict["TempLateName"];
			IsCover = (bool)dict["IsCover"];
			InitData();
        }

        public GlobalAttrTem(Dictionary<string, object> dict)
        {
			TempLateId = (int)dict["TempLateId"];
			TempLateName = (string)dict["TempLateName"];
			IsCover = (bool)dict["IsCover"];
			InitData();
        }
        #endregion
    }
}
