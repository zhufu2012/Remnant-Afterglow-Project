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
        /// 子弹Id
        /// </summary>
        public int BulletId { get; set; }
        /// <summary>
        /// 子弹类型 
        ///1 实体子弹
        ///2 抛射体子弹
        ///3 激光子弹
        /// </summary>
        public int SceneType { get; set; }
        /// <summary>
        /// 子弹标签
        ///是子弹运行轨迹脚本中子弹label的名称
        /// </summary>
        public string BulletLabel { get; set; }
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
        /// 是否中心对称
        /// </summary>
        public bool IsCenter { get; set; }
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
			BulletId = (int)dict["BulletId"];
			SceneType = (int)dict["SceneType"];
			BulletLabel = (string)dict["BulletLabel"];
			Logic = (string)dict["Logic"];
			CollideId = (int)dict["CollideId"];
			SoundId = (string)dict["SoundId"];
			ZIndex = (int)dict["ZIndex"];
			IsCenter = (bool)dict["IsCenter"];
			BulletPng = (Texture2D)dict["BulletPng"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			InitData();
        }

        
        public BulletData(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BulletData, cfg_id);//public const string Config_BulletData = "cfg_BulletData"; 
			BulletId = (int)dict["BulletId"];
			SceneType = (int)dict["SceneType"];
			BulletLabel = (string)dict["BulletLabel"];
			Logic = (string)dict["Logic"];
			CollideId = (int)dict["CollideId"];
			SoundId = (string)dict["SoundId"];
			ZIndex = (int)dict["ZIndex"];
			IsCenter = (bool)dict["IsCenter"];
			BulletPng = (Texture2D)dict["BulletPng"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			InitData();
        }

        public BulletData(Dictionary<string, object> dict)
        {
			BulletId = (int)dict["BulletId"];
			SceneType = (int)dict["SceneType"];
			BulletLabel = (string)dict["BulletLabel"];
			Logic = (string)dict["Logic"];
			CollideId = (int)dict["CollideId"];
			SoundId = (string)dict["SoundId"];
			ZIndex = (int)dict["ZIndex"];
			IsCenter = (bool)dict["IsCenter"];
			BulletPng = (Texture2D)dict["BulletPng"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			InitData();
        }
        #endregion
    }
}
