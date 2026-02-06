using GameLog;
using Godot;
using SteeringBehaviors;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 地图游戏模式-各类模式都继承于此
    /// </summary>
    public partial class GameModel : Node2D
    {

        /// <summary>
        /// 是否已开始逻辑
        /// </summary>
        public bool IsStart = false;
        /// <summary>
        /// 是否已结束副本
        /// </summary>
        public bool IsEnd = false;

        /// <summary>
        /// 模式的每帧刷新逻辑
        /// </summary>
        public virtual void PostUpdate(double delta)
        {
        }

        /// <summary>
        /// 开始模式的逻辑
        /// </summary>
        public virtual void StartModel()
        {
            IsStart = true;
            InitData();//初始化数据
        }

        /// <summary>
        /// 结束模式的逻辑
        /// </summary>
        public virtual void EndModel()
        {
            IsEnd = true;
        }

        /// <summary>
        /// 初始化数据
        /// </summary>
        public virtual void InitData()
        {
        }

        /// <summary>
        /// 是否关卡结束
        /// </summary>
        /// <returns></returns>
        public virtual bool IsCopyEnd()
        {
            //是否已刷新完所有波次敌人 并且 所有单位都死亡
            return IsEnd && ObjectManager.Instance.unitDict.Count == 0;
        }
    }
}
