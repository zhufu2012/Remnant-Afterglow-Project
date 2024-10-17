using Godot;
using Project_Core_Test;
using System.Collections.Generic;

/// <summary>
/// 包含了一个 PackedScene 字典和 Node 队列的类，用于禁用对象以便重新使用。
/// </summary>

namespace Remnant_Afterglow
{
    public class Pool
    {
        private Dictionary<int, Queue<Units>> entries;
        private Node poolParent;

        public static Pool instance;

        /// <summary>
        /// Pool 类的构造函数。接收一个 PackedScene 数组用于对象池，并为每个创建 Node 队列。
        /// </summary>
        /// <param name="packs">需要排队的 PackedScenes。</param>
        /// <param name="poolParent">用于实例化节点的默认父节点。</param>
        public Pool(Dictionary<int, List<Units>> dict, Node poolParent)
        {
            if (instance != null) return;

            instance = this;
            entries = new Dictionary<int, Queue<Units>>();

            foreach (KeyValuePair<int, List<Units>> key in dict)
            {
                Queue<Units> units = new Queue<Units>();
                for (int i = 0; i < key.Value.Count; i++)
                {
                    units.Enqueue(key.Value[i]);
                }
                entries.Add(key.Key, units);
            }

            this.poolParent = poolParent;
        }

        /// <summary>
        /// 将不再需要的节点存储在相应的队列以便以后重用。
        /// </summary>
        /// <param name="node">不再需要的节点。</param>
        /// <param name="name">节点的原始名称。</param>
        /// <returns>存储节点到相应 PackedScene 是否成功。</returns>
        public bool Store(Units units, int id)
        {
            try
            {
                if (!entries.ContainsKey(id))
                {
                    entries[id].Enqueue(units);
                    units.Reparent(poolParent);
                    return true;
                }
                else
                    return false;
            }
            catch
            {
                return false;
            }
        }

        /// <summary>
        /// 返回对象池中每个 PackedScene 及其队列计数的字符串信息。
        /// </summary>
        /// <returns>以 "| NAME:COUNT | NAME:COUNT |" 格式返回每个 PackedScene 及其队列计数的字符串。</returns>
        public override string ToString()
        {
            string text = "| ";
            foreach (KeyValuePair<int, Queue<Units>> pair in entries)
            {
                int unit_id = pair.Key;
                text += unit_id + ":" + pair.Value.Count + " | ";
            }

            return text.Trim();
        }

        /// <summary>
        /// 从提供的名称匹配的 PackedScene 中获取一个节点。如果队列为空，则实例化一个新的节点并返回。
        /// </summary>
        /// <param name="name">需要返回的 PackedScene 根节点名称。（区分大小写）</param>
        /// <returns>从对象池中出列的节点，如果未找到对应 PackedScene，则返回 null。</returns>
        public Units Get(int id)
        {
            try
            {
                Units node;
                if (entries.ContainsKey(id))
                {
                    if (entries[id].Count == 0)
                    {
                        node = GD.Load<PackedScene>("res://Test/UnitTest/Unit.tscn").Instantiate<Units>();
                        node.IniData(id);
                        return node;
                    }
                    else
                    {
                        node = entries[id].Dequeue();

                        if (node.GetParent() != poolParent)
                        {

                            //node.Reparent(poolParent);
                        }
                        return node;
                    }
                }
                else
                {
                    node = GD.Load<PackedScene>("res://Test/UnitTest/Unit.tscn").Instantiate<Units>();
                    node.IniData(id);
                    return node;
                }
            }
            catch
            {
                Units node = GD.Load<PackedScene>("res://Test/UnitTest/Unit.tscn").Instantiate<Units>();
                node.IniData(id);
                return node;
            }
        }

        /// <summary>
        /// 返回给定 PackedScene 引用的对象池队列计数。
        /// </summary>
        /// <param name="packed">PackedScene 的引用。</param>
        /// <returns>如果成功，返回队列计数；否则返回 -1。</returns>
        public int GetCount(int packed)
        {
            int ret = -1;

            foreach (KeyValuePair<int, Queue<Units>> pair in entries)
            {
                if (packed == pair.Key)
                    return pair.Value.Count;
            }

            return ret;
        }

        /// <summary>
        /// 返回所有对象池 PackedScene 根节点名称的数组。
        /// </summary>
        /// <returns>所有对象池 PackedScene 根节点名称的数组。</returns>
        public int[] GetNames()
        {
            List<int> names = new List<int>();
            foreach (int pack in entries.Keys)
            {
                names.Add(pack);
            }

            return names.ToArray();
        }
    }
}