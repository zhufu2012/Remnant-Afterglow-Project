
using GameLog;
using Godot;
using ManagedAttributes;
using SteeringBehaviors;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 陆地单位
    /// </summary>
    public partial class LandUnit : UnitBase, IUnit
    {

        /// <summary>
        /// 旋转完成阈值（弧度）
        /// </summary>
        private float rotationThreshold = 0.01f;

        /// <summary>
        /// 最大速度
        /// </summary>
        private float maxSpeed = 0f;
        /// <summary>
        /// 最大旋转速度
        /// </summary>
        private float maxRotateSpeed = 0f;


        private Vector2 now_force;
        public override void InitMove()
        {
            base.InitMove();
            maxSpeed = attributeContainer[Attr.Attr_40].Get<float>(AttrDataType.Max);
            maxRotateSpeed = attributeContainer[Attr.Attr_42].Get<float>(AttrDataType.Max);
        }


        /// <summary>
        /// 初始化运动块
        /// </summary>
        public override void InitObjectMove()
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
        public override void SetMovementTarget(Vector2I targetMapPos)
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
        public override void DoMove(float delta)
        {
            now_force = new Vector2(0, 0);
            mapPos = MapCopy.GetWorldPos(AnimatedSprite.GlobalPosition);
            bool IsPass = flow.IsValid(mapPos.X, mapPos.Y);//是否可通行
            // 没有到达过终点，并且距离不在范围内，就计算流场
            if (!IsEnd)
            {
                if (GlobalPosition.DistanceTo(targetPos) > unitLogic.PathfindingDis)
                {
                    if (IsPass)//可通行
                    {
                        Vector2 flowDirection = flow.GetDirection(mapPos.X, mapPos.Y);
                        // 计算目标角度（考虑Godot坐标系）
                        float targetAngle = flowDirection.Angle() + Mathf.Pi / 2;
                        // 处理当前角度与目标角度的差值
                        float angleDifference = Mathf.Abs(Mathf.Wrap(AnimatedSprite.Rotation - targetAngle,
                            -Mathf.Pi, Mathf.Pi));
                        // 需要旋转时处理
                        if (angleDifference > rotationThreshold)
                        {
                            // 使用线性插值平滑旋转
                            AnimatedSprite.Rotation = Mathf.LerpAngle(
                                AnimatedSprite.Rotation,
                                targetAngle,
                                maxRotateSpeed * delta
                            );
                        }
                    }
                    now_force += FlowFieldDirection(mapPos) * delta;
                }
                else
                {
                    IsEnd = true;
                    stateMachine.ChangeState(new Default_State(stateMachine));
                }
            }
            now_force += steering.steer_force;
            if (!IsPass)//不可通行，计算墙壁斥力
                now_force += CalculateRepulsionForce(GlobalPosition, MapCopy.GetCellCenter(mapPos));
            Velocity += now_force;
            Velocity *= 0.9f;
            if (Velocity != Vector2.Zero && Velocity.Length() > maxSpeed)
            {
                Velocity = Velocity.Normalized() * maxSpeed;
            }
            Position += Velocity * delta;
        }

        /// <summary>
        /// 转向行为流场-纯流场
        /// </summary>
        /// <param name="pos"></param>
        /// <returns></returns>
        public Vector2 FlowFieldDirection(Vector2I pos)
        {
            Vector2 f00 = flow.IsValid(pos.X, pos.Y) ? flow.GetDirection(pos.X, pos.Y) : Vector2.Zero;
            // 安全归一化处理
            if (f00 != Vector2.Zero)
                f00 = f00.Normalized();
            return (f00 * maxSpeed - Velocity) * maxSpeed;
        }
        /// <summary>
        /// 墙壁斥力
        /// </summary>
        /// <param name="entityPos"></param>
        /// <param name="blockCenter"></param>
        /// <returns></returns>
        private Vector2 CalculateRepulsionForce(Vector2 entityPos, Vector2 blockCenter)
        {
            return (blockCenter - entityPos).Normalized() * -200f;//设置斥力大小
        }
    }
}
