using GameLog;
using Godot;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 移动状态
    /// </summary>
    public class Move_State : IState
    {
        public StateMachine stateMachine { get; set; }

        public Move_State(StateMachine stateMachine)
        {
            this.stateMachine = stateMachine;
        }

        /// <summary>
        /// 进入移动状态时的操作
        /// </summary>
        /// <param name="stateMachine"></param>
        public void Enter(StateMachine stateMachine)
        {
            if (stateMachine.baseObject.object_type == BaseObjectType.BaseUnit)
            {
                UnitBase unitBase = stateMachine.baseObject as UnitBase;
                unitBase.PlayAnima(ObjectStateNames.Move);
            }
        }

        public void Exit()
        {
            // 退出移动状态时的操作
        }

        public void Update(double delta)
        {
        }

        public void FixedUpdate(double delta)
        {
            // 固定频率更新移动状态逻辑
        }
    }
}