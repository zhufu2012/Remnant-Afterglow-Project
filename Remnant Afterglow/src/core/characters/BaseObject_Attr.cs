using GameLog;
using Godot;
using ManagedAttributes;
using System.Collections.Generic;
using System.Linq;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 这里实现实体属性相关代码
    /// </summary>
    public partial class BaseObject : Area2D, IPoolItem
    {
        /// <summary>
        /// 属性容器
        /// </summary>
        public ManagAttrCon attributeContainer = new ManagAttrCon();
        /// <summary>
        /// 属性实体配置列表-祝福注释-可以优化
        /// </summary>
        /// <param name="id"></param>
        public Dictionary<int, AttributeData> attrDict = new Dictionary<int, AttributeData>();

        /// <summary>
        /// 周期事件-时间  <事件顺序id,事件下一次触发时间>
        /// </summary>
        public Dictionary<int, ulong> cycleDict = new Dictionary<int, ulong>();


        /// <summary>
        /// 初始化属性-可优化
        /// </summary>
        /// <param name="objectId">实体id</param>
        /// <param name="TempLateIdList">属性模板id列表</param>
        public virtual void InitAttr(int objectId)
        {
            foreach (int TempLateId in baseData.TempLateList)//模板属性-合并多个模板的属性
            {
                AttributeTemplate template = ConfigCache.GetAttributeTemplate(TempLateId);
                attributeContainer.Merge(template.GetAttrCon(), template.IsCover);
            }
            List<AttributeData> attrList = ConfigCache.GetAttrList(objectId);
            foreach (AttributeData attr in attrList)
            {
                attributeContainer.Add(attr.GetAttr());
            }
            foreach (var attr in attributeContainer.Attributes)
            {
                int AttributeId = attr.Key;
                int AttrObjectId = attr.Value.IsTemplateAttr ? attr.Value.TemplateObjectId : objectId;//是否为模板属性,为模板属性使用模板实体id
                AttributeData attributeData = ConfigCache.GetAttributeData(AttrObjectId + "_" + attr.Key);
                AttrData attribute = attr.Value as AttrData;
                attribute.AttributeUpdated += (IAttrData attribute) =>
                {
                    List<List<int>> AttrEventIdList = attributeData.AttrEventIdList;//事件触发列表
                    for (int i = 0; i < AttrEventIdList.Count; i++)
                    {
                        List<int> paramList = AttrEventIdList[i];
                        switch (paramList[0])
                        {
                            case 1://等于某值触发
                                if ((int)attribute.GetFloat(AttrDataType.Value) == paramList[1])
                                    RunAttrEvent(paramList.Last(), 1, AttributeId);
                                break;
                            case 2://大于某值触发 （参数1是触发值）
                                if (attribute.GetFloat(AttrDataType.Value) > paramList[1])
                                    RunAttrEvent(paramList.Last(), 1, AttributeId);
                                break;
                            case 3://小于某值触发 （参数1是触发值）
                                if (attribute.GetFloat(AttrDataType.Value) < paramList[1])
                                    RunAttrEvent(paramList.Last(), 1, AttributeId);
                                break;
                            case 4://大于等于某值触发 （参数1是触发值）
                                if (attribute.GetFloat(AttrDataType.Value) >= paramList[1])
                                    RunAttrEvent(paramList.Last(), 1, AttributeId);
                                break;
                            case 5://小于等于某值触发 （参数1是触发值）
                                if (attribute.GetFloat(AttrDataType.Value) <= paramList[1])
                                    RunAttrEvent(paramList.Last(), 1, AttributeId);
                                break;
                            case 6://7 不等于某值触发 （参数1是触发值）
                                if (attribute.GetFloat(AttrDataType.Value) != paramList[1])
                                    RunAttrEvent(paramList.Last(), 1, AttributeId);
                                break;
                            case 100://随机触发（参数1是触发值，参数2是最大随机值，随机数在1到参数2之间，小于触发值就触发）
                                if (Utils.Random.RandomRangeInt(1, paramList[2]) < paramList[1])
                                    RunAttrEvent(paramList.Last(), 1, AttributeId);
                                break;
                            default: //其他事件不触发
                                break;
                        }
                    }
                };
                attrDict[attr.Key] = attributeData;
            }
            StartRunAttrEvent();//实体创建后 按顺序触发各属性的开局事件
        }



        /// <summary>
        /// 获取属性本身
        /// </summary>
        /// <param name="AttributeId"></param>
        /// <returns></returns>
        public AttrData? FindAttribute(int AttributeId)
        {
            return attributeContainer[AttributeId] as AttrData;
        }


        /// <summary>
        /// 获取属性的当前值，考虑修饰器的影响
        /// </summary>
        /// <param name="AttributeId"></param>
        /// <returns></returns>
        public float GetAttrNow(int AttributeId)
        {
            if (attrDict.ContainsKey(AttributeId))//有该属性
            {
                return (attributeContainer[AttributeId] as AttrData).Get<float>(AttrDataType.Value);
            }
            else
            {
                Log.Error($"错误！属性id:{AttributeId}");
                return 0f;
            }
        }


        /// <summary>
        /// 获取属性的某个值
        /// </summary>
        /// <param name="AttributeId"></param>
        /// <param name="attributeValueType"></param>
        /// <returns></returns>
        public float GetAttrValue(int AttributeId, AttrDataType attributeValueType)
        {
            if (attrDict.ContainsKey(AttributeId))//有该属性
            {
                return attributeContainer[AttributeId].Get<float>(attributeValueType);
            }
            else
            {
                Log.Error($"错误！属性id:{AttributeId}");
                return 0f;
            }
        }




        /// <summary>
        /// 检查是否有对应属性
        /// </summary>
        /// <param name="AttributeId"></param>
        /// <returns></returns>
        public bool IsAttributeData(int AttributeId)
        {
            return attributeContainer[AttributeId] == null;
        }

    }
}
