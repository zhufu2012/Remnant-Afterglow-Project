using GameLog;
using System;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 游戏存档数据
    /// </summary>
    [Serializable]
    public partial class SaveData
    {
        /// <summary>
        /// 最后保存时，游戏的版本
        /// </summary>
        public int version;


        /// <summary>
        /// 开局选择的章节
        /// </summary>
        public int ChapterId;
        /// <summary>
        /// 已占领关卡 <章节id,关卡id>
        /// </summary>
        public Dictionary<int, List<int>> CaptureCopyDict = new Dictionary<int, List<int>>();
        /// <summary>
        /// 已解锁可挑战关卡 <章节id,关卡id>
        /// </summary>
        public Dictionary<int, List<int>> UnlockChallengeCopyDict = new Dictionary<int, List<int>>();

        /// <summary>
        /// 已解锁的科技id列表，默认解锁的也会记录
        /// </summary>
        public List<int> ScienceIdList = new List<int>();
        /// <summary>
        /// 背包系统数据
        /// </summary>
        public BagSystem bagSystem = new BagSystem();

        /// <summary>
        /// 创建存档时运行
        /// </summary>
        public SaveData()
        {
        }

        /// <summary>
        /// 创建存档后的，数据初始化
        /// </summary>
        public void CreateInitData()
        {
            version = GameConstant.game_version;//设置存档 版本
            InitScienceData();//初始化科技相关数据
            InitBagSystemData();//初始化背包相关数据
            InitAttainmentData();//初始化成就数据
            InitChapterCopyData();//初始化章节关卡数据
        }


        /// <summary>
        /// 初始化科技相关数据
        /// </summary>
        public void InitScienceData()
        {
            List<ScienceData> science_list = ConfigCache.GetAllScienceData();
            foreach (ScienceData science_base in science_list)
            {
                //该科技默认解锁 并且 列表中没有该科技，将科技添加进去
                if (science_base.IsUnlock && !ScienceIdList.Contains(science_base.ScienceId))
                {
                    ScienceIdList.Add(science_base.ScienceId);
                }
            }
        }

        /// <summary>
        /// 初始化背包 的道具和数据
        /// </summary>
        public void InitBagSystemData()
        {
            List<BagData> bagDataList = ConfigCache.GetAllBagData();//背包初始化
            foreach (BagData bagData in bagDataList)
            {
                bagSystem.AddBag(bagData);
            }

            List<ItemData> itemDataList = ConfigCache.GetAllItemData();//道具初始化
            foreach (ItemData itemData in itemDataList)
            {
                if (itemData.InitNum > 0)
                    bagSystem.AddItemToBag(itemData);
            }

            List<MoneyBase> moneyBaseList = ConfigCache.GetAllMoneyBase();//货币初始化
            foreach (MoneyBase moneyBase in moneyBaseList)
            {
                bagSystem.CreateBigMapCurrency(moneyBase);
            }
        }

        ///初始化成就数据
        public void InitAttainmentData()
        {

        }

        //初始化章节关卡数据
        public void InitChapterCopyData()
        {
        }





    }
}