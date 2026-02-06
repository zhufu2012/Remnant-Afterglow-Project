using Godot;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Remnant_Afterglow
{
    public partial class HullWeapon : WeaponBase
    {
        /// <summary>
        /// 机壳武器相对于机壳的偏移角度
        /// </summary>
        public float HullOffsetAngle { get; set; } = 0f;
        /// <summary>
        /// 扇形攻击角度（弧度）
        /// </summary>
        public float SectorAngle { get; set; } = Mathf.Pi / 3; // 默认60度

        /// <summary>
        /// 初始化武器功能逻辑 的 内部参数
        /// </summary>
        public override void InitWeaponAttack(WeaponData2 CfgData2)
        {
            LaunchTotal = CfgData2.LaunchTotal;//周期内发射总次数
            CoolTime = CfgData2.CoolTime;//冷却帧数
            EmissionInterval = CfgData2.EmissionInterval;//间隔帧数
            Range = CfgData2.Range * CfgData2.Range;
            FirePointList = CfgData2.FirePointList;
            EmissionNum = CfgData2.EmissionNum;
            MountLookTarget = CfgData2.MountLookTarget;
            RotationSpeed = CfgData2.RotationSpeed;
            BulletId = CfgData2.BulletId;
            HullOffsetAngle = CfgData2.HullOffsetAngle;
            SectorAngle = Mathf.DegToRad(CfgData2.SectorAngle);
        }

        /// <summary>
        /// 重写索敌方法，实现扇形范围检测
        /// </summary>
        public override void FindTarget()
        {
            if (hullBase == null)
            {
                base.FindTarget();
                return;
            }

            float minDistanceSq = float.MaxValue;
            Vector2 myPos = GlobalPosition;
            BaseObject newTarget = null;

            // 获取机壳的朝向
            float hullAngle = hullBase.GetHullRotationRad();

            foreach (BaseObject obj in RangeList)
            {
                if (IsInstanceValid(obj))
                {
                    // 检查目标是否在扇形范围内
                    if (IsInSector(obj.GlobalPosition, myPos, hullAngle))
                    {
                        float distanceSq = myPos.DistanceSquaredTo(obj.GlobalPosition);
                        if (distanceSq < minDistanceSq)
                        {
                            minDistanceSq = distanceSq;
                            newTarget = obj;
                        }
                    }
                }
            }
            targetObject = newTarget;
            if (targetObject != null)
            {
                Monitoring = false;
            }
            // 清理无效对象
            RangeList.RemoveWhere(obj => !IsInstanceValid(obj));
        }

        /// <summary>
        /// 检查目标是否在扇形范围内
        /// </summary>
        /// <param name="targetPos"></param>
        /// <param name="weaponPos"></param>
        /// <param name="hullAngle"></param>
        /// <returns></returns>
        private bool IsInSector(Vector2 targetPos, Vector2 weaponPos, float hullAngle)
        {
            Vector2 directionToTarget = targetPos - weaponPos;
            float targetAngle = directionToTarget.Angle();

            // 计算相对角度差
            float angleDiff = Mathf.Abs(Mathf.Wrap(targetAngle - hullAngle, -Mathf.Pi, Mathf.Pi));

            return angleDiff <= SectorAngle / 2;
        }

        /// <summary>
        /// 重写旋转更新方法
        /// </summary>
        /// <param name="delta"></param>
        public override void UpdateRotation(double delta)
        {
            if (targetObject == null || !MountLookTarget) return;
            if (!IsInstanceValid(targetObject))
            {
                targetObject = null;
                return;
            }

            // 检查目标是否在机壳范围内
            if (!IsTargetInHullRange(targetObject))
            {
                targetObject = null;
                return;
            }

            // 对于机壳武器，方向基于机壳朝向和偏移量
            Vector2 direction = targetObject.GlobalPosition - GlobalPosition;
            float targetAngleRad = direction.Angle();

            // 计算机壳的朝向
            float hullAngleRad = hullBase.GetHullRotationRad();

            // 计算相对于机壳的角度
            float relativeAngle = targetAngleRad - hullAngleRad;

            // 应用偏移
            float finalAngleDeg = Mathf.RadToDeg(hullAngleRad + relativeAngle) + HullOffsetAngle;

            float angleDifference = Mathf.Wrap(finalAngleDeg - GlobalRotationDegrees, -180f, 180f);
            GlobalRotationDegrees = Mathf.MoveToward(GlobalRotationDegrees, GlobalRotationDegrees + angleDifference, RotationSpeed * (float)delta);
            isRotatedToTarget = Mathf.Abs(angleDifference) < 1f;
        }
    }
}
