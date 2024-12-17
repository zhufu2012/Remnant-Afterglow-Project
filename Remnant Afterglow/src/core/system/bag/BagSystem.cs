
using GameLog;
using Godot.Community.ManagedAttributes;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    //管理各背包中的道具和货币的系统
    //存在多个不同的背包，每个背包可以保存不同类型的道具，
    //货币另行存储
    public class BagSystem
    {
        //字典用来存储所有背包，键是背包ID
        private Dictionary<int, BagBase> Bags = new Dictionary<int, BagBase>();
        /// <summary>
        /// 属性容器-这里用于存储货币信息，货币名称是货币id
        /// </summary>
        public ManagedAttributeContainer Currency = new ManagedAttributeContainer();



        public BagSystem()
        {
        }


        /// <summary>
        /// 添加一个新的背包
        /// </summary>
        /// <param name="bag"></param>
        /// <exception cref="ArgumentException"></exception>
        public void AddBag(BagData bag)
        {
            if (!Bags.ContainsKey(bag.BagId))
            {
                Bags.Add(bag.BagId, new BagBase(bag));
            }
            else
            {
                Log.Error("具有相同ID的背包已经存在！");
            }
        }

        /// <summary>
        /// 根据ID获取背包
        /// </summary>
        /// <param name="bagId"></param>
        /// <returns></returns>
        public BagBase GetBag(int bagId)
        {
            if (Bags.ContainsKey(bagId))
            {
                return Bags[bagId];
            }
            else
            {
                Log.Print("未找到具有给定ID的背包！BagId:", bagId);
                return null;
            }
        }

        /// <summary>
        /// 添加物品到指定的背包
        /// </summary>
        /// <param name="bagId"></param>
        /// <param name="rowIndex"></param>
        /// <param name="columnIndex"></param>
        /// <param name="item"></param>
        /// <returns></returns>
        public bool AddItemToBag(int bagId, int rowIndex, int columnIndex, ItemBase item)
        {
            if (Bags.ContainsKey(bagId))
            {
                return Bags[bagId].AddItem(rowIndex, columnIndex, item);
            }
            return false;
        }

        /// <summary>
        /// 添加指定数量的道具到指定的背包
        /// </summary>
        /// <param name="bagId">背包ID</param>
        /// <param name="itemId">道具ID</param>
        /// <param name="quantity">要添加的数量</param>
        /// <returns>是否成功添加道具</returns>
        public bool AddItemToBag(int bagId, int itemId, int quantity)
        {
            if (Bags.ContainsKey(bagId))
            {
                // 假设ItemBase有一个静态方法CreateFromId可以用来根据道具ID创建ItemBase实例
                ItemBase item = ItemBase.CreateFromId(itemId);
                if (item == null)
                {
                    Log.Error("无效的道具ID！");
                    return false;
                }
                var position = BagBase.FindFreePosition(Bags[bagId]);//查找到空闲位置
                if (position.HasValue)
                {
                    // 如果找到了空闲位置，则添加物品
                    if (!Bags[bagId].AddItem(position.Value.Key, position.Value.Value, item))
                    {
                        Log.Error($"错误！无法添加{quantity}个道具{item.ToString}到背包!");
                        return false; // 如果不能添加所有请求的数量，则返回失败
                    }
                }
                else
                {
                    Log.Error("错误！背包已满，无法添加更多道具！");
                    return false; // 背包已满
                }
                return true; // 成功添加了所有道具
            }
            else
            {
                Log.Error("错误！未找到具有给定ID的背包。");
                return false;
            }
        }

        /// <summary>
        /// 从指定的背包移除物品
        /// </summary>
        /// <param name="bagId">背包id</param>
        /// <param name="rowIndex">横轴</param>
        /// <param name="columnIndex">纵轴</param>
        /// <param name="quantityToRemove"></param>
        /// <returns></returns>
        public bool RemoveItemFromBag(int bagId, int rowIndex, int columnIndex, int quantityToRemove)
        {
            if (Bags.ContainsKey(bagId))
            {
                return Bags[bagId].RemoveItem(rowIndex, columnIndex, quantityToRemove);
            }
            return false;
        }

        /// <summary>
        /// 创建一种货币
        /// </summary>
        /// <param name="moneyBase"></param>
        public void CreateCurrency(MoneyBase moneyBase)
        {
            if (Currency["" + moneyBase.MoneyId] == null)
            {
                Currency.Add(moneyBase.GetAttribute());
            }
            else
            {
                Log.Error("错误！已存在对应货币!");
            }
        }
        /// <summary>
        /// 添加货币
        /// </summary>
        /// <param name="currencyType"></param>
        /// <param name="amount"></param>
        public void AddCurrency(string currencyId, int amount, AttributeValueType Type)
        {
            if (Currency[currencyId] == null)
            {
                MoneyBase moneyBase = ConfigCache.GetMoneyBase(currencyId);
                Currency.Add(moneyBase.GetAttribute());
            }
            else
            {
                Currency[currencyId].Add(amount, Type);
            }
        }

        /// <summary>
        /// 获取货币数量
        /// </summary>
        /// <param name="currencyId"></param>
        /// <param name="Type"></param>
        /// <returns></returns>
        public object GetCurrencyAmount(string currencyId, AttributeValueType Type)
        {
            if (Currency[currencyId] != null)
            {
                return Currency[currencyId].GetObj(Type);
            }
            else
            {
                return 0; // 或者抛出异常，取决于您的需求
            }
        }

        /// <summary>
        /// 从系统中移除货币
        /// </summary>
        /// <param name="currencyId"></param>
        /// <param name="amount"></param>
        /// <param name="Type"></param>
        /// <returns></returns>
        public bool RemoveCurrency(string currencyId, float amount, AttributeValueType Type)
        {
            if (Currency[currencyId] != null)
            {
                float nowValue = (float)Currency[currencyId].GetObj(Type);
                if (nowValue >= amount)
                {
                    Currency[currencyId].Add(amount, Type);
                    return true;
                }
            }
            return false;
        }
    }
}