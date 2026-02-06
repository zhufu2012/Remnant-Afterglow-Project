using GameLog;

namespace Remnant_Afterglow
{
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
            switch (stateMachine.baseObject.object_type)
            {
                case BaseObjectType.BaseTower:
                    TowerBase tower = stateMachine.baseObject as TowerBase;
                    tower.PlayAnima(ObjectStateNames.Default);
                    break;
                case BaseObjectType.BaseBuild:
                    BuildBase build = stateMachine.baseObject as BuildBase;
                    build.PlayAnima(ObjectStateNames.Default);
                    break;
                case BaseObjectType.BaseWorker:
                    WorkerBase worker = stateMachine.baseObject as WorkerBase;
                    worker.PlayAnima(ObjectStateNames.Default);
                    break;
                case BaseObjectType.BaseUnit:
                    UnitBase unitBase = stateMachine.baseObject as UnitBase;
                    unitBase.PlayAnima(ObjectStateNames.Default);
                    break;
                default:
                    break;
            }
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