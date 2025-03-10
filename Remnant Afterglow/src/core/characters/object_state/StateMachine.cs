using System;
using Godot;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 通用状态机类
    /// </summary>
    public partial class StateMachine : Node
    {
        private IState currentState;
        public BaseObject baseObject;
        public StateMachine(BaseObject baseObject)
        {
            this.baseObject = baseObject;
        }

        public void ChangeState(IState newState)
        {
            if (currentState != null)
            {
                currentState.Exit();
            }
            currentState = newState;
            if (currentState != null)
            {
                currentState.Enter(this);
            }
        }

        public void Update(double delta)
        {
            if (currentState != null)
            {
                currentState.Update(delta);
            }
        }

        public void FixedUpdate(double delta)
        {
            if (currentState != null)
            {
                currentState.FixedUpdate(delta);
            }
        }
    }
}