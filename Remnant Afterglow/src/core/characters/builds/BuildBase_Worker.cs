

using GameLog;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 工作状态代码
    /// </summary>
    public enum WorkState
    {
        Building,//建造中状态
        Work,//开始工作  等待生产周期完成，就添加资源
    }

    /// <summary>
    /// 建筑 工作代码
    /// </summary>
    public partial class BuildBase : BaseObject, IBuild
    {
        /// <summary>
        /// 开始是建造中状态
        /// </summary>
        public WorkState workState { get; set; } = WorkState.Building;
        /// <summary>
        /// 周期时间积累
        /// </summary>
        public double WeekTime = 0;

        /// <summary>
        /// 工作流程-每秒运行一次
        /// </summary>
        public void DoWork()
        {
            switch (workState)
            {
                case WorkState.Work:
                    if (WeekTime >= buildData.WeekLength)
                    {
                        WeekTime = 0;
                        foreach (List<int> info in buildData.WeekResources)//生产资源
                        {
                            BagSystem.Instance.AddCurrency(info[0], info[1]);
                            MapOpView.Instance.SetCurrencyView();
                        }
                    }
                    else
                        WeekTime += 1;
                    break;
                default: break;
            }
        }





    }
}
