using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 ErrorBase 用于 错误码,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class ErrorBase
    {
        #region 参数及初始化
        /// <summary>        
        /// 错误码id
        /// </summary>
        public int ErrorId { get; set; }
        /// <summary>        
        /// 中文
        /// </summary>
        public string zh_cn { get; set; }

        public ErrorBase(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_ErrorBase, id);//public const string Config_ErrorBase = "cfg_ErrorBase"; 
			ErrorId = (int)dict["ErrorId"];
			zh_cn = (string)dict["zh_cn"];
			InitData();
        }

        
        public ErrorBase(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_ErrorBase, cfg_id);//public const string Config_ErrorBase = "cfg_ErrorBase"; 
			ErrorId = (int)dict["ErrorId"];
			zh_cn = (string)dict["zh_cn"];
			InitData();
        }

        public ErrorBase(Dictionary<string, object> dict)
        {
			ErrorId = (int)dict["ErrorId"];
			zh_cn = (string)dict["zh_cn"];
			InitData();
        }
        #endregion
    }
}
