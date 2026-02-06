using Godot;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 实体逻辑 - 状态机
    /// </summary>
    public partial class BaseObject : Area2D, IPoolItem
    {
        /// <summary>
        /// 通用状态机类
        /// </summary>
        public StateMachine stateMachine;

        /// <summary>
        /// 初始化状态数据
        /// </summary>
        public void InitStateData()
        {
            stateMachine = new StateMachine(this);
            switch (object_type)
            {
                case BaseObjectType.BaseTower:
                case BaseObjectType.BaseBuild://建筑
                    if (Source == 0)//地图生成时创建
                    {
                        stateMachine.ChangeState(new Default_State(stateMachine));
                    }
                    else//正常创建
                    {
                        stateMachine.ChangeState(new UnderBuild_State(stateMachine));//建造中
                    }
                    break;
                default:
                    stateMachine.ChangeState(new Default_State(stateMachine));
                    break;
            }
        }
    }
}