using Godot;
using ManagedAttributes;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 敌人，炮塔等对象的基类,这里是实体的运动等逻辑
    /// </summary>
    public partial class BaseObject : Area2D, IPoolItem
    {
        public Vector2 Velocity;

        public Vector2I LastGridCell { get; set; }

        /// <summary>
        /// 实体中心位置，所在地图格子位置
        /// </summary>
        public Vector2I mapPos;

        /// <summary>
        /// 虚拟函数-子类重写-用于移动初始化-比如初始化速度,初始化位置
        /// </summary>
        public virtual void InitMove()
        {
            //mapPos = MapCopy.GetWorldPos(GlobalPosition);//所在地图格子坐标
        }



        /// <summary>
        /// 获取实体的最大移动速度
        /// </summary>
        /// <returns></returns>
        public float GetMaxSpeed()
        {
            return attributeContainer.GetFloat(Attr.Attr_40, AttrDataType.Max);
        }

        /// <summary>
        /// 获取实体的最大加速度速度
        /// </summary>
        /// <returns></returns>
        public float GetMaxAddSpeed()
        {
            return attributeContainer.GetFloat(Attr.Attr_41, AttrDataType.Max);
        }
        /// <summary>
        /// 获取实体的当前旋转速度
        /// </summary>
        /// <returns></returns>
        public float GetRotateSpeed()
        {
            return attributeContainer.GetFloat(Attr.Attr_42, AttrDataType.Value);
        }

    }
}