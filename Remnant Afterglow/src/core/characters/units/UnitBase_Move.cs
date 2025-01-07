using GameLog;
using Godot;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 单位移动
    /// </summary>
    public partial class UnitBase : BaseObject, IUnit
    {


        public override void InitMove()
        {
            base.InitMove();
            Velocity = Vector2.Zero;
        }

        /// <summary>
        /// 设置需要移动到的目标位置-地图格子位置
        /// </summary>
        /// <param name="TargetPosition"></param>
        public void SetMovementTarget(Vector2I targetPosition)
        {
            if(baseData.IsMove)//是否可以移动
            {
                FlowFieldSystem.Instance.RemovePosFlowField(this.targetPosition);//移除流场//祝福注释-之后不这样做，流场是可以设置目标重新生成的，仅暂时
                this.targetPosition = targetPosition;
                FlowFieldSystem.Instance.AddPosFlowField(targetPosition);//尝试创建流场
                FlowFieldSystem.Instance.ShowFlowField = FlowFieldSystem.Instance.posFlowDict[targetPosition];
            }
        }
        /// <summary>
        /// 执行移动操作
        /// </summary>
        public override void DoMove(double delta)
        {
            mapPos = MapCopy.GetWorldPos(GlobalPosition);

            centerPos = MapCopy.GetCellCenter(mapPos);
            PlayAnima(AnimatorNames.Run);//播放移动动画

            //Log.Print(ToGlobal(GlobalPosition));aawawwaawds

            Vector2 d = steeringBehaviourFlowField(mapPos);//祝福注释-这个得位置足够近就停止，不能每次都检查

            Velocity += new Vector2((float)(d.X * delta), (float)(d.Y * delta));//可能还得看下速度大小是否超过最大值
            MoveAndSlide();
        }



        /// <summary>
        /// 转向行为流场
        /// </summary>
        /// <param name="pos"></param>
        /// <returns></returns>
        public Vector2 steeringBehaviourFlowField(Vector2 pos)//祝福注释-整个流场都可优化，比如优化为使用二维列表来保存流场矢量数据
        {
            int x = (int)pos.X;
            int y = (int)pos.Y;
            FlowField flow = FlowFieldSystem.Instance.posFlowDict[targetPosition];
            // 判断当前位置是否不可通行，如果不可通行，计算垂直可通行方向
            if (!flow.IsValid(x, y))//不可通行-祝福注释-这里看咋处理，用于防止单位进入到不可通行的位置
            {

            }


            var f00 = flow.IsValid(x, y) ? flow.GetDirection(x, y) : Vector2.Zero;
            var f01 = flow.IsValid(x, y + 1) ? flow.GetDirection(x, y + 1) : Vector2.Zero;
            var f10 = flow.IsValid(x + 1, y) ? flow.GetDirection(x + 1, y) : Vector2.Zero;
            var f11 = flow.IsValid(x + 1, y + 1) ? flow.GetDirection(x + 1, y + 1) : Vector2.Zero;

            var xWeight = pos.X - x;
            var top = f00 * (1 - xWeight) + f10 * xWeight;
            var bottom = f01 * (1 - xWeight) + f11 * xWeight;

            var yWeight = pos.Y - y;
            var direction = (top * (1 - yWeight) + bottom * yWeight).Normalized();
            var desiredVelocity = direction * GetMaxSpeed();
            var velocityChange = desiredVelocity - Velocity;
            return velocityChange * (GetMaxAddSpeed() / GetMaxSpeed());
        }

    }
}