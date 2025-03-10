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
        /// 分离列表
        /// </summary>
        private List<BaseObject> EnteredBaseObjectList_Separation = new List<BaseObject>();


        /// <summary>
        /// 实体中心全局位置，
        /// </summary>
        public Vector2 centerPos;

        /// <summary>
        /// 实体中心位置，所在地图格子位置
        /// </summary>
        public Vector2I mapPos;
        /// <summary>
        /// 实体占据的位置列表
        /// </summary>
        public List<Vector2I> perchPosList;

        /// <summary>
        /// 初始化运动块
        /// </summary>
        public void InitObjectMove()
        {
        }

        /// <summary>
        /// 虚拟函数-子类重写-用于移动初始化-比如初始化速度,初始化位置
        /// </summary>
        public virtual void InitMove()
        {
            mapPos = MapCopy.GetWorldPos(GlobalPosition);//所在地图格子坐标
        }


        #region 单位分离
        /// <summary>
        /// 实体当前速度大小
        /// </summary>
        public float theSpeed;
        /// <summary>
        /// 实体临时速度大小
        /// </summary>
        private float temp_speed;
        /// <summary>
        /// 实体当前方向
        /// </summary>
        public Vector2 theDirection = new Vector2(0, 0);
        public float separation = 0.5f;
        /// <summary>
        /// 分离函数
        /// </summary>
        private void UpdateSeparation()
        {
            Vector2 steer = new Vector2(0, 0);
            foreach (BaseObject theBoid in EnteredBaseObjectList_Separation)
            {
                Vector2 d = Position - theBoid.Position;
                if (d == new Vector2(0, 0))
                {
                    Random random = new Random();
                    steer += random.NextDouble() > 0.5 ? new Vector2(1, 1) : new Vector2(-1, -1);
                }
                else
                {
                    steer += d.Normalized() / theBoid.Position.DirectionTo(Position).Length();
                }
            }
            theDirection = steer;
            theSpeed = GetMaxSpeed() / separation;
        }
        #endregion

        /// <summary>
        /// 执行移动操作
        /// </summary>
        public virtual void DoMove(double delta) { }



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
            return GetAttrValue(Attr.Attr_42, AttributeValueType.Max);
        }

    }
}