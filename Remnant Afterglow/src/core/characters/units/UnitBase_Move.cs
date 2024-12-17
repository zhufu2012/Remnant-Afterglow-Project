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
        /// 设置需要移动到的目标位置
        /// </summary>
        /// <param name="TargetPosition"></param>
        public void SetMovementTarget(Vector2 TargetPosition)
        {

        }
        /// <summary>
        /// 执行移动操作
        /// </summary>
        public override void DoMove()
        {
            PlayAnima(AnimatorNames.Run);//播放移动动画
            //var nextDe = new Vector2(1, 1);
            //Velocity = nextDe * GetSpeed();
            //Log.Print("新速度:", Velocity);
            //MoveAndSlide();
        }
    }
}