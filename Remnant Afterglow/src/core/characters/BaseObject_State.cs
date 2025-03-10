using Godot;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 实体逻辑 - 状态机
    /// </summary>
    public partial class BaseObject : CharacterBody2D, IPoolItem
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
            switch(object_type)
            {
                case BaseObjectType.BaseTower:
                case BaseObjectType.BaseBuild:
                     stateMachine.ChangeState(new UnderBuild_State(stateMachine));//建造中
                    break;
                default:
                     stateMachine.ChangeState(new Default_State(stateMachine));
                    break;
            }
        }


        /// <summary>
        /// 每绘图帧更新
        /// </summary>
        /// <param name="delta"></param>
        public void StateUpdate(double delta)
        {
            stateMachine.Update(delta);
        }
        /// <summary>
        /// 每物理帧更新
        /// </summary>
        /// <param name="delta"></param>
        public void StatePhysicsProcess(double delta)
        {
            stateMachine.FixedUpdate(delta);
        }
    }
}