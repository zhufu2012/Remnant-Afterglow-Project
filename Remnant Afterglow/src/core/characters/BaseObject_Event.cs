using BulletMLLib.SharedProject;
using GameLog;
using Godot;
using Godot.Collections;
using ManagedAttributes;
using System.Collections.Generic;
using System.Linq;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 事件类型
    /// #BASEVALUE 是 0
    /// 0 仅输出文字，调试用（输出事件id:触发时间戳:AttrEventDescribe字段）
    /// 1 修饰器事件 为属性增加修饰器（加属性或者改属性，可永久或者临时）
    /// 2 触发事件的事件 触发这个表的其他事件(可以用于延时触发其他事件，别写自己的id)
    /// 3 播放音效事件 播放音效
    /// 4 播放动画事件 播放动画
    /// 5 播放脚本动画
    /// </summary>
    public enum EventType
    {
        AttrEvent = 1,// 属性事件 AttributeData-Id
        BuffEvent = 2// Buff事件 BuffData—Id
    }
    /// <summary>
    /// 这里实现实体的事件相关代码
    /// </summary>
    public partial class BaseObject : Area2D, IPoolItem
    {
        /// <summary>
        /// 子弹碰撞
        /// </summary>
        /// <param name="bodyRid"></param>
        /// <param name="body"></param>
        /// <param name="bodyShapeIndex"></param>
        /// <param name="localShapeIndex"></param>
        public virtual void Area2DBodyShapeEntered(Rid bodyRid, Node2D body, long bodyShapeIndex, long localShapeIndex)
        {
            if (IsDestroyed)//死亡就不继续了
                return;
            switch (object_type)
            {
                case BaseObjectType.BaseBuild:
                    BuildBase buildBase = (BuildBase)this;
                    if (buildBase.buildData.SubType == 1)//埋地建筑
                    {
                        return;
                    }
                    break;
                case BaseObjectType.BaseTower:
                    TowerBase towerBase = (TowerBase)this;
                    if(towerBase.buildData.SubType == 1)//埋地建筑
                    {
                        return;
                    }
                    break;
            }

            EntityBullet bullet = MapCopy.Instance.bulletManager.bulletDict[bodyRid];
            if (bullet.Used)//子弹处于可使用状态
            {
                if (bullet.Camp != Camp)//非同阵营
                {
                    //给实体加上击中Buff
                    handler.SelfAddBuffList(bullet.bulletLogic.AddBuffList);
                    attributeContainer.ApplyDamage(
                        bullet.bulletLogic.ShieldHarm,
                        bullet.bulletLogic.ArmourHarm,
                        bullet.bulletLogic.StructureHarm,
                        bullet.bulletLogic.ElementHarm);

                    if (attributeContainer.IsDead())
                    {
                        IsDestroyed = true; // 已经被摧毁
                        DieEvent();
                    }
                    bullet.Used = false;//准备移除子弹
                }
            }
        }


        /// <summary>
        /// 实体死亡事件
        /// </summary>
        public void DieEvent()
        {
            switch (object_type)
            {
                case BaseObjectType.BaseBuild://建筑
                    BuildBase buildBase = (BuildBase)this;
                    ObjectManager.Instance.RemoveBuild(Logotype, mapPos, buildBase.buildData);
                    break;
                case BaseObjectType.BaseTower://炮塔
                    TowerBase towerBase = (TowerBase)this;
                    ObjectManager.Instance.RemoveTower(Logotype, mapPos, towerBase.buildData);
                    break;
                case BaseObjectType.BaseUnit://单位
                    ObjectManager.Instance.RemoveUnit(Logotype);
                    break;
                case BaseObjectType.BaseWorker://无人机
                    ObjectManager.Instance.RemoveWorker(Logotype);
                    break;
                default:
                    break;
            }
            QueueFree();
        }


        /// <summary>
        /// 实体-运行事件
        /// </summary>
        /// <param name="event_id">事件id</param>
        /// <param name="type">事件类型 1 为属性  2为 buff</param>
        /// <param name="keyId">根据事件类型来确定的
        /// </param>
        public void RunAttrEvent(int event_id, int type, int keyId)
        {
            AttrEvent unitAttrEvent = ConfigCache.GetAttrEvent(event_id);//事件配置
            switch (unitAttrEvent.EventType)
            {
                case 0://输出事件数据
                    Log.Print($"实体id:{ObjectId},时间:{NowTick},事件id:{event_id},事件类型{type},触发id{keyId},事件描述{unitAttrEvent.AttrEventDescribe}");
                    break;
                case 1: // 1: 添加属性
                    {
                        // 参数1: 属性ObjectId, 参数2: 属性AttributeId
                        int objectId = unitAttrEvent.Param1;
                        int attributeId = unitAttrEvent.Param2;

                        // 从配置获取属性数据
                        AttributeData attributeData = ConfigCache.GetAttributeData($"{objectId}_{attributeId}");

                        if (attributeData != null)
                        {
                            // 创建属性实例并添加到容器
                            AttrData attribute = attributeData.GetAttr();
                            attributeContainer.Add(attribute);
                        }
                        else
                        {
                            Log.Error($"添加属性失败: 未找到配置 objectId={objectId}, attributeId={attributeId}");
                        }
                    }
                    break;
                case 2: // 2: 删除属性
                    {
                        if (attributeContainer.Attributes.ContainsKey(unitAttrEvent.Param1))
                        {
                            attributeContainer.Remove(unitAttrEvent.Param1);
                        }
                        else
                        {
                            Log.Error($"删除属性失败: 未找到属性 attributeId={unitAttrEvent.Param1}");
                        }
                    }
                    break;
                case 3: // 3: 修改属性
                    {
                        // 参数1: 属性AttributeId, 参数2: 值类型, 参数3: 值
                        int attributeId = unitAttrEvent.Param1;
                        AttrDataType valueType = (AttrDataType)unitAttrEvent.Param2;
                        float value = unitAttrEvent.Param3;
                        if (attributeContainer.Attributes.ContainsKey(unitAttrEvent.Param1))
                        {
                            attributeContainer[attributeId].Set(value, valueType);
                        }
                        else
                        {
                            Log.Error($"修改属性失败: 未找到属性 attributeId={attributeId}");
                        }
                    }
                    break;


                default:
                    break;
            }
        }

        /// <summary>
        /// 实体创建后 按顺序触发各属性的开局事件
        /// </summary>
        private void StartRunAttrEvent()
        {
            foreach (var info in attrDict)
            {
                List<int> AttrEventIdList = info.Value.AddEventIdList;//添加属性后运行
                foreach (int EventId in AttrEventIdList)
                {
                    RunAttrEvent(EventId, 1, 0);
                }
            }
        }

        /// <summary>
        /// Buff添加后 按顺序触发Buff开局事件-祝福注释-没完成
        /// </summary>
        public void StartRunBuffEvent(BuffData buffData)
        {
        }
        /// <summary>
        /// 实体创建后 按顺序触发各Buff的开局事件
        /// </summary>
        private void StartRunBuffEvent()
        {
        }
    }
}