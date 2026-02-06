using GameLog;
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
        /// 道具数据 <道具唯一id,道具类>
        /// </summary>
        public Dictionary<string, ItemBase> itemDict = new Dictionary<string, ItemBase>();


        public BagBase(int BagId)
        {
            this.BagId = BagId;
        }
        /// <summary>
        /// 添加物品到背包中
        /// </summary>
        /// <param name="item">物品</param>
        public bool AddItem(ItemBase item)
        {
            if (item.Quantity > 0)//数量大于0
            {
                ItemData itemData = ConfigCache.GetItemData(item.ItemId);
                if (itemData.BagId == BagId)//添加的道具是对应的背包
                {
                    itemDict[item.Id] = item;
                    return true;
                }
                else
                {
                    Log.Error("错误！添加道具到背包id:" + BagId + "时出错！道具id:" + item.ItemId + " 不是该背包的道具!");
                    return false;
                }
            }
            else
            {
                Log.Error("错误！添加道具到背包id:" + BagId + "时出错！道具id:" + item.ItemId + " 的数量小于等于0!");
                return false;
            }
        }

    }
}