using System.Collections.Generic;
using Godot;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 UpdateLog 用于 更新日志,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class UpdateLog
    {
        #region 参数及初始化
        /// <summary>        
        /// 更新日志id
        /// </summary>
        public int UpdateLogId { get; set; }
        /// <summary>        
        /// 更新时间
        /// </summary>
        public string Time { get; set; }
        /// <summary>        
        /// 名称文字字号
        /// </summary>
        public int NameSize { get; set; }
        /// <summary>        
        /// 名称文字颜色
        /// </summary>
        public Color NameColor { get; set; }
        /// <summary>        
        /// 名称
        /// </summary>
        public string Name { get; set; }
        /// <summary>        
        /// 内容文字字号
        /// </summary>
        public int ContentSize { get; set; }
        /// <summary>        
        /// 内容文字颜色
        /// </summary>
        public Color ContentColor { get; set; }
        /// <summary>        
        /// 更新内容
        /// </summary>
        public string Content { get; set; }

        public UpdateLog(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_UpdateLog, id);//public const string Config_UpdateLog = "cfg_UpdateLog"; 
			UpdateLogId = (int)dict["UpdateLogId"];
			Time = (string)dict["Time"];
			NameSize = (int)dict["NameSize"];
			NameColor = (Color)dict["NameColor"];
			Name = (string)dict["Name"];
			ContentSize = (int)dict["ContentSize"];
			ContentColor = (Color)dict["ContentColor"];
			Content = (string)dict["Content"];
			InitData();
        }

        
        public UpdateLog(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_UpdateLog, cfg_id);//public const string Config_UpdateLog = "cfg_UpdateLog"; 
			UpdateLogId = (int)dict["UpdateLogId"];
			Time = (string)dict["Time"];
			NameSize = (int)dict["NameSize"];
			NameColor = (Color)dict["NameColor"];
			Name = (string)dict["Name"];
			ContentSize = (int)dict["ContentSize"];
			ContentColor = (Color)dict["ContentColor"];
			Content = (string)dict["Content"];
			InitData();
        }

        public UpdateLog(Dictionary<string, object> dict)
        {
			UpdateLogId = (int)dict["UpdateLogId"];
			Time = (string)dict["Time"];
			NameSize = (int)dict["NameSize"];
			NameColor = (Color)dict["NameColor"];
			Name = (string)dict["Name"];
			ContentSize = (int)dict["ContentSize"];
			ContentColor = (Color)dict["ContentColor"];
			Content = (string)dict["Content"];
			InitData();
        }
        #endregion
    }
}
