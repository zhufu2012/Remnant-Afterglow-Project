using GameLog;

namespace Remnant_Afterglow{
    /// <summary>
    /// 默认模式
    /// </summary>
    public class Default_State : IState
    {
        public StateMachine stateMachine { get; set; }
        public Default_State(StateMachine stateMachine)
        {
            this.stateMachine = stateMachine;
        }

        public void Enter(StateMachine stateMachine)
        {
            stateMachine.baseObject.PlayAnima(ObjectStateNames.Default);//播放动画
        }

        public void Exit()
        {
            // 退出闲置状态时的操作
        }

        public void Update(double delta)
        {
            // 每帧更新闲置状态逻辑
        }

        public void FixedUpdate(double delta)
        {
            // 固定频率更新闲置状态逻辑
        }
    }

}