
using GameLog;
using System;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    //这是一个波次的数据
    public class WaveData
    {
        //波数配置
        public WaveBase cfgData;
        //波数
        public int WaveId = 0;
        //当前要刷新的组数
        public int nowGroupId = 1;
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

        }

        /// <summary>
        /// 刷新怪物
        /// </summary>
        /// <returns><<怪物id,阵营id>,数量></returns>
        public Dictionary<KeyValuePair<int, int>, int> GetUnitDict()
        {
            Dictionary<KeyValuePair<int, int>, int> dict = new Dictionary<KeyValuePair<int, int>, int>();
            switch (cfgData.WaveType)
            {
                case 0://不刷新
                    is_flush_acc = true;
                    return dict;
                case 1://固定刷新
                    List<List<int>> list = cfgData.WaveData;
                    switch (cfgData.WaveWay)
                    {
                        case 1://全部刷新
                            for (int i = 0; i < list.Count; i++)
                            {
                                dict[new KeyValuePair<int, int>(list[i][1], list[i][2])] = list[i][3];
                            }
                            is_flush_acc = true;
                            return dict;
                        case 2://分组刷新
                            if (!HistoryGroupList.Contains(nowGroupId))//历史刷新组数中不存在当前要刷新的组
                            {
                                for (int i = 0; i < list.Count; i++)
                                {
                                    if (list[i][0] == nowGroupId)
                                        dict[new KeyValuePair<int, int>(list[i][1], list[i][2])] = list[i][3];
                                }
                                AddHistory(nowGroupId);
                                nowGroupId++;
                            }
                            if (dict.Count == 0)
                                is_flush_acc = true;
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
