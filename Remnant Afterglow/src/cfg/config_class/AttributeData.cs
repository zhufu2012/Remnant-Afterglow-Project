using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 AttributeData 用于 实体属性表,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class AttributeData
    {
        #region 参数及初始化
        /// <summary>
        /// 实体id
        ///单位或者炮塔或者建筑等
        ///
        ///给属性模板使用的是负数实体id
        /// </summary>
        public int ObjectId { get; set; }
        /// <summary>
        /// 属性id
        /// </summary>
        public int AttributeId { get; set; }
        /// <summary>
        /// 初始值
        /// </summary>
        public float StartValue { get; set; }
        /// <summary>
        /// 最大值
        /// </summary>
        public float Max { get; set; }
        /// <summary>
        /// 最小值
        /// </summary>
        public float Min { get; set; }
        /// <summary>
        /// 再生值
        /// </summary>
        public float Regen { get; set; }
        /// <summary>
        /// 添加时触发事件id列表
        /// </summary>
        public List<int> AddEventIdList { get; set; }
        /// <summary>
        /// 移除时触发事件id列表
        /// </summary>
        public List<int> RemoveEventIdList { get; set; }
        /// <summary>
        /// 事件触发id列表
        ///（触发类型，触发参数1，触发参数2，事件id）
        ///1 等于某值触发（参数1是触发值）
        ///2 大于某值触发 （参数1是触发值）
        ///3 小于某值触发 （参数1是触发值）
        ///4 大于等于某值触发 （参数1是触发值）
        ///5 小于等于某值触发 （参数1是触发值）
        ///6 不等于某值触发 （参数1是触发值）
        ///
        ///100 随机触发（参数1是触发值，参数2是最大随机值，随机数在1到参数2之间，小于触发值就触发）
        ///举例:(3,100,0,0,1,2,3,4,5)
        ///意思是：当属性当前值等于100时，触发事件 1，2，3，4，5 按顺序运行
        /// </summary>
        public List<List<int>> AttrEventIdList { get; set; }

        public AttributeData(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_AttributeData, id);//public const string Config_AttributeData = "cfg_AttributeData"; 
			ObjectId = (int)dict["ObjectId"];
			AttributeId = (int)dict["AttributeId"];
			StartValue = (float)dict["StartValue"];
			Max = (float)dict["Max"];
			Min = (float)dict["Min"];
			Regen = (float)dict["Regen"];
			AddEventIdList = (List<int>)dict["AddEventIdList"];
			RemoveEventIdList = (List<int>)dict["RemoveEventIdList"];
			AttrEventIdList = (List<List<int>>)dict["AttrEventIdList"];
			InitData();
        }

        
        public AttributeData(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_AttributeData, cfg_id);//public const string Config_AttributeData = "cfg_AttributeData"; 
			ObjectId = (int)dict["ObjectId"];
			AttributeId = (int)dict["AttributeId"];
			StartValue = (float)dict["StartValue"];
			Max = (float)dict["Max"];
			Min = (float)dict["Min"];
			Regen = (float)dict["Regen"];
			AddEventIdList = (List<int>)dict["AddEventIdList"];
			RemoveEventIdList = (List<int>)dict["RemoveEventIdList"];
			AttrEventIdList = (List<List<int>>)dict["AttrEventIdList"];
			InitData();
        }

        public AttributeData(Dictionary<string, object> dict)
        {
			ObjectId = (int)dict["ObjectId"];
			AttributeId = (int)dict["AttributeId"];
			StartValue = (float)dict["StartValue"];
			Max = (float)dict["Max"];
			Min = (float)dict["Min"];
			Regen = (float)dict["Regen"];
			AddEventIdList = (List<int>)dict["AddEventIdList"];
			RemoveEventIdList = (List<int>)dict["RemoveEventIdList"];
			AttrEventIdList = (List<List<int>>)dict["AttrEventIdList"];
			InitData();
        }
        #endregion
    }
}
