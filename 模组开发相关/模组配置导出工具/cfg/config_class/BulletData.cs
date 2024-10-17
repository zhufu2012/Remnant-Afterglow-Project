using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 BulletData 用于 子弹基础表,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class BulletData
    {
        #region 参数及初始化
        /// <summary>        
        /// 子弹ID
        /// </summary>
        public int BulletId { get; set; }
        /// <summary>        
        /// 子弹名称
        /// </summary>
        public string BulletName { get; set; }
        /// <summary>        
        /// 子弹类型：
        ///实体子弹：1
        ///激光子弹：2
        ///纯伤害：3
        /// </summary>
        public int Type { get; set; }
        /// <summary>        
        /// 属性模板列表
        ///属性是cfg_AttributeTemplate_属性模板表与cfg_AttributeData_实体属性表覆盖的结果
        /// </summary>
        public List<int> TempLateList { get; set; }
        /// <summary>        
        /// 实体id
        ///用于属性等配置
        ///(要求唯一)
        /// </summary>
        public int ObjectId { get; set; }
        /// <summary>        
        /// 动画类型列表
        /// </summary>
        public List<int> AnimaTypeList { get; set; }
        /// <summary>        
        /// 造成伤害后击退值区间
        ///如果发射子弹,则按每发子弹算击退
        ///格式为[value]或者[min,max]
        /// </summary>
        public List<int> RepelRange { get; set; }
        /// <summary>        
        /// 子弹偏移角度区间
        ///用于设置子弹偏移朝向, 该属性和射半径效果类似, 但与其不同的是, 散射半径是用来控制枪口朝向的, 而该属性是控制子弹朝向的, 可用于制作霰弹枪子弹效果
        ///格式为[value]或者[min,max]
        /// </summary>
        public List<int> DeviationAngleRange { get; set; }
        /// <summary>        
        /// 子弹初速度区间
        ///格式为[value]或者[min,max]
        /// </summary>
        public List<int> SpeedRange { get; set; }
        /// <summary>        
        /// 子弹最大存在时间，
        ///单位：秒
        ///如果值小于等于0时子弹无限期存在
        ///只有Type为1时才需要填写
        ///格式为[value]或者[min,max]
        /// </summary>
        public List<int> LifeTimeRange { get; set; }
        /// <summary>        
        /// 子弹最大飞行距离区间
        ///格式为[value]或者[min,max]
        /// </summary>
        public List<int> DistanceRange { get; set; }
        /// <summary>        
        /// 初始纵轴速度区间
        ///只有Type为1时有效
        ///格式为[value]或者[min,max]
        /// </summary>
        public List<int> VerticalSpeed { get; set; }
        /// <summary>        
        /// 反弹次数区间
        ///只有Type为1或2时有效
        ///格式为[value]或者[min,max]
        /// </summary>
        public List<int> BounceCount { get; set; }
        /// <summary>        
        /// 子弹穿透次数区间
        ///只有Type为1时有效
        ///格式为[value]或者[min,max]
        /// </summary>
        public List<int> Penetration { get; set; }

        public BulletData(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BulletData, id);//public const string Config_BulletData = "cfg_BulletData"; 
			BulletId = (int)dict["BulletId"];
			BulletName = (string)dict["BulletName"];
			Type = (int)dict["Type"];
			TempLateList = (List<int>)dict["TempLateList"];
			ObjectId = (int)dict["ObjectId"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			RepelRange = (List<int>)dict["RepelRange"];
			DeviationAngleRange = (List<int>)dict["DeviationAngleRange"];
			SpeedRange = (List<int>)dict["SpeedRange"];
			LifeTimeRange = (List<int>)dict["LifeTimeRange"];
			DistanceRange = (List<int>)dict["DistanceRange"];
			VerticalSpeed = (List<int>)dict["VerticalSpeed"];
			BounceCount = (List<int>)dict["BounceCount"];
			Penetration = (List<int>)dict["Penetration"];
			InitData();
        }

        
        public BulletData(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BulletData, cfg_id);//public const string Config_BulletData = "cfg_BulletData"; 
			BulletId = (int)dict["BulletId"];
			BulletName = (string)dict["BulletName"];
			Type = (int)dict["Type"];
			TempLateList = (List<int>)dict["TempLateList"];
			ObjectId = (int)dict["ObjectId"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			RepelRange = (List<int>)dict["RepelRange"];
			DeviationAngleRange = (List<int>)dict["DeviationAngleRange"];
			SpeedRange = (List<int>)dict["SpeedRange"];
			LifeTimeRange = (List<int>)dict["LifeTimeRange"];
			DistanceRange = (List<int>)dict["DistanceRange"];
			VerticalSpeed = (List<int>)dict["VerticalSpeed"];
			BounceCount = (List<int>)dict["BounceCount"];
			Penetration = (List<int>)dict["Penetration"];
			InitData();
        }

        public BulletData(Dictionary<string, object> dict)
        {
			BulletId = (int)dict["BulletId"];
			BulletName = (string)dict["BulletName"];
			Type = (int)dict["Type"];
			TempLateList = (List<int>)dict["TempLateList"];
			ObjectId = (int)dict["ObjectId"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			RepelRange = (List<int>)dict["RepelRange"];
			DeviationAngleRange = (List<int>)dict["DeviationAngleRange"];
			SpeedRange = (List<int>)dict["SpeedRange"];
			LifeTimeRange = (List<int>)dict["LifeTimeRange"];
			DistanceRange = (List<int>)dict["DistanceRange"];
			VerticalSpeed = (List<int>)dict["VerticalSpeed"];
			BounceCount = (List<int>)dict["BounceCount"];
			Penetration = (List<int>)dict["Penetration"];
			InitData();
        }
        #endregion
    }
}
