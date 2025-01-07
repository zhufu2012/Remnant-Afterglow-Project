using GameLog;
using Godot;
using Godot.Community.ManagedAttributes;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 敌人，炮塔等对象的基类,这里是实体的运动等逻辑
    /// </summary>
    public partial class BaseObject : CharacterBody2D, IPoolItem
    {


        /// <summary>
        /// 区域节点
        /// </summary>
        public Area2D area2D;
        /// <summary>
        /// 当前实体碰撞器节点, 节点名称必须叫 "Collision", 类型为 CollisionShape2D
        /// </summary>
        public CollisionShape2D Collision { get; set; }

        /// <summary>
        /// 实体中心全局位置，武器计算射程时使用这个点
        /// </summary>
        public Vector2 centerPos;

        /// <summary>
        /// 实体中心位置，所在地图位置
        /// </summary>
        public Vector2I mapPos;//祝福注释-这个位置需要确定
        /// <summary>
        /// 实体占据的位置列表
        /// </summary>
        public List<Vector2I> perchPosList;

        /// <summary>
        /// 初始化运动块
        /// </summary>
        public void InitObjectMove()
        {
            InitCollision();//初始化碰撞
        }

        /// <summary>
        /// 虚拟函数-子类重写-用于移动初始化-比如初始化速度,初始化位置
        /// </summary>
        public virtual void InitMove()
        {
            mapPos = MapCopy.GetWorldPos(GlobalPosition);
        }

        /// <summary>
        /// 初始化碰撞节点
        /// </summary>
        protected virtual void InitCollision()
        {
            Collision = baseData.GetCollisionShape2D();
            AddChild(Collision);

            area2D = GD.Load<PackedScene>("res://src/core/characters/Area.tscn").Instantiate<Area2D>();
            //area2D.ProcessMode = ProcessModeEnum.Always;
            area2D.CollisionMask = Common.CalculateMaskSum(baseData.MaskLayerList);
            area2D.CollisionLayer = Common.CalculateMaskSum(baseData.CollisionLayerList);
            //CollisionShape2D Collision2 = baseData.GetCollisionShape2D();
            //area2D.AddChild(Collision2);
            //area2D.AddToGroup("1");


            area2D.AreaEntered += Area2DEntered;
            AddChild(area2D);
        }

        /// <summary>
        /// 执行移动操作
        /// </summary>
        public virtual void DoMove(double delta) { }



        /// <summary>
        /// 获取实体的当前移动速度
        /// </summary>
        /// <returns></returns>
        public float GetSpeed()
        {
            return GetAttrValue(Attr.Attr_40, AttributeValueType.Value);
        }

        /// <summary>
        /// 获取实体的最大移动速度
        /// </summary>
        /// <returns></returns>
        public float GetMaxSpeed()
        {
            return GetAttrValue(Attr.Attr_40, AttributeValueType.Max);
        }

        /// <summary>
        /// 获取实体的最大加速度速度
        /// </summary>
        /// <returns></returns>
        public float GetMaxAddSpeed()
        {
            return GetAttrValue(Attr.Attr_41, AttributeValueType.Max);
        }
        /// <summary>
        /// 获取实体的当前旋转速度
        /// </summary>
        /// <returns></returns>
        public float GetRotateSpeed()
        {
            return GetAttrValue(Attr.Attr_42, AttributeValueType.Value);
        }

    }
}