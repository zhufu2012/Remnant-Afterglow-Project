using GameLog;
using Godot;
using GodotPlugins.Game;
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
    public partial class WeaponBase : Node2D, IWeapon
    {
        /// <summary>
        /// 初始化武器状态
        /// </summary>
        public void InitWeaponState()
        {
            //武器准备好了
            state = WeaponState.Ready;
        }

        #region 武器流程逻辑
        /// <summary>
        /// 武器状态-默认开始就是准备好的状态
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
        /// 初始化武器功能逻辑 的 内部参数
        /// </summary>
        public void InitWeaponAttack()
        {
            LaunchTotal = CfgData2.LaunchTotal;//周期内发射总次数
            CoolTime = CfgData2.CoolTime;//冷却帧数
            EmissionInterval = CfgData2.EmissionInterval;//间隔帧数
            Range = CfgData2.Range;
            FirePointList = CfgData2.FirePointList;
            EmissionNum = CfgData2.EmissionNum;
            MountLookTarget = CfgData2.MountLookTarget;
            RotationSpeed = CfgData2.RotationSpeed;
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
        /// 武器真实的旋转角度, 角度制
        /// </summary>
        public float RealRotationDegrees { get; private set; } = 270;

        /// <summary>
        /// 武器真实的旋转角度, 弧度制
        /// </summary>
        public float RealRotation => Mathf.DegToRad(RealRotationDegrees);
        #endregion

        #region 武器索敌逻辑
        /// <summary>
        /// 锁定目标 实体
        /// </summary>
        public BaseObject targetObject { get; set; }
        /// <summary>
        /// 旋转是否完成
        /// </summary>
        public bool isRotatedToTarget = false;
        /// <summary>
        /// 范围内可攻击实体列表
        /// </summary>
        public HashSet<BaseObject> RangeList = new HashSet<BaseObject>();

        /// <summary>
        /// 攻击范围-需要维护一个可攻击对象表
        /// </summary>
        public Area2D AttackRange;
        public CollisionShape2D AttackShape;

        /// <summary>
        /// 检查目标是否有效，每帧运行
        /// </summary>
        public void CheckTarget()
        {
            if (targetObject != null && !GodotObject.IsInstanceValid(targetObject))
            {
                targetObject = null;
                FindTarget();
            }
        }

        /// <summary>
        /// 在攻击范围内寻找最近的目标
        /// </summary>
        public void FindTarget()
        {
            targetObject = null;
            float minDistanceSq = float.MaxValue;
            Vector2 myPos = GlobalPosition;

            // 使用 Linq 简化查找并过滤无效对象
            var validTargets = RangeList.Where(obj => GodotObject.IsInstanceValid(obj)).ToList();
            foreach (BaseObject obj in validTargets)
            {
                float distanceSq = myPos.DistanceSquaredTo(obj.GlobalPosition);
                if (distanceSq < minDistanceSq)
                {
                    minDistanceSq = distanceSq;
                    targetObject = obj;
                }
            }

            // 清理无效对象
            RangeList.RemoveWhere(obj => !GodotObject.IsInstanceValid(obj));
        }

        /// <summary>
        /// 实体进入可攻击区域
        /// </summary>
        /// <param name="body"></param>
        private void Area2DEntered(Node2D body)
        {
            BaseObject enteringObj = body as BaseObject ?? body.GetParent<BaseObject>();
            if (enteringObj != null && enteringObj.Camp != baseObject.Camp)
            {
                RangeList.Add(enteringObj);
                FindTarget();
            }
        }


        /// <summary>
        /// 当有实体退出攻击范围
        /// </summary>
        private void Area2DExited(Node2D body)
        {
            BaseObject exitingObj = body as BaseObject ?? body.GetParent<BaseObject>();
            if (exitingObj != null && RangeList.Contains(exitingObj))
            {
                RangeList.Remove(exitingObj);
                if (targetObject == exitingObj) FindTarget();
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
        /// 攻击范围
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
                    break;
                case WeaponState.FirInterval://开火间隔状态
                    if (--intervalTimer <= 0)//开火间隔结束时
                    {
                        state = WeaponState.Ready;//状态改为准备状态
                    }
                    break;
                case WeaponState.Firing://开火状态
                    Launch(); // 执行一次发射
                    intervalNum++;//发射后 发射计数增加
                    if (intervalNum >= LaunchTotal)//大于等于总数-到冷却状态
                    {
                        state = WeaponState.Cooling;
                        coolTimer = Math.Max(0, CoolTime); // 设置冷却周期，确保非负
                    }
                    else
                    {
                        intervalTimer = EmissionInterval;//设置间隔周期
                        state = WeaponState.FirInterval;
                    }
                    break;
                case WeaponState.Cooling://冷却状态
                    if (coolTimer > 0) coolTimer--; // 减少冷却计时器
                    if (coolTimer <= 0) // 冷却结束时
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
        /// 开始攻击,只有在旋转完成且目标有效时才攻击
        /// </summary>
        public void Attack()
        {
            if (state == WeaponState.Ready && targetObject != null && isRotatedToTarget)
            {
                state = WeaponState.Firing;
                Launch();
            }
        }


        /// <summary>
        /// 执行发射
        /// </summary>
        protected virtual void Launch()
        {
            foreach (var point in FirePointList)
            {
                for (int i = 0; i < EmissionNum; i++)
                {
                    // 计算子弹位置（考虑武器旋转）
                    Vector2 firePosition = GlobalPosition + point.Rotated(RealRotation);
                    // 修改后的动态方向计算（在Launch方法中）：
                    // 计算子弹基础方向（基于武器真实旋转角度）
                    float baseAngle = RealRotation; // 弧度制
                    // 若需要散射效果（根据CurrScatteringRange添加随机偏移）
                    //Log.Print(baseObject.ObjectId);
                    //Log.Print((float)Math.Cos(baseAngle)+"   "+(float)Math.Sin(RealRotation));
                    // 创建子弹时传递计算后的角度
                    MapCopy.Instance.bulletManager.CreateTopBullet(
                        CfgData2.BulletId,
                        firePosition,
                        baseAngle, // 使用动态计算的角度
                        targetObject,
                        baseObject
                    );

                }
            }
            OnAttacked(); // 触发攻击事件
        }


        /// <summary>
        /// 旋转角度
        /// </summary>
        /// <param name="delta"></param>
        private void UpdateRotation(double delta)
        {
            if (targetObject == null || !MountLookTarget) return;
            if (!GodotObject.IsInstanceValid(targetObject))
            {
                targetObject = null;
                return;
            }

            Vector2 targetPos = targetObject.GlobalPosition;
            Vector2 direction = targetPos - GlobalPosition;

            // 计算目标角度
            float targetAngle = Mathf.RadToDeg(direction.Angle());

            // 计算当前角度和目标角度之间的差值
            float angleDifference = Mathf.Wrap(targetAngle - RealRotationDegrees, -180f, 180f);

            // 选择最短的旋转路径：如果差值大于0则顺时针，小于0则逆时针
            RealRotationDegrees = Mathf.MoveToward(RealRotationDegrees, RealRotationDegrees + angleDifference, RotationSpeed * (float)delta);

            // 更新GlobalRotation
            GlobalRotation = Mathf.DegToRad(RealRotationDegrees) + Mathf.Pi / 2;

            // 判断是否已经对准目标
            if (Mathf.Abs(angleDifference) < 1f) // 假设1度以内就认为是对准
            {
                isRotatedToTarget = true;
            }
            else
            {
                isRotatedToTarget = false;
            }

            // 只有旋转完成才开始攻击
            if (isRotatedToTarget && state == WeaponState.Ready)
            {
                Attack();
            }
        }


    }
}