using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 BulletScene 用于 子弹场景数据,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class BulletScene
    {
        #region 参数及初始化
        /// <summary>        
        /// 子弹场景类型id
        /// </summary>
        public int BulletSceneTypeId { get; set; }
        /// <summary>        
        /// 场景路径
        ///注意场景必须是Node2D节点
        /// </summary>
        public string ScenePath { get; set; }

        public BulletScene(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BulletScene, id);//public const string Config_BulletScene = "cfg_BulletScene"; 
			BulletSceneTypeId = (int)dict["BulletSceneTypeId"];
			ScenePath = (string)dict["ScenePath"];
			InitData();
        }

        
        public BulletScene(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BulletScene, cfg_id);//public const string Config_BulletScene = "cfg_BulletScene"; 
			BulletSceneTypeId = (int)dict["BulletSceneTypeId"];
			ScenePath = (string)dict["ScenePath"];
			InitData();
        }

        public BulletScene(Dictionary<string, object> dict)
        {
			BulletSceneTypeId = (int)dict["BulletSceneTypeId"];
			ScenePath = (string)dict["ScenePath"];
			InitData();
        }
        #endregion
    }
}
