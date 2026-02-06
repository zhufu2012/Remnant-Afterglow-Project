using GameLog;
using Godot;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Remnant_Afterglow
{
    public enum WeaponState
    {
        Building,//建造中状态
        Ready, //准备好了
        Firing,//开火  发射后检查计数，没发射完就到开火间隔状态，发射完了到冷却状态
        FirInterval,//开火间隔状态 完成后到Firing开火状态
        Cooling//冷却  冷却好->Ready
    }
    /// <summary>
    /// 武器 攻击相关逻辑
    /// </summary>
    public partial class WeaponBase : Area2D, IWeapon
    {
        /// <summary>
        /// 初始化武器状态
        /// </summary>
        public void InitWeaponState()
        {
            //武器准备好了
            state = WeaponState.Ready;
            PlayAnimaImmediate(ObjectStateNames.Default);//播放默认动画
        }

        #region 武器流程逻辑
        /// <summary>
        /// 武器状态-默认是建筑状态
        /// </summary>
        private WeaponState state = WeaponState.Building;

        /// <summary>
        /// 武器单个周期内每次发射间间隔(帧数)
        ///0 表示无间隔，一次性射出
        ///武器周期发射总量
        ///1 表示每1帧射出武器单次发射数，然后隔对应帧后继续发射，直到发射完就开始冷却
        /// </summary>
        public int intervalTimer = 0;
        /// <summary>
        /// 发射计数
        /// </summary>
        public int intervalNum = 0;
        /// <summary>
        /// 冷却计时
        /// </summary>
        public int coolTimer = 0;

        /// <summary>
        /// 武器转动速度 1表示每秒转1度 90表示每秒转90度（1/4圆）
        /// </summary>
        public float RotationSpeed;
        /// <summary>
        /// 当前散射半径 指子弹射出时，偏移炮口方向的上下角度半径
        /// </summary>
        public float CurrScatteringRange = 2;
        /// <summary>
        /// 武器的开火点列表
        /// 子弹生成的位置列表
        /// (偏移中心坐标x,偏移中心坐标y)单位像素
        /// </summary>
        public List<Vector2> FirePointList;
        /// <summary>
        /// 武器每个开火点单次发射数
        /// </summary>
        public int EmissionNum;
        /// <summary>
        /// 武器发射的子弹
        /// </summary>
        public int BulletId;
        /// <summary>
        /// 初始化武器功能逻辑 的 内部参数
        /// </summary>
        public virtual void InitWeaponAttack(WeaponData2 CfgData2)
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
        }
        #endregion

        #region 武器图像逻辑
        /// <summary>
        /// 默认方向-即图片上炮口方向
        /// </summary>
        public float defaultDirection;

        /// <summary>
        /// 开局方向-即创建时炮口方向
        /// </summary>
        public float startDirection;

        /// <summary>
        /// 炮口方向是否始终指向对象
        /// </summary>
        public bool MountLookTarget;

        /// <summary>
        /// 武器真实的旋转角度, 弧度制
        /// </summary>
        public float RealRotation => Mathf.DegToRad(GlobalRotationDegrees);
        #endregion

        #region 武器索敌逻辑
        /// <summary>
        /// 锁定目标 实体
        /// </summary>
        public BaseObject targetObject { get; set; } = null;
        /// <summary>
        /// 旋转是否完成
        /// </summary>
        public bool isRotatedToTarget = false;
        /// <summary>
        /// 范围内可攻击实体列表-祝福注释-可以优化为带id,然后锁定时才获取对应实体， 第二个好办法是一旦检测到有对象进入，记为target，然后关闭碰撞检测，设置collisionshape diable属性为true
        ///当target销毁或离开足够距离后，重新开启碰撞检测,也可以通过直接使用Physics2DServer的Physics2DDirectSpaceState来实现area2d的碰撞检测，性能有较大提升
        /// </summary>
        public HashSet<BaseObject> RangeList = new HashSet<BaseObject>();

        /// <summary>
        /// 检查目标是否有效，每20帧运行
        /// </summary>
        public void CheckTarget()
        {
            if (targetObject == null || !IsInstanceValid(targetObject) || GlobalPosition.DistanceSquaredTo(targetObject.GlobalPosition) > Range)
            {
                FindTarget();
            }
        }

        /// <summary>
        /// 在攻击范围内寻找最近的目标
        /// </summary>
        public virtual void FindTarget()
        {
            float minDistanceSq = float.MaxValue;
            Vector2 myPos = GlobalPosition;
            foreach (BaseObject obj in RangeList)
            {
                if (IsInstanceValid(obj))
                {
                    float distanceSq = myPos.DistanceSquaredTo(obj.GlobalPosition);
                    if (distanceSq < minDistanceSq)
                    {
                        minDistanceSq = distanceSq;
                        targetObject = obj;
                    }
                }
            }
            if (targetObject != null)
            {
                //Monitoring = false;
                SetDeferred("monitoring", false);
            }
            // 清理无效对象
            RangeList.RemoveWhere(obj => !IsInstanceValid(obj));
        }

        /// <summary>
        /// 实体进入可攻击区域
        /// </summary>
        /// <param name="body"></param>
        private void Area2DEntered(Area2D body)
        {
            BaseObject enteringObj = body as BaseObject;
            if (enteringObj.Camp != baseObject.Camp)
            {
                RangeList.Add(enteringObj);
            }
        }


        /// <summary>
        /// 当有实体退出攻击范围
        /// </summary>
        private void Area2DExited(Area2D body)
        {
            BaseObject exitingObj = body as BaseObject;
            if (exitingObj != null && RangeList.Contains(exitingObj))
            {
                RangeList.Remove(exitingObj);
                if (targetObject == exitingObj)
                    CallDeferred(nameof(FindTarget));
                //FindTarget();
            }
        }
        #endregion



        /// <summary>
        /// 武器周期发射量 指武器在一个 开火-间隔-开火-间隔-开火-冷却开始-冷却完成的过程中，总共开火多少次
        /// </summary>
        public int LaunchTotal;
        /// <summary>
        /// 冷却帧数
        /// </summary>
        public int CoolTime;
        /// <summary>
        /// 间隔帧数
        /// </summary>
        public int EmissionInterval;
        /// <summary>
        /// 攻击范围的平方
        /// </summary>
        public float Range;

        /// <summary>
        /// 更新-攻击流程代码
        /// </summary>
        public virtual void Update_Attack()
        {
            switch (state)
            {
                case WeaponState.Ready://准备好状态
                    if (targetObject != null && isRotatedToTarget && IsInstanceValid(targetObject))
                    {
                        state = WeaponState.Firing;
                        PlayAnimaImmediate(ObjectStateNames.Attack);//攻击状态
                    }//准备攻击
                    break;
                case WeaponState.FirInterval://开火间隔状态
                    if (--intervalTimer <= 0)//开火间隔结束时
                    {
                        state = WeaponState.Ready;//状态改为准备状态
                    }
                    break;
                case WeaponState.Firing://当前为开火状态
                    if (targetObject != null && IsInstanceValid(targetObject))
                    {
                        if (intervalNum >= LaunchTotal)//大于等于总数-到冷却状态
                        {
                            PlayAnimaImmediate(ObjectStateNames.Fill);//修改为装填动画
                            state = WeaponState.Cooling;//冷却
                            coolTimer = Math.Max(0, CoolTime); // 设置冷却周期，确保非负
                            intervalNum = 0; // 重置发射计数，避免重复触发冷却
                        }
                        else
                        {
                            Launch(); // 执行一次发射
                            intervalTimer = EmissionInterval;//设置间隔周期
                            state = WeaponState.FirInterval;
                        }
                    }
                    else
                    {
                        // 目标无效，切换到Ready状态并重置参数
                        state = WeaponState.Ready;
                    }
                    break;
                case WeaponState.Cooling://冷却状态
                    if (coolTimer > 0)
                        coolTimer--; // 减少冷却计时器
                    else
                    {
                        state = WeaponState.Ready; // 状态改回准备好的状态
                        intervalNum = 0; // 重置周期内发射数
                    }
                    break;
                default:
                    break;
            }
        }



        /// <summary>
        /// 执行一次子弹发射发射
        /// </summary>
        public void Launch()
        {
            foreach (var point in FirePointList)
            {
                Vector2 firePosition = GlobalTransform * point; // 正确转换本地坐标到全局
                for (int i = 0; i < EmissionNum; i++)
                {
                    // 计算子弹位置（考虑武器旋转）
                    // 修改后的动态方向计算（在Launch方法中）：
                    // 将生成子弹请求加入队列
                    MapCopy.Instance.bulletManager.EnqueueBulletRequest(new BulletRequest
                    {
                        BulletId = BulletId,
                        Position = firePosition,
                        Direction = RealRotation,
                        TargetObject = targetObject,
                        CreateObject = baseObject
                    });

                }
            }
            intervalNum++;//发射后 发射计数增加
        }

        /// <summary>
        /// 检查目标是否在机壳限制的角度范围内
        /// </summary>
        public bool IsTargetInHullRange(BaseObject target)
        {
            if (hullBase == null || !MountLookTarget)
                return true; // 没有机壳或不跟踪目标，无限制
            Vector2 directionToTarget = target.GlobalPosition - GlobalPosition;
            float targetAngle = directionToTarget.Angle();
            // 计算机壳的朝向角度
            float hullAngle = hullBase.GetHullRotationRad();
            // 计算相对角度差
            float angleDiff = Mathf.Abs(Mathf.Wrap(targetAngle - hullAngle, -Mathf.Pi, Mathf.Pi));
            // 假设机壳提供120度的覆盖范围（可根据需要调整）
            return angleDiff <= Mathf.Pi / 3;
        }


        /// <summary>
        /// 旋转角度
        /// </summary>
        /// <param name="delta"></param>
        public virtual void UpdateRotation(double delta)
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
            Vector2 direction = targetObject.GlobalPosition - GlobalPosition;
            float targetAngleDeg;
            if (hullBase != null) // 有机壳
            {
                // 计算相对于机壳的方向
                targetAngleDeg = Mathf.RadToDeg(direction.Angle()) + 90f;
                // 考虑机壳的旋转
                targetAngleDeg -= hullBase.GlobalRotationDegrees;
            }
            else // 没有机壳，保持原有逻辑
            {
                targetAngleDeg = Mathf.RadToDeg(direction.Angle()) + 90f;
            }
            float angleDifference = Mathf.Wrap(targetAngleDeg - GlobalRotationDegrees, -180f, 180f);
            GlobalRotationDegrees = Mathf.MoveToward(GlobalRotationDegrees, GlobalRotationDegrees + angleDifference, RotationSpeed * (float)delta);
            isRotatedToTarget = Mathf.Abs(angleDifference) < 1f;
        }


    }
}
