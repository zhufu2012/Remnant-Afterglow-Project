using System.Collections.Generic;
using Godot;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 SpeciallyEffect 用于 特效配置,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class SpeciallyEffect
    {
        #region 参数及初始化
        /// <summary>        
        /// 特效id
        /// </summary>
        public int KetId { get; set; }
        /// <summary>        
        /// 特效名称
        /// </summary>
        public int Key2Id { get; set; }
        /// <summary>        
        /// 特效SpriteFrames
        ///资源路径
        /// </summary>
        public Texture2D CopyId { get; set; }

        public SpeciallyEffect(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_SpeciallyEffect, id);//public const string Config_SpeciallyEffect = "cfg_SpeciallyEffect"; 
			KetId = (int)dict["KetId"];
			Key2Id = (int)dict["Key2Id"];
			CopyId = (Texture2D)dict["CopyId"];
			InitData();
        }

        
        public SpeciallyEffect(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_SpeciallyEffect, cfg_id);//public const string Config_SpeciallyEffect = "cfg_SpeciallyEffect"; 
			KetId = (int)dict["KetId"];
			Key2Id = (int)dict["Key2Id"];
			CopyId = (Texture2D)dict["CopyId"];
			InitData();
        }

        public SpeciallyEffect(Dictionary<string, object> dict)
        {
			KetId = (int)dict["KetId"];
			Key2Id = (int)dict["Key2Id"];
			CopyId = (Texture2D)dict["CopyId"];
			InitData();
        }
        #endregion
    }
}
