using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 BulletAction 用于 子弹脚本行为,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class BulletAction
    {
        #region 参数及初始化
        /// <summary>        
        /// 子弹行为标签
        ///也是脚本中action的label
        /// </summary>
        public string ActionLabel { get; set; }
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

        public BulletAction(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BulletAction, id);//public const string Config_BulletAction = "cfg_BulletAction"; 
			ActionLabel = (string)dict["ActionLabel"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			Logic = (string)dict["Logic"];
			InitData();
        }

        
        public BulletAction(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BulletAction, cfg_id);//public const string Config_BulletAction = "cfg_BulletAction"; 
			ActionLabel = (string)dict["ActionLabel"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			Logic = (string)dict["Logic"];
			InitData();
        }

        public BulletAction(Dictionary<string, object> dict)
        {
			ActionLabel = (string)dict["ActionLabel"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			Logic = (string)dict["Logic"];
			InitData();
        }
        #endregion
    }
}
