using GameLog;
using Godot;
using ManagedAttributes;
using SteeringBehaviors;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 地图逻辑-属性
    /// </summary>
    public partial class MapLogic : Node2D
    {
        /// <summary>
        /// 全局属性容器
        /// </summary>
        public ManagAttrCon attrCon = new ManagAttrCon();


        /// <summary>
        /// 当前帧数
        /// </summary>
        public ulong NowTick = 0;

        /// <summary>
        /// 初始化全局属性
        /// </summary>
        public void InitAttribute()
        {
            foreach(int tem_id in chapterCopy.GloTemList)
            {
                GlobalAttrTem tem = ConfigCache.GetGlobalAttrTem(tem_id);

            }
        }


        public void Update(double delta)
        {
            NowTick++;
            attrCon.Update(NowTick);//属性系统刷新
        }
    }

}