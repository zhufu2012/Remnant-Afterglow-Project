using GameLog;
using Godot;
using Godot.Collections;
using Godot.Community.ManagedAttributes;
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
    public partial class BaseObject : CharacterBody2D, IPoolItem
    {

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                MobKilled -= ObjectManager.KilledAfter;
                Harmed -= ObjectManager.HarmedAfter;
            }
            base.Dispose(disposing);
        }
        /// <summary>
        /// 实体死亡事件
        /// </summary>
        /// <param name="killObject"></param>
        /// <param name="casterObject"></param>
        [Signal]
        public delegate void MobKilledEventHandler(BaseObject killObject, BaseObject casterObject, BulletNode bulletNode);

        /// <summary>
        /// 实体受损事件
        /// </summary>
        /// <param name="killObject"></param>
        /// <param name="casterObject"></param>
        [Signal]
        public delegate void HarmedEventHandler(BaseObject killObject, BaseObject casterObject, BulletNode bulletNode);

        /// <summary>
        /// 实体死亡-Buff给与者，或者子弹创建者导致的死亡
        /// </summary>
        /// <param name="casterObject"></param>
        public void ObjectKilled(BaseObject casterObject, BulletNode bulletNode)
        {
            EmitSignal(SignalName.MobKilled, this, casterObject, bulletNode);//实体死亡信号
        }

        /// <summary>
        /// 实体受伤特殊属性被改变-Buff给与者，或者子弹创建者导致的伤害，属性id，伤害大小
        /// </summary>
        /// <param name="casterObject"></param>
        public void ObjectHarmed(BaseObject casterObject, BulletNode bulletNode)
        {
            EmitSignal(SignalName.Harmed, this, casterObject, bulletNode);//实体死亡信号
        }

        /// <summary>
        /// 有其他区域进入单位身体区域
        /// </summary>
        /// <param name="area"></param>
        public void Area2DEntered(Area2D area)
        {
            AreaEnter(area);
        }

        public virtual void AreaEnter(Area2D area)
        {
            if (IsDestroyed)//死亡就不继续了
                return;
            if (!area.IsInGroup("" + Camp))
            {
                if (area.IsInGroup(MapGroup.BulletGroup))
                {
                    EnergyBullet bullet = area.GetParentOrNull<EnergyBullet>();
                    BulletLogic bulletLogic = bullet.bulletLogic;
                    //子弹造成伤害
                    attributeContainer.ApplyDamage(bulletLogic.ShieldHarm, bulletLogic.ArmourHarm, bulletLogic.StructureHarm, bulletLogic.ElementHarm);

                    //# AttrHarm	#LaserHarm	#ExplosionHarm	#ElementHarm
                    //ObjectHarmed(bullet.bulletBase.createObject, bullet);//造成伤害

                    bullet.bulletBase.Used = false;//准备移除子弹
                    if (attributeContainer.IsDead())
                    {
                        IsDestroyed = true; // 已经被摧毁
                        DieEvent();
                        //ObjectKilled(bullet.bulletBase.createObject, bullet);//死亡事件
                    }

                }
            }
        }


        /// <summary>
        /// 有其他区域退出单位身体区域
        /// </summary>
        /// <param name="area"></param>
        public void Area2DExited(Area2D area)
        {
            AreaExited(area);
        }

        public virtual void AreaExited(Area2D area)
        {

        }


        /// <summary>
        /// 实体死亡事件
        /// </summary>
        public void DieEvent()
        {
            switch (object_type)
            {
                case BaseObjectType.BaseBuild://建筑
                    ObjectManager.Instance.buildDict.Remove(Logotype);
                    if (this is BuildBase buildBase)
                    {
                        ObjectManager.Instance.ReMoveObject(this, buildBase.buildData);
                        FlowFieldSystem.Instance.CreateBaseObject(this, buildBase.buildData, true);
                    }
                    break;
                case BaseObjectType.BaseTower://炮塔
                    ObjectManager.Instance.towerDict.Remove(Logotype);
                    if (this is TowerBase towerBase)
                    {
                        ObjectManager.Instance.ReMoveObject(this, towerBase.buildData);
                        FlowFieldSystem.Instance.CreateBaseObject(this, towerBase.buildData, true);
                    }
                    break;
                case BaseObjectType.BaseUnit://单位
                    ObjectManager.Instance.unitDict.Remove(Logotype);
                    break;
                case BaseObjectType.BaseWorker://单位
                    ObjectManager.Instance.workerDict.Remove(Logotype);
                    break;
                default:
                    break;
            }
            QueueFree();
        }


        /// <summary>
        /// 运行事件
        /// </summary>
        /// <param name="event_id">事件id</param>
        /// <param name="type">事件类型 1 为属性  2为 buff</param>
        /// <param name="keyId">根据事件类型来确定的，
        /// 触发者id 事件类型为1时，keyId为0表示属性开局触发事件
        /// 触发者id 事件类型为2时，keyId为0表示buff添加后触发事件
        /// </param>
        public void RunAttrEvent(int event_id, int type, int keyId)
        {
            AttrEvent unitAttrEvent = ConfigCache.GetAttrEvent(event_id);//事件配置
            switch (unitAttrEvent.EventType)
            {
                case 1://输出事件数据
                    Log.Print($"实体id:{ObjectId},时间:{NowTick},事件id:{event_id},事件类型{type},触发id{keyId},事件描述{unitAttrEvent.AttrEventDescribe}");
                    break;
                //case AttrEventType.ModifierEvent://修改属性事件-祝福注释-还没改完
                //    List<List<float>> ParamList = unitAttrEvent.ParamList;
                //    for (int i = 0; i < ParamList.Count; i++)
                //    {
                //        List<float> RowParam = ParamList[i];
                //        if (IsAttributeData("" + RowParam[0]) != null)//是否存在该属性
                //         {
                //FloatManagedAttribute attr = (FloatManagedAttribute)attributeContainer[""];
                //        }
                //    }
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
                //    break;
                default: break;
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