
using Godot;
using ManagedAttributes;
using SteeringBehaviors;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 单位移动
    /// </summary>
    public partial class UnitBase : BaseObject, IUnit
    {
        /// <summary>
        /// 单位所用的流场
        /// </summary>
        public FlowField flow;
        /// <summary>
        /// 目标位置
        /// </summary>
        public Vector2 targetPos;
        /// <summary>
        /// 目标位置-地图格子位置
        /// </summary>
        public Vector2 targetMapPos;
        /// <summary>
        /// 是否已到达过终点
        /// </summary>
        public bool IsEnd = false;

        public override void InitMove()
        {
        }

        /// <summary>
        /// 行为模式整合类
        /// </summary>
        public Steering steering;

        /// <summary>
        /// 初始化运动块
        /// </summary>
        public virtual void InitObjectMove()
        {
            if (baseData.IsMove)
            {
                steering = new Steering(this, baseData.ShapePointList[0], unitLogic.Mass);
            }
        }

        /// <summary>
        /// 设置需要移动到的目标位置-地图格子位置
        /// </summary>
        /// <param name="targetMapPos"> 目标的地图位置</param>
        /// <param name="BrushId"> 刷怪点id</param>
        public virtual void SetMovementTarget(Vector2I targetMapPos)
        {
            if (baseData.IsMove)//是否可以移动
            {
                IsEnd = false;//设置为未到达终点
                //检查是否还需要移动
                //1.确定目标是否足够近
                Vector2 targetPos = MapCopy.GetCellCenter(targetMapPos);//根据地图格子计算对应位置
                this.targetPos = targetPos;
                this.targetMapPos = targetMapPos;
                flow = FlowFieldSystem.Instance.AddPosFlowField(targetMapPos);//尝试创建流场,存在类似流场就直接返回
                if (flow.IsPositionReachable(MapCopy.GetWorldPos(GlobalPosition)))//检查实体是否能到达终点
                {
                    stateMachine.ChangeState(new Move_State(stateMachine));
                }
            }
        }


        /// <summary>
        /// 执行移动操作
        /// </summary>
        public virtual void DoMove(float delta)
        {
        }

    }
}