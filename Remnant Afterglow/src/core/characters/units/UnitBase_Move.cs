using GameLog;
using Godot;
using System;
using System.Collections.Generic;

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
        /// 旋转完成阈值（弧度）
        /// </summary>
        private float rotationThreshold = 0.01f;

        public override void InitMove()
        {
            base.InitMove();
        }



        /// <summary>
        /// 设置需要移动到的目标位置-地图格子位置
        /// </summary>
        /// <param name="targetMapPos"></param>
        public void SetMovementTarget(Vector2I targetMapPos)
        {
            if (baseData.IsMove)//是否可以移动
            {
                //检查是否还需要移动
                //1.确定目标是否足够近
                Vector2 targetPos = MapCopy.GetCellCenter(targetMapPos);//根据地图格子计算对应位置
                this.targetPos = targetPos;
                flow = FlowFieldSystem.Instance.AddPosFlowField(targetMapPos, 1);//尝试创建流场,存在类似流场就直接返回
                if (flow.IsPositionReachable(MapCopy.GetWorldPos(GlobalPosition)))//检查实体是否能到达终点
                {
                    stateMachine.ChangeState(new Move_State(stateMachine));
                    FlowFieldSystem.Instance.ShowFlowField = flow;//只是显示用-去掉就没有显示的流场了
                }
            }
        }

        /// <summary>
        /// 执行移动操作
        /// </summary>
        public override void DoMove(double delta)
        {
            mapPos = MapCopy.GetWorldPos(AnimatedSprite.GlobalPosition);

            if (GetDistance() > unitLogic.PathfindingDis)
            {
                var mapSpeed = GetMaxSpeed();

                // 获取流场方向
                Vector2 flowDirection = GetFlowDirection(mapPos);

                if (flowDirection != Vector2.Zero)
                {
                    // 计算目标角度（考虑Godot坐标系）
                    float targetAngle = flowDirection.Angle() + Mathf.Pi / 2;

                    // 处理当前角度与目标角度的差值
                    float angleDifference = Mathf.Abs(Mathf.Wrap(AnimatedSprite.Rotation - targetAngle,
                        -Mathf.Pi, Mathf.Pi));

                    // 需要旋转时处理
                    if (angleDifference > rotationThreshold)
                    {
                        // 使用线性插值平滑旋转
                        AnimatedSprite.Rotation = (float)Mathf.LerpAngle(
                            AnimatedSprite.Rotation,
                            targetAngle,
                            GetRotateSpeed() * (float)delta
                        );

                        // 旋转时停止移动
                        //Velocity = Vector2.Zero;
                        //MoveAndSlide();
                        //return; // 中断移动处理
                    }
                }

                // 旋转完成后处理移动
                Vector2 steeringForce = FlowFieldDirection(mapPos, mapSpeed) * 8;
                Vector2 avoidanceForce = Force(mapPos) * 8;

                Velocity += new Vector2(
                    (float)(steeringForce.X * delta),
                    (float)(steeringForce.Y * delta)
                );

                Velocity += new Vector2(
                    (float)(avoidanceForce.X * delta),
                    (float)(avoidanceForce.Y * delta)
                );

                // 限速处理
                if (Velocity.Length() > mapSpeed)
                {
                    Velocity = Velocity.Normalized() * mapSpeed;
                }
                MoveAndSlide();
            }
            else
            {
                Velocity = Vector2.Zero;
            }


        }

        /// <summary>
        /// 获取当前流场方向（新增方法）
        /// </summary>
        private Vector2 GetFlowDirection(Vector2 worldPos)
        {
            int x = (int)worldPos.X;
            int y = (int)worldPos.Y;

            // 边界检查
            if (!flow.IsValid(x, y)) return Vector2.Zero;

            // 获取周围四个点的方向并进行双线性插值
            Vector2 f00 = flow.GetDirection(x, y);
            Vector2 f10 = flow.GetDirection(x + 1, y);
            Vector2 f01 = flow.GetDirection(x, y + 1);
            Vector2 f11 = flow.GetDirection(x + 1, y + 1);

            float xWeight = worldPos.X - x;
            float yWeight = worldPos.Y - y;

            // 水平插值
            Vector2 top = f00.Lerp(f10, xWeight);
            Vector2 bottom = f01.Lerp(f11, xWeight);

            // 垂直插值
            return top.Lerp(bottom, yWeight).Normalized();
        }

        public Vector2 Force(Vector2 pos)
        {
            int x = (int)pos.X;
            int y = (int)pos.Y;
            if (!flow.IsValid(x, y))
            {
                // 计算斥力
                Vector2 repulsionForce = CalculateRepulsionForce(GlobalPosition, new Vector2(x + 0.5f, y + 0.5f) * MapConstant.TileCellSize);
                return repulsionForce;
            }
            return Vector2.Zero;
        }

        /// <summary>
        /// 转向行为流场-纯流场
        /// </summary>
        /// <param name="pos"></param>
        /// <returns></returns>
        public Vector2 FlowFieldDirection(Vector2 pos, float mapSpeed)//祝福注释-整个流场都可优化，比如优化为使用二维列表来保存流场矢量数据
        {
            int x = (int)pos.X;
            int y = (int)pos.Y;
            var f00 = flow.IsValid(x, y) ? flow.GetDirection(x, y) : Vector2.Zero;
            var f01 = flow.IsValid(x, y) ? flow.GetDirection(x, y) : Vector2.Zero;
            var f10 = flow.IsValid(x, y) ? flow.GetDirection(x, y) : Vector2.Zero;
            var f11 = flow.IsValid(x, y) ? flow.GetDirection(x, y) : Vector2.Zero;

            var xWeight = pos.X - x;
            var top = f00 * (1 - xWeight) + f10 * xWeight;
            var bottom = f01 * (1 - xWeight) + f11 * xWeight;

            var yWeight = pos.Y - y;
            var direction = (top * (1 - yWeight) + bottom * yWeight).Normalized();
            var desiredVelocity = direction * mapSpeed;
            var velocityChange = desiredVelocity - Velocity;

            return velocityChange * (GetMaxSpeed() / mapSpeed);
        }
        private Vector2 CalculateRepulsionForce(Vector2 entityPos, Vector2 blockCenter)
        {
            // 计算从entityPos到blockCenter的方向
            Vector2 directionToCenter = blockCenter - entityPos;
            // 反转方向得到斥力方向
            Vector2 repulsionDirection = -directionToCenter.Normalized();

            // 设置斥力大小（可以根据需求调整）
            float repulsionMagnitude = 2000f; // 示例值

            return repulsionDirection * repulsionMagnitude;
        }

        /// <summary>
        /// 实体与目标的距离
        /// </summary>
        /// <returns></returns>
        public float GetDistance()
        {
            return GlobalPosition.DistanceTo(targetPos);
        }

    }
}