using ManagedAttributes;
using System;

namespace Remnant_Afterglow
{
    /// <summary>
    /// Buff处理器的接口
    /// </summary>
    public interface IBuffHandler
    {
        /// <summary>
        /// 添加Buff
        /// </summary>
        /// <param name="buffId">施加Buff的ID</param>
        public void AddBuff(IBuff buff, int buffId, BaseObject CasterObject, int Layer);
        /// <summary>
        /// 移除Buff
        /// </summary>
        /// <param name="buffId">要移除的Buff 唯一id</param>
        /// <param name="removeAll">如果对象同时存在多个同id的buff，是否将所有一并移除</param>
        public void RemoveBuff(int buffId);
        /// <summary>
        /// 移除Buff（不执行OnBuffRemove）
        /// </summary>
        /// <param name="buffId">要移除的Buff id</param>
        /// <param name="removeAll">如果对象同时存在多个同id的buff，是否将所有一并移除</param>
        public void InterruptBuff(int buffId, bool removeAll = true);
        /// <summary>
        /// 注册事件：添加Buff时
        /// </summary>
        /// <param name="act">注册的行为</param>
        public void RegisterOnAddBuff(Action act);
        /// <summary>
        /// 删除事件：添加Buff时
        /// </summary>
        /// <param name="act">注册的行为</param>
        public void RemoveOnAddBuff(Action act);
        /// <summary>
        /// 注册事件：删除Buff时
        /// </summary>
        /// <param name="act">注册的行为</param>
        public void RegisterOnRemoveBuff(Action act);
        /// <summary>
        /// 删除事件：删除Buff时
        /// </summary>
        /// <param name="act">注册的行为</param>
        public void RemoveOnRemoveBuff(Action act);
    }
}
