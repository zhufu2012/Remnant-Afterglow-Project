
using GameLog;
using Godot;
using System.Collections.Generic;
using System.Linq;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 刷怪点数据类
    /// </summary>
    public class CopyBrushData
    {
        /// <summary>
		/// 刷新点id
		/// </summary>
        public int BrushId = 0;
        /// <summary>
        /// 刷怪点数据
        /// </summary>
        public BrushPoint cfgData;

        /// <summary>
        /// <波数,波数数据>
        /// </summary>
        public Dictionary<int, WaveData> waveDataDict = new Dictionary<int, WaveData>();
        /// <summary>
        /// 坐标列表
        /// </summary>
        public List<Vector2I> points = new List<Vector2I>();
        public CopyBrushData(int BrushId, BrushPoint cfgData, Vector2I start, Vector2I end)
        {
            this.BrushId = BrushId;
            this.cfgData = cfgData;
            foreach (int waveId in cfgData.WaveIdList)//遍历刷新点的波数
            {
                WaveBase waveBase = ConfigCache.GetWaveBase(cfgData.BrushId + "_" + waveId);
                if (waveBase != null)
                    waveDataDict[waveId] = new WaveData(waveBase);
            }

            // 确保坐标范围正确
            int minX = start.X;
            int maxX = start.X + end.X;
            int minY = start.Y;
            int maxY = start.Y + end.Y;
            // 遍历所有整数坐标点
            for (int x = minX; x <= maxX; x++)
            {
                for (int y = minY; y <= maxY; y++)
                {
                    points.Add(new Vector2I(x, y));
                }
            }
        }


        /// <summary>
        /// 获取某一波要刷的怪物列表
        /// </summary>
        public List<List<int>> GetWaveBrushList(int wave)
        {
            if (waveDataDict.ContainsKey(wave))//有该波数据
            {
                return waveDataDict[wave].GetWaveData();
            }
            return new List<List<int>>();
        }


        /// <summary>
        /// 检查所有波次是否刷新完成
        /// </summary>
        /// <returns></returns>
        public bool CheckAllWaveFlush()
        {
            foreach (var info in waveDataDict)
            {
                if (!info.Value.is_flush_acc)
                {
                    return false;
                }
            }
            return false;
        }

    }
}
