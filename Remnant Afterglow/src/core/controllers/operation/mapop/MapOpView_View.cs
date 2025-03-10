

using GameLog;
using Godot;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 地图操作界面-界面代码
    /// </summary>
	public partial class MapOpView : Control
    {
        public ImageNum imageNum11;
        public ImageNum imageNum12;
        public ImageNum imageNum21;
        public ImageNum imageNum22;
        public ImageNum ImageNum31;
        public ImageNum ImageNum32;
        public ImageNum ImageNum41;
        public ImageNum ImageNum42;
        public BuildList buildOpList;
        /// <summary>
        /// 初始化界面
        /// </summary>
        public void InitView()
        {
            imageNum11 = GetNode<ImageNum>("顶部资源列表/万能齿轮资源数1");
            imageNum12 = GetNode<ImageNum>("顶部资源列表/万能齿轮资源数2");

            imageNum21 = GetNode<ImageNum>("顶部资源列表/怨灵水晶资源数1");
            imageNum22 = GetNode<ImageNum>("顶部资源列表/怨灵水晶资源数2");

            ImageNum31 = GetNode<ImageNum>("顶部资源列表/次元岛溶剂资源数1");
            ImageNum32 = GetNode<ImageNum>("顶部资源列表/次元岛溶剂资源数2");

            ImageNum41 = GetNode<ImageNum>("波次列表/当前波次");
            ImageNum42 = GetNode<ImageNum>("波次列表/总波次");
            buildOpList = GetNode<BuildList>("BuildList");
        }


        /// <summary>
        /// 根据货币数据，更新显示的资源量
        /// </summary>
        public void SetCurrencyView()
        {
            imageNum11.SetNum(BagSystem.Instance.GetCurrency(MapConstant.MoneyId_1));
            imageNum21.SetNum(BagSystem.Instance.GetCurrency(MapConstant.MoneyId_2));
            ImageNum31.SetNum(BagSystem.Instance.GetCurrency(MapConstant.MoneyId_3));
            SetAddCurrencyView();
        }



        /// <summary>
        /// 资源制造速度
        /// </summary>
        public Dictionary<int, int> AddCurrencyMap = new Dictionary<int, int>();
        /// <summary>
        /// 根据建筑生产资源量，计算平均生产资源速度
        /// </summary>
        public void SetAddCurrencyView()
        {
            AddCurrencyMap.Clear();
            AddCurrencyMap[MapConstant.MoneyId_1] = 0;
            AddCurrencyMap[MapConstant.MoneyId_2] = 0;
            AddCurrencyMap[MapConstant.MoneyId_3] = 0;
            foreach (var info in ObjectManager.Instance.buildDict)
            {
                BuildData buildData = info.Value.buildData;
                foreach (List<int> list in buildData.WeekResources)
                {
                    int currId = list[0];
                    int num = list[1];
                    if (AddCurrencyMap.ContainsKey(currId))
                    {
                        AddCurrencyMap[currId] += num / buildData.WeekLength;
                    }
                    else
                    {
                        AddCurrencyMap[currId] = num / buildData.WeekLength;
                    }
                }
            }
            foreach (var info in ObjectManager.Instance.towerDict)
            {
                BuildData buildData = info.Value.buildData;
                foreach (List<int> list in buildData.WeekResources)
                {
                    int currId = list[0];
                    int num = list[1];
                    if (AddCurrencyMap.ContainsKey(currId))
                    {
                        AddCurrencyMap[currId] += num / buildData.WeekLength;
                    }
                    else
                    {
                        AddCurrencyMap[currId] = num / buildData.WeekLength;
                    }
                }
            }
            imageNum12.SetNum(AddCurrencyMap[MapConstant.MoneyId_1]);
            imageNum22.SetNum(AddCurrencyMap[MapConstant.MoneyId_2]);
            ImageNum32.SetNum(AddCurrencyMap[MapConstant.MoneyId_3]);
        }


        /// <summary>
        /// 设置当前波次
        /// </summary>
        public void SetNowWave(int NowWave)
        {
            ImageNum41.SetNum(NowWave);
        }

        /// <summary>
        /// 设置总波次
        /// </summary>
        public void SetAllWave(int AllWave)
        {
            ImageNum42.SetNum(AllWave);
        }

    }
}
