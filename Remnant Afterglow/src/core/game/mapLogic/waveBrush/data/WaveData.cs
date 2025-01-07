
using GameLog;
using System;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 这是一个波次的数据
    /// </summary>
    public class WaveData
    {
        /// <summary>
        /// 波数配置
        /// </summary>
        public WaveBase cfgData;
        /// <summary>
        /// 波数
        /// </summary>
        public int WaveId = 0;


        /// <summary>
        /// 当前要刷新的组数-每次只加1
        /// </summary>
        public int nowGroupId = 1;
        /// <summary>
        /// 最大的可刷新组id-当刷新组大于这个id时，刷新结束
        /// </summary>
        public int MaxGroupId;
        /// <summary>
        /// 上一次组刷新的帧数,分组刷新中为0表示还没开始刷新
        /// </summary>
        public double LastGroupFlushFrame = 0;
        /// <summary>
        /// 本波已刷新的组号
        /// </summary>
        public List<int> HistoryGroupList = new List<int>();
        /// <summary>
        /// 这一波是否刷新完毕
        /// </summary>
        public bool is_flush_acc = false;

        public WaveData(Dictionary<string, object> dict)
        {
            cfgData = new WaveBase(dict);
            WaveId = cfgData.WaveId;

            MaxGroupId = 0;//设置最大组号，
            switch (cfgData.WaveType)
            {
                case 1://固定方式刷怪
                    foreach (List<int> DataList in cfgData.WaveData)
                    {
                        if (DataList[0] > MaxGroupId)
                            MaxGroupId = DataList[0];
                    }
                    foreach (List<int> DataList in cfgData.WaveData2)
                    {
                        if (DataList[0] > MaxGroupId)
                            MaxGroupId = DataList[0];
                    }
                    break;
                default:
                    break;
            }
        }

        /// <summary>
        /// 刷新敌人
        /// </summary>
        /// <returns><<怪物id,阵营id>,数量></returns>
        public Dictionary<KeyValuePair<int, int>, int> GetUnitDict(double nowTime, double frameNumber)
        {
            Dictionary<KeyValuePair<int, int>, int> dict = new Dictionary<KeyValuePair<int, int>, int>();
            switch (cfgData.WaveType)
            {
                case 0://不刷新
                    is_flush_acc = true;
                    return dict;
                case 1://固定刷新
                    List<List<int>> list = cfgData.WaveData;//单体
                    List<List<int>> list2 = cfgData.WaveData2;//群体
                    switch (cfgData.WaveWay)
                    {
                        case 1://全部一次性刷新
                            foreach (List<int> DataList in list)
                            {
                                dict[new KeyValuePair<int, int>(DataList[1], DataList[2])] = DataList[3];
                            }
                            is_flush_acc = true;
                            return dict;
                        case 2://分组刷新
                            if (LastGroupFlushFrame == 0 || frameNumber >= LastGroupFlushFrame + cfgData.WaveTime)//间隔足够时间后
                            {
                                if (!HistoryGroupList.Contains(nowGroupId))//历史刷新组数中不存在当前要刷新的组
                                {
                                    for (int i = 0; i < list.Count; i++)
                                    {
                                        if (list[i][0] == nowGroupId)
                                            dict[new KeyValuePair<int, int>(list[i][1], list[i][2])] = list[i][3];
                                    }
                                    AddHistory(nowGroupId);
                                    LastGroupFlushFrame = frameNumber;
                                    nowGroupId++;
                                }
                                if (dict.Count == 0)
                                    is_flush_acc = true;
                            }
                            return dict;
                        default:
                            return dict;
                    }
                case 2://随机刷新
                    return dict;
                default:
                    return dict;
            }
        }

        //增加历史记录
        public void AddHistory(int GroupId)
        {
            HistoryGroupList.Add(GroupId);
        }
    }
}
