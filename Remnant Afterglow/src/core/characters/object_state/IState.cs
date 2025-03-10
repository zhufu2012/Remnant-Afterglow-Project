namespace Remnant_Afterglow{
    public interface IState
    {
        StateMachine stateMachine { get;set; }
        /// <summary>
        /// 进入该状态的操作
        /// </summary>
        /// <param name="stateMachine"></param>
        void Enter(StateMachine stateMachine);
        /// <summary>
        /// 退出该状态的操作
        /// </summary>
        void Exit();
        /// <summary>
        /// 每帧更新状态
        /// </summary>
        /// <param name="delta"></param>
        void Update(double delta);
        /// <summary>
        /// 固定频率更新状态
        /// </summary>
        /// <param name="delta"></param>
        void FixedUpdate(double delta);
    }
}