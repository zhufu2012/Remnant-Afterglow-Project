using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 BulletFire 用于 子弹脚本开火行为,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class BulletFire
    {
        #region 参数及初始化
        /// <summary>        
        /// 子弹开火行为标签
        ///也是脚本中fire的label的名称
        /// </summary>
        public string FireLabel { get; set; }
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

        public BulletFire(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BulletFire, id);//public const string Config_BulletFire = "cfg_BulletFire"; 
			FireLabel = (string)dict["FireLabel"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			Logic = (string)dict["Logic"];
			InitData();
        }

        
        public BulletFire(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BulletFire, cfg_id);//public const string Config_BulletFire = "cfg_BulletFire"; 
			FireLabel = (string)dict["FireLabel"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			Logic = (string)dict["Logic"];
			InitData();
        }

        public BulletFire(Dictionary<string, object> dict)
        {
			FireLabel = (string)dict["FireLabel"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			Logic = (string)dict["Logic"];
			InitData();
        }
        #endregion
    }
}
