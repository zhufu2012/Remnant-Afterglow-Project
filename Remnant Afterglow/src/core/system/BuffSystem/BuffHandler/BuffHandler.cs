using GameLog;
using System;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// Buff处理器类，需要挂载在接受Buff的游戏对象上,给实体处理各种buff功能，以及buff增加，和移除等
    /// </summary>
    public partial class BuffHandler : IBuffHandler
    {
        /// <summary>
        /// buff挂载者-实体
        /// </summary>
        public BaseObject TargetObject;

        /// <summary>
        /// 实体的buff字典 <buffId,BuffBase>
        /// </summary>
        private Dictionary<int, BuffBase> buffs = new Dictionary<int, BuffBase>();

        /// <summary>
        /// 当前是否需要更新
        /// </summary>
        public bool updated = false;

        public BuffHandler(BaseObject TargetObject)
        {
            this.TargetObject = TargetObject;
        }
        /// <summary>
        /// 获取实体buff字典数据
        /// </summary>
        public Dictionary<int, BuffBase> GetBuffs()
        {
            return buffs;
        }

        public BuffBase GetBuff(int buffId)
        {
            BuffBase buffBase = null;
            if (buffs.TryGetValue(buffId, out buffBase))
            {
                return buffBase;
            }
            return null;
        }


        #region 私有方法
        /// <summary>
        /// 添加1层Buff
        /// </summary>
        /// <param name="buffId">施加Buff的ID</param>
        /// <param name="CasterObject">给与buff者，可以是自己给buff</param>
        public void AddBuff(int buffId, BaseObject CasterObject)
        {
            var buff = BuffManager.Instance.GetBuff(buffId);
            AddBuff(buff, buffId, CasterObject, 1);
        }
        /// <summary>
        /// 添加Buff
        /// </summary>
        /// <param name="buffId">施加Buff的ID</param>
        /// <param name="CasterObject">给与buff者，可以是自己给buff</param>
        /// <param name="Layer">添加几层</param>
        public void AddBuff(IBuff buff, int buffId, BaseObject CasterObject, int Layer)
        {
            if (!updated) Update();
            BuffBase newBuff = (BuffBase)buff;
            newBuff.Initialize(buffId, this, CasterObject);
            //不管buff能不能加，都执行OnBuffAwake
            newBuff.OnBuffAwake();

            //确定能添加Buff时
            onAddBuff?.Invoke();

            BuffBase previous = null;
            if (buffs.TryGetValue(buffId, out previous))//能查到
            {
                switch (previous.mutilAddType)//有就检查buff的添加逻辑
                {
                    case BuffMutilAddType.resetTime://重置Buff时间
                        previous.ResetTimer();
                        break;
                    case BuffMutilAddType.multipleLayer://增加Buff层数
                        previous.ModifyLayer(Layer);
                        break;
                    case BuffMutilAddType.multipleLayerAndResetTime://增加Buff层数且重置Buff时间
                        previous.ResetTimer();
                        previous.ModifyLayer(Layer);
                        //forOnBuffStart += previous.OnBuffStart;
                        break;
                }
            }
            else//没有该buff
            {
                HashSet<int> BuffTagIdList = newBuff.buffData.BuffTagIdList;
                if (CheckAddBuff(BuffTagIdList))//buff能添加
                {
                    if (BuffTagIdList.Count > 0)//如果新增的buff有tag列表
                    {
                        HashSet<int> DeleteTagIdList = TagReplaceList(buffId, BuffTagIdList);//要移除的buffID, 被替换下来的旧buff
                        foreach (int deleteTagId in DeleteTagIdList)
                        {
                            RemoveBuff(deleteTagId);//移除buff
                        }
                        RemoveBuffTag(DeleteTagIdList);//移除buff，更新Tag数据
                    }
                    buffs[buffId] = newBuff;
                    forOnBuffStart += newBuff.OnBuffStart;
                    TargetObject.StartRunBuffEvent(newBuff.buffData);//添加buff后，运行的开局事件
                }
                else//buff不能添加
                {
                    newBuff.SetEffective(false);//设置为无效
                    newBuff.OnBuffDestroy();//移除
                    return;
                }
            }
        }

        /// <summary>
        /// 移除Buff，移除后执行OnBuffRemove
        /// </summary>
        /// <param name="buffId">要移除的Buff id</param>
        public void RemoveBuff(int buffId)
        {
            BuffBase buff = GetBuff(buffId);
            if (buff == null)
            {
                Log.Error("尝试从ID:" + TargetObject.baseData.ObjectId + " 处移除没有添加的Buff, id:" + buffId);
                return;
            }
            buff.SetEffective(false);
        }

        /// <summary>
        /// 移除Buff（不执行OnBuffRemove）
        /// </summary>
        /// <param name="buffId">要移除的Buff id</param>
        /// <param name="removeAll">如果对象同时存在多个同id的buff，是否将所有一并移除</param>
        public void InterruptBuff(int buffId, bool removeAll = true)
        {
            BuffBase buff = GetBuff(buffId);
            if (buff == null)
            {
                Log.Error("尝试从ID:" + TargetObject.baseData.ObjectId + " 处移除没有添加的Buff, id:" + buffId);
                return;
            }
            buff.SetEffective(false);
            buffs.Remove(buffId);
            forOnBuffDestroy += ((BuffBase)buff).OnBuffDestroy;
        }
        #endregion

        #region IBuffHandler
        /// <summary>
        /// 添加buff时事件
        /// </summary>
        private Action onAddBuff;
        /// <summary>
        /// 移除buff时事件
        /// </summary>
        private Action onRemoveBuff;
        /// <summary>
        /// 注册事件：添加Buff时
        /// </summary>
        /// <param name="act">注册的行为</param>
        public void RegisterOnAddBuff(Action act) { onAddBuff += act; }

        /// <summary>
        /// 删除事件：添加Buff时
        /// </summary>
        /// <param name="act">注册的行为</param>
        public void RemoveOnAddBuff(Action act) { onRemoveBuff -= act; }

        /// <summary>
        /// 注册事件：删除Buff时
        /// </summary>
        /// <param name="act">注册的行为</param>
        public void RegisterOnRemoveBuff(Action act) { onRemoveBuff += act; }

        /// <summary>
        /// 删除事件：删除Buff时
        /// </summary>
        /// <param name="act">注册的行为</param>
        public void RemoveOnRemoveBuff(Action act) { onRemoveBuff -= act; }
        #endregion


        private Action forOnBuffDestroy;    //用于在下一帧执行onBuffDestory
        private Action forOnBuffStart;
        public void Update()
        {
            if (updated) return;
            updated = true;
            forOnBuffDestroy?.Invoke();
            forOnBuffStart?.Invoke();
            forOnBuffDestroy = null;
            forOnBuffStart = null;
        }

        public void LateUpdate()
        {
            updated = false;
            BuffBase bf;
            bool buffRemoved = false;//是否有buff需要移除
            for (int i = buffs.Count - 1; i >= 0; i--)
            {
                bf = buffs[i];
                bf.OnBuffUpdate();
                if (!bf.isEffective)//buff无效了
                {
                    bf.OnBuffRemove();//当Buff需要被移除时调用
                    buffRemoved = true;
                    buffs.Remove(bf.buffId);
                    forOnBuffDestroy += bf.OnBuffDestroy;
                }
            }
            if (buffRemoved)//有buff需要移除
                onRemoveBuff?.Invoke();
        }

    }
}