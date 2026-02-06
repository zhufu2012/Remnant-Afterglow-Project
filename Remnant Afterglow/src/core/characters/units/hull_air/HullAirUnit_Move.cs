using Godot;
using System;
using ManagedAttributes;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 空中机壳单位
    /// </summary>
    public partial class HullAirUnit : UnitBase, IUnit
    {
        // 飞行参数
        public float MaxSpeed = 200.0f;
        public float Acceleration = 80.0f;
        public float MaxTurnRate = 1.5f;         // 最大转向速率（弧度/秒）
        public float MinTurnRadius = 100.0f;      // 最小转弯半径
        public float StoppingDistance = 15.0f;
        public float BankingFactor = 0.2f;       // 转弯时倾斜系数

        private Vector2 _velocity;
        private Vector2 _targetPosition;
        private float _bankAngle;                 // 当前倾斜角度（用于视觉效果）

        public override void InitMove()
        {
            base.InitMove();
            MaxSpeed = attributeContainer[Attr.Attr_40].Get<float>(AttrDataType.Max);
            MaxTurnRate = attributeContainer[Attr.Attr_42].Get<float>(AttrDataType.Max);
        }

        public override void SetMovementTarget(Vector2I targetMapPos)
        {
            _targetPosition = new Vector2(targetMapPos.X, targetMapPos.Y) * MapConstant.TileCellSize;
        }

        public override void DoMove(float delta)
        {
            mapPos = MapCopy.GetWorldPos(AnimatedSprite.GlobalPosition);
            if (_targetPosition == Vector2.Zero) return;

            Vector2 toTarget = _targetPosition - GlobalPosition;
            float distanceToTarget = toTarget.Length();

            // 计算目标方向
            Vector2 targetDir = toTarget.Normalized();

            // 速度控制（接近目标时减速）
            float targetSpeed = MaxSpeed;
            if (distanceToTarget < StoppingDistance * 3)
            {
                targetSpeed = MaxSpeed * Mathf.Clamp(distanceToTarget / StoppingDistance, 0.1f, 1.0f);
            }

            // 转向逻辑（战斗机式圆弧转弯）
            if (_velocity.LengthSquared() > 1.0f)
            {
                Vector2 currentDir = _velocity.Normalized();
                float turnAngle = currentDir.AngleTo(targetDir);
                float turnDirection = Mathf.Sign(turnAngle);

                // 根据速度计算实际转弯半径
                float currentSpeed = _velocity.Length();
                float actualTurnRadius = Mathf.Max(MinTurnRadius, currentSpeed / MaxTurnRate);

                // 计算最大允许转弯角度
                float maxTurnAngle = (currentSpeed / actualTurnRadius) * delta;
                float appliedTurn = Mathf.Clamp(Mathf.Abs(turnAngle), 0, maxTurnAngle) * turnDirection;

                // 应用转弯
                _velocity = _velocity.Rotated(appliedTurn);

                // 更新倾斜角度（视觉效果）
                _bankAngle = Mathf.Lerp(_bankAngle, appliedTurn * BankingFactor * 50, 10 * delta);
            }
            else
            {
                // 低速时直接对准目标
                _velocity = targetDir * Mathf.Min(targetSpeed, Acceleration * delta);
                _bankAngle = Mathf.Lerp(_bankAngle, 0, 10 * delta);
            }

            // 加速/减速控制
            if (_velocity.Length() < targetSpeed)
            {
                _velocity = _velocity.MoveToward(targetDir * targetSpeed, Acceleration * delta);
            }
            else
            {
                _velocity = _velocity.MoveToward(targetDir * targetSpeed, Acceleration * 0.5f * delta);
            }

            // 更新位置
            Position += _velocity * delta;

            // 更新旋转（机头指向速度方向）
            if (_velocity.LengthSquared() > 0.1f)
            {
                Rotation = Mathf.Atan2(_velocity.Y, _velocity.X);
            }

            // 更新调试可视化
            QueueRedraw();
        }

        public override void _Draw()
        {
            // 绘制速度方向（红色）
            Vector2 velocityDir = _velocity.Normalized();
            DrawLine(Vector2.Zero, velocityDir * 50, Colors.Red, 2);

            // 绘制目标方向（绿色）
            if (_targetPosition != Vector2.Zero)
            {
                Vector2 targetDir = (_targetPosition - GlobalPosition).Normalized();
                DrawLine(Vector2.Zero, targetDir * 40, Colors.Green, 2);
            }

            // 绘制倾斜指示器（蓝色）
            Vector2 bankIndicator = new Vector2(0, 20).Rotated(_bankAngle);
            DrawLine(Vector2.Zero, bankIndicator, Colors.Blue, 2);
        }
    }
}