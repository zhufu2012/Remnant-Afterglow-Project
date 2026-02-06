using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 FunctionTemplate 用于 函数模板,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class FunctionTemplate
    {
        #region 参数及初始化
        /// <summary>
        /// 模板id
        ///也是类名
        /// </summary>
        public string TemplateId { get; set; }
        /// <summary>
        /// 表名
        /// </summary>
        public string TableName { get; set; }
        /// <summary>
        /// 表中主键的字段名
        /// </summary>
        public string TableKey { get; set; }
        /// <summary>
        /// 对应表中
        ///代码的字段名
        /// </summary>
        public string TableCode { get; set; }
        /// <summary>
        /// 对应表中
        ///返回值的字段名
        /// </summary>
        public string TableReturn { get; set; }
        /// <summary>
        /// 导包代码
        /// </summary>
        public string CodePack { get; set; }
        /// <summary>
        /// 函数输入变量
        /// </summary>
        public string CodeVariable { get; set; }
        /// <summary>
        /// 函数统一返回值
        /// </summary>
        public string CodeReturn { get; set; }
        /// <summary>
        /// 函数变量类型
        ///最多9个参数
        ///（前面属于变量，最后一个属于返回值）
        /// </summary>
        public string VariableType { get; set; }

        public FunctionTemplate(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_FunctionTemplate, id);//public const string Config_FunctionTemplate = "cfg_FunctionTemplate"; 
			TemplateId = (string)dict["TemplateId"];
			TableName = (string)dict["TableName"];
			TableKey = (string)dict["TableKey"];
			TableCode = (string)dict["TableCode"];
			TableReturn = (string)dict["TableReturn"];
			CodePack = (string)dict["CodePack"];
			CodeVariable = (string)dict["CodeVariable"];
			CodeReturn = (string)dict["CodeReturn"];
			VariableType = (string)dict["VariableType"];
			InitData();
        }

        
        public FunctionTemplate(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_FunctionTemplate, cfg_id);//public const string Config_FunctionTemplate = "cfg_FunctionTemplate"; 
			TemplateId = (string)dict["TemplateId"];
			TableName = (string)dict["TableName"];
			TableKey = (string)dict["TableKey"];
			TableCode = (string)dict["TableCode"];
			TableReturn = (string)dict["TableReturn"];
			CodePack = (string)dict["CodePack"];
			CodeVariable = (string)dict["CodeVariable"];
			CodeReturn = (string)dict["CodeReturn"];
			VariableType = (string)dict["VariableType"];
			InitData();
        }

        public FunctionTemplate(Dictionary<string, object> dict)
        {
			TemplateId = (string)dict["TemplateId"];
			TableName = (string)dict["TableName"];
			TableKey = (string)dict["TableKey"];
			TableCode = (string)dict["TableCode"];
			TableReturn = (string)dict["TableReturn"];
			CodePack = (string)dict["CodePack"];
			CodeVariable = (string)dict["CodeVariable"];
			CodeReturn = (string)dict["CodeReturn"];
			VariableType = (string)dict["VariableType"];
			InitData();
        }
        #endregion
    }
}
