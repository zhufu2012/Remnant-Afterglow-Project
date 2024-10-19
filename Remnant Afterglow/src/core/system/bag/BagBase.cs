
using GameLog;
using System;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 背包基础
    /// </summary>
    public class BagBase
    {
        /// <summary>
        /// 背包id
        /// </summary>
        public int BagId;


        /// <summary>
        /// 背包最大行数
        /// </summary>
        public int Crosswise;
        /// <summary>
        /// 背包最大列数
        /// </summary>
        public int Vertical;

        public BagData cfgData;

        public Dictionary<KeyValuePair<int, int>, ItemBase> ItemDict = new Dictionary<KeyValuePair<int, int>, ItemBase>();


        public BagBase(BagData cfgData)
        {
            this.cfgData = cfgData;
            BagId = cfgData.BagId;
            Crosswise = cfgData.Crosswise;
            Vertical = cfgData.Vertical;
        }
        /// <summary>
        /// 添加物品到背包中
        /// </summary>
        /// <param name="rowIndex">横排</param>
        /// <param name="columnIndex">竖排</param>
        /// <param name="item"></param>
        public bool AddItem(int rowIndex, int columnIndex, ItemBase item)
        {
            if (item == null)
                return false;
            var key = new KeyValuePair<int, int>(rowIndex, columnIndex);
            if (ItemDict.ContainsKey(key))
            {
                if (ItemDict[key].ItemId == item.ItemId)
                {
                    ItemDict[key].Quantity += item.Quantity;
                    return true;
                }
                else
                {
                    // 如果槽位已有物品，且不允许叠加，则返回失败
                    return false;
                }
            }
            else
            {
                ItemDict[key] = item;
                return true;
            }
        }

        /// <summary>
        /// 查找背包中第一个空闲的位置
        /// </summary>
        /// <param name="bag">背包实例</param>
        /// <returns>空闲位置或null</returns>
        public static KeyValuePair<int, int>? FindFreePosition(BagBase bag)
        {
            for (int row = 0; row < bag.GetMaxRow(); row++)
            {
                for (int col = 0; col < bag.GetMaxColumn(); col++)
                {
                    var key = new KeyValuePair<int, int>(row, col);
                    if (!bag.ItemDict.ContainsKey(key))
                    {
                        return key;
                    }
                }
            }
            return null; // 没有空闲位置
        }

        /// <summary>
        /// 移除背包中的物品
        /// </summary>
        /// <param name="rowIndex"></param>
        /// <param name="columnIndex"></param>
        /// <param name="quantityToRemove"></param>
        /// <returns></returns>
        public bool RemoveItem(int rowIndex, int columnIndex, int quantityToRemove)
        {
            var key = new KeyValuePair<int, int>(rowIndex, columnIndex);
            if (ItemDict.ContainsKey(key))
            {
                var item = ItemDict[key];
                if (item.Quantity >= quantityToRemove)
                {
                    item.Quantity -= quantityToRemove;
                    if (item.Quantity <= 0)
                    {
                        ItemDict.Remove(key);
                    }
                    return true;
                }
            }
            return false;
        }

        /// <summary>
        /// 获取背包的最大行数
        /// </summary>
        /// <returns></returns>
        private int GetMaxRow()
        {
            return Crosswise;
        }

        /// <summary>
        /// 获取背包的最大列数
        /// </summary>
        /// <returns></returns>
        private int GetMaxColumn()
        {
            return Vertical;
        }
    }
}