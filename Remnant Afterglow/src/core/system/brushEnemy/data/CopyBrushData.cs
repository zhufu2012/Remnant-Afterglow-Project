
using GameLog;
using Godot;
using System.Collections.Generic;
using System.Linq;

namespace Remnant_Afterglow
{
    public class CopyBrushData
    {
        //================================刷新点数据========================//
        /// <summary>
        /// 刷新点数据
        /// </summary>
        public BrushPoint cfgData;
        //刷新点id
        public int BrushId = 0;

        //<波数,波数数据>
        public Dictionary<int, WaveData> waveDataDict = new Dictionary<int, WaveData>();
        //================================刷新点数据========================//

        /// <summary>
        /// 所有波数是否刷新完毕
        /// </summary>
        public bool is_flush_acc = false;

        public CopyBrushData(int BrushId)
        {
            this.BrushId = BrushId;
            cfgData = ConfigCache.GetBrushPoint(BrushId);
            foreach (int waveId in cfgData.WaveIdList)//遍历刷新点的波数
            {
                Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_WaveBase, BrushId, waveId);
                if (dict != null)
                    waveDataDict[waveId] = new WaveData(dict);
            }
        }

        /// <summary>
        /// 检查该刷新点所有波次是否都刷新完
        /// </summary>
        /// <returns></returns>
        public bool CheckAllWaveFlush()
        {
            bool return_value = false;
            foreach (var info in waveDataDict)
            {
                if (waveDataDict[info.Key].is_flush_acc)
                {
                    return_value = true;
                    break;
                }
            }
            is_flush_acc = return_value;
            return return_value;
        }

        /// <summary>
        /// 计算刷新波数组的怪物
        /// </summary>
        /// <returns><<怪物id,阵营id>,数量></returns>
        public Dictionary<KeyValuePair<int, int>, int> CalcWaveUnit(int waveId)
        {
            if (waveDataDict.ContainsKey(waveId))
            {
                WaveData waveData = waveDataDict[waveId];
                if (!waveData.is_flush_acc)//没刷新完
                {
                    return waveData.GetUnitDict();
                }
                else
                {
                    is_flush_acc = true;
                    return new Dictionary<KeyValuePair<int, int>, int>();
                }
            }
            else
            {
                is_flush_acc = true;
                return new Dictionary<KeyValuePair<int, int>, int>();
            }

        }


        /// <summary>
        /// 返回刷新点范围内所有整数点
        /// </summary>
        /// <returns></returns>
        public List<Vector2I> GetBrushAllList()
        {
            List<Vector2I> vec_list = cfgData.Polygon.Select(v => v + cfgData.BrushPos).ToList();
            return PolygonHelper.GetPointListPolygon(vec_list);
        }

    }
}
