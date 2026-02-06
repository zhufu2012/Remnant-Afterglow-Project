using System.Collections.Generic;
using Godot;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 UnitData 用于 单位基础表,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class UnitData
    {
        #region 参数及初始化
        /// <summary>
        /// 实体id
        /// </summary>
        public int ObjectId { get; set; }
        /// <summary>
        /// 单位名称
        /// </summary>
        public string UnitName { get; set; }
        /// <summary>
        /// 动画类型列表
        ///注意默认移动方向是向上
        ///
        /// </summary>
        public List<int> AnimaTypeList { get; set; }
        /// <summary>
        /// 阴影图像
        /// </summary>
        public Texture2D ShadowSprite { get; set; }
        /// <summary>
        /// 阴影偏移
        /// </summary>
        public Vector2 ShadowOffset { get; set; }
        /// <summary>
        /// 是否有武器机壳
        /// </summary>
        public bool IsChassis { get; set; }
        /// <summary>
        /// 武器机壳是否
        ///跟随锁定目标旋转
        /// </summary>
        public bool IsRotate { get; set; }
        /// <summary>
        /// 武器机壳旋转速度
        /// </summary>
        public int RotationSpeed { get; set; }
        /// <summary>
        /// 武器机壳图片
        /// </summary>
        public Texture2D ChassisImg { get; set; }

        public UnitData(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_UnitData, id);//public const string Config_UnitData = "cfg_UnitData"; 
			ObjectId = (int)dict["ObjectId"];
			UnitName = (string)dict["UnitName"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			ShadowSprite = (Texture2D)dict["ShadowSprite"];
			ShadowOffset = (Vector2)dict["ShadowOffset"];
			IsChassis = (bool)dict["IsChassis"];
			IsRotate = (bool)dict["IsRotate"];
			RotationSpeed = (int)dict["RotationSpeed"];
			ChassisImg = (Texture2D)dict["ChassisImg"];
			InitData();
        }

        
        public UnitData(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_UnitData, cfg_id);//public const string Config_UnitData = "cfg_UnitData"; 
			ObjectId = (int)dict["ObjectId"];
			UnitName = (string)dict["UnitName"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			ShadowSprite = (Texture2D)dict["ShadowSprite"];
			ShadowOffset = (Vector2)dict["ShadowOffset"];
			IsChassis = (bool)dict["IsChassis"];
			IsRotate = (bool)dict["IsRotate"];
			RotationSpeed = (int)dict["RotationSpeed"];
			ChassisImg = (Texture2D)dict["ChassisImg"];
			InitData();
        }

        public UnitData(Dictionary<string, object> dict)
        {
			ObjectId = (int)dict["ObjectId"];
			UnitName = (string)dict["UnitName"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			ShadowSprite = (Texture2D)dict["ShadowSprite"];
			ShadowOffset = (Vector2)dict["ShadowOffset"];
			IsChassis = (bool)dict["IsChassis"];
			IsRotate = (bool)dict["IsRotate"];
			RotationSpeed = (int)dict["RotationSpeed"];
			ChassisImg = (Texture2D)dict["ChassisImg"];
			InitData();
        }
        #endregion
    }
}
