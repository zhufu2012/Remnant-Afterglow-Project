using System.Collections.Generic;

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
        /// 物品的数量
        /// </summary>
        public int Quantity = 1;

        public ItemBase()
        {
            Id = IdGenerator.Generate(IdConstant.ID_TYPE_ITEM);
        }

        public ItemBase(int ItemId, int num)
        {
            this.ItemId = ItemId;
            Quantity = num;
        }

        public static ItemBase CreateFromId(int CfgId)
        {
            ItemData cfgData = ConfigCache.GetItemData(CfgId);
            return new ItemBase(cfgData.ItemId, cfgData.InitNum);
        }

        /// <summary>
        /// 返回道具的配置
        /// </summary>
        /// <returns></returns>
        public ItemData getCfg()
        {
            return ConfigCache.GetItemData(ItemId);
        }


    }
}