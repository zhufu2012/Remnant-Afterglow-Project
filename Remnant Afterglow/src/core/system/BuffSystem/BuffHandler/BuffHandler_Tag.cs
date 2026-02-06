using System;
using System.Collections.Generic;
using System.Linq;

namespace Remnant_Afterglow
{
    /// <summary>
    /// Buff处理器类，需要挂载在接受Buff的游戏对象上,给实体处理各种buff功能，以及buff增加，和移除等
    /// 注意！buffTag 实体本身也可以自带一些
    /// </summary>
    public partial class BuffHandler : IBuffHandler
    {
        /// <summary>
        /// 替换Tag字段，当新增buff上有以下tag,移除原来旧的tag
        /// <TagId,List<BuffId>>
        /// 只保存 buff中 需要在添加新buff时替换的tag,buff过期时需要移除
        /// 移除逻辑是检查所有tagId,有就移除，为空列表时移除tagId项
        /// </summary>
        public Dictionary<int, HashSet<int>> ReplaceTagDict = new Dictionary<int, HashSet<int>>();
        /// <summary>
        /// 禁止Tag字段，当新增buff上有以下tag，不添加该buff,buff过期时需要移除
        /// <TagId,List<BuffId>>
        /// 移除逻辑是检查所有tagId,有就移除，为空列表时移除tagId项
        /// </summary>
        public Dictionary<int, HashSet<int>> BanTagDict = new Dictionary<int, HashSet<int>>();

        /// <summary>
        /// 初始化buffTag数据
        /// </summary>
        public void InitBuffTag()
        {
            foreach (var info in buffs)
            {
                int buffId = info.Value.buffId;
                HashSet<int> TagIdList = info.Value.buffData.BuffTagIdList;
                foreach (int tagId in TagIdList)
                {
                    BuffTag tagData = ConfigCache.GetBuffTag(tagId);
                    HashSet<int> ReplaceTagIdList = tagData.ReplaceTagIdList;
                    HashSet<int> BanTagIdList = tagData.BanTagIdList;
                    foreach (int subTagId in ReplaceTagIdList)
                    {
                        if (ReplaceTagDict.ContainsKey(subTagId))//存在了，就加该buff
                        {
                            ReplaceTagDict[subTagId].Add(buffId);//把这个buffId加上
                        }
                        else//不存在
                        {
                            ReplaceTagDict[subTagId] = new HashSet<int> { buffId };
                        }
                    }

                    foreach (int subTagId in BanTagIdList)
                    {
                        if (BanTagDict.ContainsKey(subTagId))//存在了，就加该buff
                        {
                            BanTagDict[subTagId].Add(buffId);//把这个buffId加上
                        }
                        else//不存在
                        {
                            BanTagDict[subTagId] = new HashSet<int> { buffId };
                        }
                    }
                }
            }
        }


        /// <summary>
        /// 返回对应类型的所有tagIdList
        /// </summary>
        /// <param name="tagIdList">buff的所有tagIdList</param>
        /// <param name="type">type = 1 ReplaceTagIdList  type = 2 BanTagIdList</param>
        /// <returns>返回对应类型的所有tagIdList</returns>
        public HashSet<int> GetAllTagIdList(HashSet<int> tagIdList, int type)
        {
            HashSet<int> AllTagList = new HashSet<int>();
            foreach (int tagId in tagIdList)
            {
                BuffTag tag = ConfigCache.GetBuffTag(tagId);
                switch (type)
                {
                    case 1:
                        AllTagList.UnionWith(tag.ReplaceTagIdList);
                        break;
                    case 2:
                        AllTagList.UnionWith(tag.BanTagIdList);
                        break;
                    default:
                        break;
                }
            }
            return AllTagList;
        }

        /// <summary>
        /// 返回buff替换移除列表
        /// </summary>
        /// <param name="buffId">buffId</param>
        /// <param name="TagIdList">添加的buff的所有tagID列</param>
        /// <returns></returns>
        public HashSet<int> TagReplaceList(int buffId, HashSet<int> TagIdList)
        {
            TagIdList.UnionWith(TargetObject.baseData.BuffTagIdList);//加上本体自带的tag
            HashSet<int> ReplaceTagIdList = GetAllTagIdList(TagIdList, 1);
            HashSet<int> DeleteBuffIdList = new HashSet<int>();//要移除的buff列表
            foreach (int tagId in ReplaceTagIdList)
            {
                if (ReplaceTagDict.ContainsKey(tagId))//有可替换的tagId，有就把
                {
                    DeleteBuffIdList.UnionWith(ReplaceTagDict[tagId]);//加进移除准备列表
                    ReplaceTagDict[tagId] = new HashSet<int> { buffId };//新的buff列表
                }
            }
            return DeleteBuffIdList;
        }

        /// <summary>
        /// 检查是否可以添加该buff
        /// </summary>
        /// <param name="TagIdList">buff的tagId列表</param>
        /// <returns></returns>
        public bool CheckAddBuff(HashSet<int> TagIdList)
        {
            foreach (int tagId in TagIdList)
            {
                if (BanTagDict.ContainsKey(tagId))//有禁止的tagId
                {
                    return false;
                }
            }
            return true;//可以添加buff
        }

        /// <summary>
        /// 移除buff时，需要移除buff的tag
        /// </summary>
        /// <param name="deleteBuffIdList"></param>
        public void RemoveBuffTag(HashSet<int> deleteBuffIdList)
        {
            // 创建一个临时列表来存储需要移除的键
            List<int> keysToRemove = new List<int>();
            foreach (var pair in ReplaceTagDict)
            {
                bool isEmpty = false;//是否为空
                // 使用LINQ查询来移除指定的buffId，并检查是否变为空
                var updatedSet = pair.Value.Where(buffId => !deleteBuffIdList.Contains(buffId)).ToHashSet();
                if (updatedSet.Count == 0)
                {
                    isEmpty = true;
                }
                else
                {
                    // 如果不是空的，更新原有的HashSet
                    ReplaceTagDict[pair.Key] = updatedSet;
                }
                if (isEmpty)// 记录下需要移除的键
                {
                    keysToRemove.Add(pair.Key);// 记录下需要移除的键
                }
            }
            // 移除所有标记为需要移除的键值对
            foreach (var key in keysToRemove)
            {
                ReplaceTagDict.Remove(key);
            }

            // 创建一个临时列表2来存储需要移除的键
            List<int> keysToRemove2 = new List<int>();
            foreach (var pair in BanTagDict)
            {
                bool isEmpty = false;//是否为空
                // 使用LINQ查询来移除指定的buffId，并检查是否变为空
                var updatedSet = pair.Value.Where(buffId => !deleteBuffIdList.Contains(buffId)).ToHashSet();
                if (updatedSet.Count == 0)
                {
                    isEmpty = true;
                }
                else
                {
                    // 如果不是空的，更新原有的HashSet
                    BanTagDict[pair.Key] = updatedSet;
                }
                if (isEmpty)// 记录下需要移除的键
                {
                    keysToRemove2.Add(pair.Key);// 记录下需要移除的键
                }
            }
            // 移除所有标记为需要移除的键值对
            foreach (var key in keysToRemove2)
            {
                BanTagDict.Remove(key);
            }
        }
    }
}