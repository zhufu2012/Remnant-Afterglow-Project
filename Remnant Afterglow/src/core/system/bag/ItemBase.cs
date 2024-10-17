namespace Remnant_Afterglow
{
    //道具
    public class ItemBase
    {
        /// <summary>
        ///物品的唯一标识符
        /// </summary>
        public string Id { get; set; }

        /// <summary>
        /// 物品配置id
        /// </summary>
        public int ItemId = 0;

         /// <summary>
                /// 物品叠加标识
                /// </summary>
                public bool Stackable { get; set; }

        /// <summary>
        /// 物品的数量
        /// </summary>
        public int Quantity = 1;

        public ItemBase()
        {
            Id = IdGenerator.Generate(IdConstant.ID_TYPE_ITEM);
        }

        public ItemBase(int ItemId,int num)
        {
            this.ItemId = ItemId;
            Quantity = num;
        }

        public static ItemBase CreateFromId(int CfgId)
        {
            ItemData cfgData = ConfigCache.GetItemData(CfgId);
            return new ItemBase(cfgData.ItemId,cfgData.InitNum);
        }

        /// <summary>
        /// 返回道具的配置
        /// </summary>
        /// <returns></returns>
        public ItemData getCfg()
        {
            return ConfigCache.GetItemData(ItemId);
        }

        /// <summary>
                /// 尝试将物品添加到背包中，如果可以叠加则叠加，否则尝试添加新物品
                /// </summary>
                /// <param name="bag"></param>
                /// <param name="rowIndex"></param>
                /// <param name="columnIndex"></param>
                /// <param name="item"></param>
                /// <returns></returns>
                public bool TryAddToBag(BagBase bag, int rowIndex, int columnIndex, ItemBase item)
                {
                    if (bag == null || item == null)
                        return false;

                    for (int row = 0; row < bag.GetMaxRow(); row++)
                    {
                        for (int col = 0; col < bag.GetMaxColumn(); col++)
                        {
                            var key = new KeyValuePair<int, int>(row, col);
                            if (bag.ItemDict.ContainsKey(key) && bag.ItemDict[key].ItemId == item.ItemId && bag.ItemDict[key].Stackable)
                            {
                                // 如果物品可叠加，并且数量没有达到最大叠加限制
                                int quantityToAdd = item.Quantity;
                                bag.ItemDict[key].Quantity += quantityToAdd;
                                item.Quantity -= quantityToAdd;
                                if (item.Quantity <= 0)
                                    return true;
                            }
                        }
                    }
                    // 如果没有找到可叠加的位置，或者物品不可叠加，则尝试添加新物品
                    return bag.AddItem(rowIndex, columnIndex, item);
                }

    }
}