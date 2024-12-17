using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 BulletScript 用于 子弹脚本配置,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class BulletScript
    {
        #region 参数及初始化
        /// <summary>        
        /// 子弹脚本
        ///也是脚本中bullet的label
        /// </summary>
        public string BulletLabel { get; set; }
        /// <summary>        
        /// 动画类型列表
        ///cfg_AnimaExplode_子弹动画id列表
        /// </summary>
        public List<int> AnimaTypeList { get; set; }
        /// <summary>        
        /// 子弹运行轨迹脚本名称
        ///BulletML脚本名称
        ///根路径\data\config\bullet
        /// </summary>
        public string Logic { get; set; }

        public BulletScript(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BulletScript, id);//public const string Config_BulletScript = "cfg_BulletScript"; 
			BulletLabel = (string)dict["BulletLabel"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			Logic = (string)dict["Logic"];
			InitData();
        }

        
        public BulletScript(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BulletScript, cfg_id);//public const string Config_BulletScript = "cfg_BulletScript"; 
			BulletLabel = (string)dict["BulletLabel"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			Logic = (string)dict["Logic"];
			InitData();
        }

        public BulletScript(Dictionary<string, object> dict)
        {
			BulletLabel = (string)dict["BulletLabel"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			Logic = (string)dict["Logic"];
			InitData();
        }
        #endregion
    }
}
