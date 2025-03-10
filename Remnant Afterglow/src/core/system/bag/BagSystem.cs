using GameLog;
using Godot;
using Newtonsoft.Json;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 管理各背包中的道具和货币的系统
    /// 存在多个不同的背包，每个背包可以保存不同类型的道具
    /// </summary>
    public class BagSystem
    {

        public static BagSystem Instance;
        public BagSystem()
        {
            Instance = this;
        }

        #region 货币
        /// <summary>
        /// 大地图-货币数据<货币id,当前值>.存档需要有这个数据
        /// </summary>
        public Dictionary<int, int> CurrencyBigMap = new Dictionary<int, int>();
        /// <summary>
        /// 作战地图-货币数据<货币id,当前值>，存档暂时不需要这个数据-祝福注释
        /// </summary>
        [JsonIgnore]
        public Dictionary<int, int> CurrencyMap = new Dictionary<int, int>();
        /// <summary>
        /// 创建存档时的货币处理
        /// </summary>
        public void CreateBigMapCurrency(MoneyBase moneyBase)
        {
            switch (moneyBase.MoneyType)
            {
                case 1://大地图,存档创建时准备
                    CurrencyBigMap[moneyBase.MoneyId] = moneyBase.NowValue;
                    break;
                case 2://作战地图
                    //CurrencyMap[moneyBase.MoneyId] = moneyBase.NowValue;
                    break;
                default:
                    break;
            }
        }

        public void MapCurrencyClear()
        {
            CurrencyMap.Clear();
        }

        /// <summary>
        /// 创建地图货币
        /// </summary>
        /// <param name="moneyBase"></param>
        public void CreateMapCurrency(MoneyBase moneyBase)
        {
            switch (moneyBase.MoneyType)
            {
                case 1://大地图,存档创建时准备
                    //CurrencyBigMap[moneyBase.MoneyId] = moneyBase.NowValue;
                    break;
                case 2://作战地图
                    CurrencyMap[moneyBase.MoneyId] = moneyBase.NowValue;
                    break;
                default:
                    break;
            }
        }


        /// <summary>
        /// 添加货币，如果没有该货币就加上该货币id
        /// </summary>
        /// <param name="currId">货币id</param>
        /// <param name="AddValue">添加的数量</param>
        /// <returns></returns>
        public bool AddCurrency(int currId, int AddValue)
        {
            MoneyBase moneyBase = ConfigCache.GetMoneyBase(currId);
            if (moneyBase != null)
            {
                switch (moneyBase.MoneyType)
                {
                    case 1://大地图
                        if (CurrencyBigMap.ContainsKey(currId))
                            CurrencyBigMap[currId] = Mathf.Min(CurrencyBigMap[currId] + AddValue, moneyBase.Max);
                        else
                            CurrencyBigMap[currId] = Mathf.Min(AddValue, moneyBase.Max);
                        return true;
                    case 2://作战地图
                        if (CurrencyMap.ContainsKey(currId))
                            CurrencyMap[currId] = Mathf.Min(CurrencyMap[currId] + AddValue, moneyBase.Max);
                        else
                            CurrencyMap[currId] = Mathf.Min(AddValue, moneyBase.Max); ;
                        return true;
                    default:
                        break;
                }
            }
            return false;
        }

        /// <summary>
        /// 建造 建筑时，消耗资源
        /// </summary>
        /// <returns></returns>
        public bool RemoveBuildPrice(BuildData buildData, bool IsRemove)
        {
            List<List<int>> Price = buildData.Price;//建造价格
            bool IsCanBuild = true;
            foreach (List<int> item in Price)
            {
                int currId = item[0];//货币id
                int num = item[1];//货币数量
                MoneyBase moneyBase = ConfigCache.GetMoneyBase(currId);
                if (moneyBase != null)
                {
                    switch (moneyBase.MoneyType)
                    {
                        case 1://大地图
                            if (CurrencyBigMap.ContainsKey(currId))
                                if (CurrencyBigMap[currId] < num)
                                    IsCanBuild = false;
                            break;
                        case 2://作战地图
                            if (CurrencyMap.ContainsKey(currId))
                                if (CurrencyMap[currId] < num)
                                    IsCanBuild = false;
                            break;
                        default:
                            break;
                    }
                }
                else
                    IsCanBuild = false;
            }
            if (IsCanBuild && IsRemove)//资源足够并且要消耗货币
            {
                foreach (List<int> item in Price)
                {
                    AddCurrency(item[0], -item[1]);//货币id,货币数量
                }
                return true;
            }
            return IsCanBuild;
        }



        /// <summary>
        /// 获取货币数量
        /// </summary>
        /// <returns></returns>
        public int GetCurrency(int currId)
        {
            MoneyBase moneyBase = ConfigCache.GetMoneyBase(currId);
            if (moneyBase != null)
            {
                switch (moneyBase.MoneyType)
                {
                    case 1://大地图,存档创建时准备
                        if (CurrencyBigMap.ContainsKey(currId))
                        {
                            return CurrencyBigMap[currId];
                        }
                        break;
                    case 2://作战地图
                        if (CurrencyMap.ContainsKey(currId))
                        {
                            return CurrencyMap[currId];
                        }
                        break;
                    default:
                        break;
                }
            }
            return 0;
        }
        #endregion

        #region 背包
        /// <summary>
        /// 字典用来存储所有背包，键是背包ID
        /// </summary>
        public Dictionary<int, BagBase> bagDict = new Dictionary<int, BagBase>();
        /// <summary>
        /// 添加一个新的背包
        /// </summary>
        /// <param name="bag"></param>
        /// <exception cref="ArgumentException"></exception>
        public bool AddBag(BagData bag)
        {
            if (!bagDict.ContainsKey(bag.BagId))
            {
                bagDict[bag.BagId] = new BagBase(bag.BagId);
                return true;
            }
            else
            {
                Log.Error("具有相同ID的背包已经存在！背包id:" + bag.BagId);
                return false;
            }
        }

        /// <summary>
        /// 根据ID获取背包
        /// </summary>
        /// <param name="bagId"></param>
        /// <returns></returns>
        public BagBase GetBag(int bagId)
        {
            if (bagDict.ContainsKey(bagId))
            {
                return bagDict[bagId];
            }
            else
            {
                Log.Print("未找到具有给定ID的背包！BagId:", bagId);
                return null;
            }
        }

        /// <summary>
        /// 添加itemId道具，Num个，
        /// </summary>
        /// <returns></returns>
        public bool AddItemToBag(int itemId, int Num)
        {
            ItemData itemData = ConfigCache.GetItemData(itemId);
            BagBase bagBase = GetBag(itemData.BagId);
            if (bagBase != null)
            {
                bagBase.AddItem(new ItemBase(itemId, Num));
                return true;
            }
            return false;
        }

        /// <summary>
        /// 添加ItemData 的初始化道具，存档创建时使用的
        /// </summary>
        /// <returns></returns>
        public bool AddItemToBag(ItemData itemData)
        {
            BagBase bagBase = GetBag(itemData.BagId);
            if (bagBase != null)
            {
                bagBase.AddItem(new ItemBase(itemData.ItemId, itemData.InitNum));
                return true;
            }
            return false;
        }

        #endregion
    }
}