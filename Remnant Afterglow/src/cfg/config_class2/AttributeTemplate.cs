using GameLog;
using Godot.Community.ManagedAttributes;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类2 AttributeTemplate 用于 属性模板表,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class AttributeTemplate
    {
        public ManagedAttributeContainer attributeContainer = new ManagedAttributeContainer();
        /// <summary>
        /// 初始化数据-构造函数后运行
        /// </summary>
        public void InitData()
        {
        }

        /// <summary>
        /// 初始化数据-构造函数后运行
        /// </summary>
        public void InitData2()
        {
            List<Dictionary<string, object>> QueryList = ConfigLoadSystem.QueryCfgAllLine(ConfigConstant.Config_AttributeData,
new Dictionary<string, object> { { "ObjectType", ObjectType }, { "ObjectId", ObjectId } });//属性列表
            if (QueryList.Count == 0)
            {
                Log.Print($"错误，没有对应属性！表:{ConfigConstant.Config_AttributeData},主键{ObjectType}, {ObjectId}");
            }
            else
            {
                for (int i = 0; i < QueryList.Count; i++)
                {
                    int AttributeId = (int)QueryList[i]["AttributeId"];//属性id
                    AttributeData attrData = new AttributeData(ObjectType + "_" + ObjectId + "_" + AttributeId);
                    attrData.InitData2();
                    FloatManagedAttribute attribute = attrData.GetAttr();//实体属性
                    bool isCon = attributeContainer.Add(attribute);
                    if (!isCon)//添加不成功，说明存在重复属性
                        Log.Error($"错误属性模板在出现重复属性! 模板id:{TempLateId},重复属性id:{AttributeId}");
                }
            }
        }
    }
}
