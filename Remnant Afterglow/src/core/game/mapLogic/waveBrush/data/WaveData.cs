
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
        /// 波数
        /// </summary>
        public int WaveId = 0;
        /// <summary>
        /// 波数配置
        /// </summary>
        public WaveBase cfgData;

        /// <summary>
        /// 这一波是否刷新完毕
        /// </summary>
        public bool is_flush_acc = false;

        public WaveData(WaveBase cfgData)
        {
            WaveId = cfgData.WaveId;
            this.cfgData = cfgData;
        }

        /// <summary>
        /// 获取该波要刷新的怪物列表
        /// </summary>
        /// <returns></returns>
        public List<List<int>> GetWaveData()
        {
            return cfgData.WaveUnitGroup;
        }

    }
}
