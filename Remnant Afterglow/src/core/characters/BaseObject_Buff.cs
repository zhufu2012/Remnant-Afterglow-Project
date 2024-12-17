using GameLog;
using Godot;
using Godot.Community.ManagedAttributes;
using System.Collections.Generic;
using System.Linq;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 敌人，炮塔等对象的基类,这里处理 实体的buff等逻辑
    /// </summary>
    public partial class BaseObject : CharacterBody2D, IPoolItem
    {
        /// <summary>
        /// buff处理器
        /// </summary>
        public BuffHandler handler;
        /// <summary>
        /// 初始化buff
        /// </summary>
        /// <param name="objectId"></param>
        public virtual void InitBuff(int objectId)
        {
            handler = new BuffHandler(this);
        }
    }
}