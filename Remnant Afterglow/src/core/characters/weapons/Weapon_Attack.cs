using Godot;
using GodotPlugins.Game;
using System;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    public enum WeaponState
    {
        Ready, //准备好了
        Firing,//开火  发射后检查计数，没发射完就到开火间隔状态，发射完了到冷却状态
        FirInterval,//开火间隔状态 完成后到Firing开火状态
        Cooling//冷却  冷却好->Ready
    }
    /// <summary>
    /// 武器 攻击相关逻辑
    /// </summary>
    public partial class WeaponBase : BaseObject, IWeapon
    {
        #region 武器流程逻辑
        /// <summary>
        /// 武器状态
        /// </summary>
        private WeaponState state = WeaponState.Ready;

        /// <summary>
        /// 武器单个周期内每次发射间间隔(帧数)
        ///0 表示无间隔，一次性射出
        ///武器周期发射总量
        ///1 表示每1帧射出武器单次发射数，然后隔对应帧后继续发射，直到发射完就开始冷却
        /// </summary>
        public int intervalTimer = 1;
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
        /// 武器瞄准的方向
        /// </summary>
        public Vector2 LookPosition;

        /// <summary>
        /// 武器真实的旋转角度, 角度制
        /// </summary>
        public float RealRotationDegrees { get; private set; }

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
        //范围内可攻击实体列表
        public List<BaseObject> RangeList = new List<BaseObject>();

        /// <summary>
        /// 攻击范围-维护一个可攻击对象表
        /// </summary>
        public Area2D rangeArea;

        /// <summary>
        /// 查询敌人//祝福注释-这里要改,改成在攻击范围内查询敌人，而不是在整个敌人组查询（这样消耗太大）
        /// </summary>
        public void FindTarget()
        {

        }

        //实体进入武器攻击区域
        public void BaseObjectEnterRange(Area2D area)
        {

        }
        //实体离开武器攻击区域
        public void BaseObjectExitRange(Area2D area)
        {
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
        /// 初始化武器功能逻辑 的 内部参数
        /// </summary>
        public void InitWeaponAttack()
        {
            LaunchTotal = CfgData2.LaunchTotal;//周期内发射总次数
            CoolTime = CfgData2.CoolTime;//冷却帧数
            EmissionInterval = CfgData2.EmissionInterval;//间隔帧数
            Range = CfgData2.Range;
        }

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
                        state = WeaponState.Firing;//状态改为开火状态
                    }
                    break;
                case WeaponState.Firing://开火状态
                    Launch(); // 执行一次发射
                    intervalNum++;//发射后 间隔计数增加
                    if (intervalNum >= LaunchTotal)//大于等于总数-到冷却状态
                    {
                        state = WeaponState.Cooling;
                        coolTimer = Math.Max(0, CoolTime); // 设置冷却周期，确保非负
                    }
                    else
                    {
                        intervalTimer = EmissionInterval;//设置间隔周期
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
        /// 开始攻击
        /// </summary>
        public void Attack()
        {
            if (state != WeaponState.Ready)
                return;
            state = WeaponState.Firing;//进入开火状态
            intervalTimer = 1; // 假设最小间隔为1帧
            Launch();
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
                    // 创建子弹对象，并设置其初始位置和方向
                    // 注意：此处需要具体的Bullet类或创建子弹的方法
                    //var bullet = CreateBullet(point);
                   
                    //bullet.SetDirection(RealRotation + UnityEngine.Random.Range(-CurrScatteringRange, CurrScatteringRange));
                }
            }
        }

        /// <summary>
        /// 调整武器的朝向, 使其看向目标点
        /// </summary>
        public virtual void LookTargetPosition(Vector2 pos)
        {
            LookPosition = pos;
            if (MountLookTarget)
            {
                var myPos = GlobalPosition;
                var angle = Mathf.RadToDeg((LookPosition - myPos).Angle());
                RealRotationDegrees = angle;
                GlobalRotationDegrees = AdsorptionAngle(angle);
                Rotation = RealRotation;//弧度制
            }
        }

        /// <summary>
        /// 吸附角度到最近的有效角度（四舍五入到最接近的角度）
        /// </summary>
        /// <param name="angle">原始角度</param>
        /// <returns>吸附后的角度</returns>
        private float AdsorptionAngle(float angle)
        {
            //祝福注释- 这里可以添加具体的逻辑来实现角度吸附
            return angle;
        }
    }
}