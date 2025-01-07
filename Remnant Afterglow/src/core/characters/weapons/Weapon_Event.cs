using Godot;
using System;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 武器事件
    /// </summary>
    public partial class WeaponBase : BaseObject, IWeapon
    {
        /// <summary>
        /// 攻击事件-武器攻击时触发
        /// </summary>
        public event Action Attacked;
        /// <summary>
        /// 冷却事件-武器冷却时触发
        /// </summary>
        public event Action CoolDownEnded;
        
        /// <summary>
        /// 索敌事件-武器索敌时触发
        /// </summary>
        public event Action FindTargetEd;

        /// <summary>
        /// 攻击时触发，用于触发 Attacked 事件
        /// </summary>
        protected virtual void OnAttacked()
        {
            Attacked?.Invoke();
        }

        /// <summary>
        /// 冷却时触发，用于触发 CoolDownEnded 事件
        /// </summary>
        protected virtual void OnCoolDownEnded()
        {
            CoolDownEnded?.Invoke();
        }

        /// <summary>
        /// 实体进入攻击范围
        /// </summary>
        public void Area2DEntered(Area2D area)
        {
            if(area.IsInGroup(MapGroup.BulletGroup))//检查-是子弹
            {
            }
        }

        /// <summary>
        /// 实体退出攻击范围
        /// </summary>
        public void Area2DExited(Area2D area)
        {
            if(area.IsInGroup(MapGroup.BulletGroup))//检查-是子弹
            {
            }
        }
    }
}