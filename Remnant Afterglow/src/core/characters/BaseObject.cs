using GameLog;
using Godot;
using Godot.Community.ManagedAttributes;
using System.Collections.Generic;
using System.Linq;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 敌人，炮塔等对象的基类,实现了武器位搭载接口
    /// </summary>
    public partial class BaseObject : Node2D
    {
        /// <summary>
        /// 属性容器
        /// </summary>
        public ManagedAttributeContainer attributeContainer = new ManagedAttributeContainer();

        /// <summary>
        /// 属性实体配置列表 
        /// </summary>
        /// <param name="id"></param>
        public List<AttributeData> attrList = new List<AttributeData>();

        /// <summary>
        /// 周期事件-时间  <事件顺序id,事件下一次触发时间>
        /// </summary>
        public Dictionary<int, ulong> cycleDict = new Dictionary<int, ulong>();

        /// <summary>
        /// 当前帧数
        /// </summary>
        public ulong NowTick = 0;

        /// <summary>
        /// 实体id
        /// </summary>
        public int ObjectId;

        /// <summary>
        /// 实体类型
        /// </summary>
        public BaseObjectType object_type;

        /// <summary>
        /// 组名称
        /// </summary>
        public string GroupName;

        public override void _PhysicsProcess(double delta)
        {
            NowTick += 1;
            Update(NowTick);
        }

        /// <summary>
        /// 初始化属性
        /// </summary>
        /// <param name="type">实体类型</param>
        /// <param name="objectId">实体id</param>
        public void InitAttr(BaseObjectType type, int objectId)
        {
            InitAttr(type, objectId, new List<int>());
        }

        /// <summary>
        /// 初始化属性
        /// </summary>
        /// <param name="type">实体类型</param>
        /// <param name="objectId">实体id</param>
        /// <param name="TempLateIdList">属性模板id列表</param>
        public void InitAttr(BaseObjectType type, int objectId, List<int> TempLateIdList)
        {
            object_type = type;
            ObjectId = objectId;
            foreach (int TempLateId in TempLateIdList)//模板属性
            {
                AttributeTemplate template = ConfigCache.GetAttributeTemplate(TempLateId);
                attributeContainer.Merge(template.attributeContainer, template.IsCover);
            }
            //祝福注释-还有覆盖属性需要加

            foreach (var attr in attributeContainer.Attributes)
            {
                AttributeBase attributeBase = ConfigCache.GetAttributeBase(attr.Key);//属性默认配置
                AttributeData attributeData = ConfigCache.GetAttributeData((int)type + "_" + objectId + "_" + attr.Key);
                FloatManagedAttribute attribute = attr.Value as FloatManagedAttribute;
                attribute.AttributeUpdated += (IManagedAttribute attribute) =>
                {

                    List<List<int>> AttrEventIdList = attributeData.AttrEventIdList;//事件触发列表
                    for (int i = 0; i < AttrEventIdList.Count; i++)
                    {
                        switch (AttrEventIdList[i][0])
                        {
                            case 2://等于某值触发
                                if (attribute.Get<float>(AttributeValueType.Value) == AttrEventIdList[i][1])
                                    AddEvent(AttrEventIdList[i].Last(), attributeBase.AttributeId);
                                break;
                            case 3://大于某值触发 （参数1是触发值）
                                if (attribute.Get<float>(AttributeValueType.Value) > AttrEventIdList[i][1])
                                    AddEvent(AttrEventIdList[i].Last(), attributeBase.AttributeId);
                                break;
                            case 4://小于某值触发 （参数1是触发值）
                                if (attribute.Get<float>(AttributeValueType.Value) < AttrEventIdList[i][1])
                                    AddEvent(AttrEventIdList[i].Last(), attributeBase.AttributeId);
                                break;
                            case 5://大于等于某值触发 （参数1是触发值）
                                if (attribute.Get<float>(AttributeValueType.Value) >= AttrEventIdList[i][1])
                                    AddEvent(AttrEventIdList[i].Last(), attributeBase.AttributeId);
                                break;
                            case 6://小于等于某值触发 （参数1是触发值）
                                if (attribute.Get<float>(AttributeValueType.Value) <= AttrEventIdList[i][1])
                                    AddEvent(AttrEventIdList[i].Last(), attributeBase.AttributeId);
                                break;
                            case 7://周期性达到触发 （参数1是周期（帧））
                                break;
                            case 8://随机触发（参数1是触发值，参数2是最大随机值，随机数在1到参数2之间，小于触发值就触发）
                                break;
                            default: break;
                        }
                    }
                };

                attrList.Add(attributeData);
            }
            StartRunEvent();//兵种创建后 按顺序触发各属性的开局事件
        }
        /// <summary>
        /// 实体更新
        /// </summary>
        /// <param name="tick"></param>
        public void Update(ulong tick)
        {
            attributeContainer.Update(tick);
        }

        /// <summary>
        /// 属性创建后就触发的事件 AttrEventTouchType.StartRun
        /// </summary>
        private void StartRunEvent()
        {
            foreach (AttributeData attributeData in attrList)
            {
                List<int> AttrEventIdList = attributeData.StartEventIdList;//添加属性后运行
                for (int i = 0; i < AttrEventIdList.Count; i++)
                {
                    AddEvent(AttrEventIdList[i], attributeData.AttributeId);
                }
            }
        }

        public AttributeData FindAttributeData(int AttributeId)
        {
            // 使用LINQ查询id为4的AttributeData
            var result = attrList.FirstOrDefault(ad => ad.AttributeId == 4);
            if (result != null)
            {
                return result;
            }
            else
            {
                Log.Error($"错误！不存在属性:{AttributeId}");
                return result;
            }
        }

        /// <summary>
        /// 添加事件
        /// </summary>
        /// <param name="event_id"></param>
        public void AddEvent(int event_id, int attr_id)
        {
            AttributeEvent unitAttrEvent = new AttributeEvent(event_id);
            switch (unitAttrEvent.EventType)
            {
                case AttrEventType.LogEvent:
                    Log.Print($"时间:{NowTick},事件id:{event_id},事件描述{unitAttrEvent.AttrEventDescribe}");
                    break;
                case AttrEventType.ModifierEvent:
                    List<List<float>> ParamList = unitAttrEvent.ParamList;
                    for (int i = 0; i < ParamList.Count; i++)
                    {
                        List<float> RowParam = ParamList[i];
                        if (FindAttributeData((int)RowParam[0]) != null)//是否存在该属性
                        {
                            //FloatManagedAttribute attr = (FloatManagedAttribute)attributeContainer[""];
                        }
                    }
                    /*AttributeData attData = attrDict[(int)RowParam[0])];
                    FloatManagedAttribute attr = (FloatManagedAttribute)attributeContainer[attData.ShowName];
                    var modifier = new ManagedAttributeModifier
                    {
                        ExpiryTick = NowTick + unitAttrEvent.DelayTime, // 设置过期帧
                        for(int i = 0;i<unitAttrEvent.ParamList.Count;i++)
                        {
                            ModifierValues[]
                        }
                        ModifierValues = new Dictionary<AttributeValueType, ManagedAttributeModifierValue>
                        {
                            { AttributeValueType.Value, new ManagedAttributeModifierValue { Add = 50, Multiplier = 1.1f } }
                        }
                    };
                    attr.AddModifier(modifier);//添加属性修饰器*/
                    break;
                case AttrEventType.Event:
                    break;
                case AttrEventType.Sound:
                    break;
                case AttrEventType.Animation:
                    break;
                case AttrEventType.ScriptAnimation:
                    break;
                default: break;
            }
        }
    }
}