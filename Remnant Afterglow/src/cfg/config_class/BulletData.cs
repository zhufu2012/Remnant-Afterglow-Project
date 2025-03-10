using System.Collections.Generic;
using Godot;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 BulletData 用于 子弹基础数据表,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class BulletData
    {
        #region 参数及初始化
        /// <summary>        
        /// 子弹标签
        ///也是子弹脚本中子弹label的名称
        /// </summary>
        public string BulletLabel { get; set; }
        /// <summary>        
        /// 子弹场景类型id：
        ///能量子弹：1
        ///激光子弹：2
        ///导弹：3
        ///cfg_BulletScene_子弹场景数据的id
        /// </summary>
        public int SceneType { get; set; }
        /// <summary>        
        /// 子弹运行轨迹脚本名称
        ///BulletML脚本名称
        ///根路径\data\config\bullet\
        /// </summary>
        public string Logic { get; set; }
        /// <summary>        
        /// 子弹碰撞体id
        /// </summary>
        public int CollideId { get; set; }
        /// <summary>        
        /// 命中音效id
        ///不写表示无音效
        /// </summary>
        public string SoundId { get; set; }
        /// <summary>        
        /// 子弹图层
        /// </summary>
        public int ZIndex { get; set; }
        /// <summary>        
        /// 子弹图
        /// </summary>
        public Texture2D BulletPng { get; set; }
        /// <summary>        
        /// 动画类型列表
        ///cfg_AnimaExplode_子弹动画id列表
        /// </summary>
        public List<int> AnimaTypeList { get; set; }

        public BulletData(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BulletData, id);//public const string Config_BulletData = "cfg_BulletData"; 
			BulletLabel = (string)dict["BulletLabel"];
			SceneType = (int)dict["SceneType"];
			Logic = (string)dict["Logic"];
			CollideId = (int)dict["CollideId"];
			SoundId = (string)dict["SoundId"];
			ZIndex = (int)dict["ZIndex"];
			BulletPng = (Texture2D)dict["BulletPng"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			InitData();
        }

        
        public BulletData(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BulletData, cfg_id);//public const string Config_BulletData = "cfg_BulletData"; 
			BulletLabel = (string)dict["BulletLabel"];
			SceneType = (int)dict["SceneType"];
			Logic = (string)dict["Logic"];
			CollideId = (int)dict["CollideId"];
			SoundId = (string)dict["SoundId"];
			ZIndex = (int)dict["ZIndex"];
			BulletPng = (Texture2D)dict["BulletPng"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			InitData();
        }

        public BulletData(Dictionary<string, object> dict)
        {
			BulletLabel = (string)dict["BulletLabel"];
			SceneType = (int)dict["SceneType"];
			Logic = (string)dict["Logic"];
			CollideId = (int)dict["CollideId"];
			SoundId = (string)dict["SoundId"];
			ZIndex = (int)dict["ZIndex"];
			BulletPng = (Texture2D)dict["BulletPng"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			InitData();
        }
        #endregion
    }
}
