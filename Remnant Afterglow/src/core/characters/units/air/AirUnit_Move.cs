using Godot;
using System;
using ManagedAttributes;
namespace Remnant_Afterglow
{
    public partial class AirUnit : UnitBase, IUnit
    {
        // ========== 飞行单位参数配置 ==========

        /// <summary>最大飞行速度（像素/秒）</summary>
        public float MaxSpeed = 200.0f;
        /// <summary>加速度（像素/秒²）</summary>
        public float Acceleration = 80.0f;
        /// <summary>最大转向速率，单位：弧度/秒</summary>
        public float MaxTurnRate = 1.5f;
        /// <summary>最小转弯半径（像素），限制飞行器转弯的尖锐程度</summary>
        public float MinTurnRadius = 100.0f;
        /// <summary>倾斜系数，控制转弯时飞行器的倾斜程度</summary>
        public float BankingFactor = 0.2f;

        // ========== 内部状态变量 ==========

        /// <summary>当前速度向量，包含大小和方向</summary>
        private Vector2 _velocity;
        /// <summary>目标位置的世界坐标</summary>
        private Vector2 _targetPosition;
        /// <summary>当前倾斜角度（弧度），用于飞行器转弯时的倾斜视觉效果</summary>
        private float _bankAngle;

        /// <summary>
        /// 初始化移动参数，从属性容器中读取配置
        /// </summary>
        public override void InitMove()
        {
            base.InitMove();
            // 从属性系统读取最大速度、加速度和最大转向速率
            MaxSpeed = attributeContainer[Attr.Attr_40].Get<float>(AttrDataType.Max);
            Acceleration = attributeContainer[Attr.Attr_41].Get<float>(AttrDataType.Max);
            MaxTurnRate = attributeContainer[Attr.Attr_42].Get<float>(AttrDataType.Max);
            MinTurnRadius = attributeContainer[Attr.Attr_43].Get<float>(AttrDataType.Max);
            BankingFactor = attributeContainer[Attr.Attr_44].Get<float>(AttrDataType.Max);
        }

        /// <summary>
        /// 设置移动目标位置（地图格子坐标转换为世界坐标）
        /// </summary>
        /// <param name="targetMapPos">目标地图格子坐标</param>
        public override void SetMovementTarget(Vector2I targetMapPos)
        {
            // 将地图格子坐标转换为世界像素坐标
            _targetPosition = new Vector2(targetMapPos.X, targetMapPos.Y) * MapConstant.TileCellSize;
        }

        /// <summary>
        /// 执行移动逻辑（每帧调用）
        /// </summary>
        /// <param name="delta">帧时间间隔（秒）</param>
        public override void DoMove(float delta)
        {
            mapPos = MapCopy.GetWorldPos(AnimatedSprite.GlobalPosition);
            // 检查是否有有效目标位置
            if (_targetPosition == Vector2.Zero) return;

            // 计算到目标的向量和距离
            Vector2 toTarget = _targetPosition - GlobalPosition;
            float distanceToTarget = toTarget.Length();

            // 计算目标方向（单位向量）
            Vector2 targetDir = toTarget.Normalized();

            // ========== 速度控制逻辑 ==========
            // 始终以最大速度飞行，不进行减速
            float targetSpeed = MaxSpeed;

            // ========== 转向控制逻辑 ==========
            if (_velocity.LengthSquared() > 1.0f) // 检查是否有足够的速度进行转向
            {
                Vector2 currentDir = _velocity.Normalized();
                // 计算当前方向与目标方向之间的角度差
                float turnAngle = currentDir.AngleTo(targetDir);
                // 确定转弯方向（顺时针或逆时针）
                float turnDirection = Mathf.Sign(turnAngle);

                // 根据当前速度计算实际转弯半径
                float currentSpeed = _velocity.Length();
                // 确保转弯半径不小于最小限制
                float actualTurnRadius = Mathf.Max(MinTurnRadius, currentSpeed / MaxTurnRate);

                // 计算本帧内最大允许的转弯角度
                float maxTurnAngle = (currentSpeed / actualTurnRadius) * delta;
                // 应用转弯角度限制
                float appliedTurn = Mathf.Clamp(Mathf.Abs(turnAngle), 0, maxTurnAngle) * turnDirection;

                // 应用转弯到速度向量
                _velocity = _velocity.Rotated(appliedTurn);

                // 更新倾斜角度，用于飞行器倾斜视觉效果
                _bankAngle = Mathf.Lerp(_bankAngle, appliedTurn * BankingFactor * 50, 10 * delta);
            }
            else
            {
                // 低速时直接朝向目标方向
                _velocity = targetDir * Mathf.Min(targetSpeed, Acceleration * delta);
                // 低速时逐渐恢复水平飞行姿态
                _bankAngle = Mathf.Lerp(_bankAngle, 0, 10 * delta);
            }

            // ========== 加速度控制逻辑 ==========
            if (_velocity.Length() < targetSpeed)
            {
                // 加速：向目标速度加速
                _velocity = _velocity.MoveToward(targetDir * targetSpeed, Acceleration * delta);
            }
            else
            {
                // 保持最大速度飞行
                _velocity = _velocity.MoveToward(targetDir * targetSpeed, Acceleration * 0.5f * delta);
            }

            // 更新飞行器位置
            Position += _velocity * delta;

            // ========== 旋转控制逻辑 ==========
            // 使飞行器机头指向速度方向（Godot中0弧度指向右，所以需要+90度）
            if (_velocity.LengthSquared() > 0.1f)
            {
                Rotation = Mathf.Atan2(_velocity.Y, _velocity.X) + Mathf.Pi / 2;
            }

            // 应用倾斜效果到动画精灵（将角度转换为弧度）
            AnimatedSprite.Skew = Mathf.DegToRad(_bankAngle);

            // 请求重绘调试可视化
            QueueRedraw();
        }

        /// <summary>
        /// 绘制调试信息（速度方向、目标方向、倾斜指示器）
        /// </summary>
        public override void _Draw()
        {
            // 红色线条：显示当前速度方向
            Vector2 velocityDir = _velocity.Normalized();
            DrawLine(Vector2.Zero, velocityDir * 50, Colors.Red, 2);

            // 绿色线条：显示目标方向
            if (_targetPosition != Vector2.Zero)
            {
                Vector2 targetDir = (_targetPosition - GlobalPosition).Normalized();
                DrawLine(Vector2.Zero, targetDir * 40, Colors.Green, 2);
            }

            // 蓝色线条：显示当前倾斜角度
            Vector2 bankIndicator = new Vector2(0, 20).Rotated(_bankAngle);
            DrawLine(Vector2.Zero, bankIndicator, Colors.Blue, 2);
        }
    }
}