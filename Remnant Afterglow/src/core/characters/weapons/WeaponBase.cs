using GameLog;
using Godot;
using System;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 武器，需要实现IWeapon接口
    /// </summary>
    public partial class WeaponBase : Node2D, IWeapon
    {
        #region IWeapon
        public int weaponId { get; set; }
        #endregion

        /// <summary>
        /// 武器基础数据
        /// </summary>
        public WeaponData CfgData { get; set; }

        /// <summary>
        /// 武器数据
        /// </summary>
        public WeaponData2 CfgData2 { get; set; }

        /// <summary>
        /// 所在武器位，从1开始，
        /// </summary>
        public int WeaponPos = 0;
        /// <summary>
        /// 挂载在哪个实体，可以是建筑，炮塔，单位，无人机等等
        /// </summary>
        public BaseObject baseObject;


        /// <summary>
        /// 是否被选中
        /// </summary>
        public bool isSelected = true;

        /// <summary>
        /// 是否自动播放 SpriteFrames 的动画
        /// </summary>
        public bool IsAutoPlaySpriteFrames { get; set; } = true;
        /// <summary>
        /// 当前物体显示的精灵图像, 节点名称必须叫 "AnimatedSprite2D", 类型为 AnimatedSprite2D
        /// </summary>
        public AnimatedSprite2D AnimatedSprite = new AnimatedSprite2D();


        #region 初始化
        public void InitData(BaseObject baseObject,int weaponId) 
        {
            this.baseObject = baseObject;
            this.weaponId = weaponId;
            CfgData = ConfigCache.GetWeaponData(weaponId);
            CfgData2 = ConfigCache.GetWeaponData2(weaponId);
            InitChild();//初始化节点数据
            InitWeaponAttack();
        }

        /// <summary>
        /// 初始化节点数据
        /// </summary>
        public void InitChild()
        {
            SelfModulate = new Color(0,0,0,0);
            AnimatedSprite = GetWeaponFrame(CfgData);
            AddChild(AnimatedSprite);
            AttackRange = GetNode<Area2D>("AttackRange");//攻击范围
            AttackShape = GetNode<CollisionShape2D>("AttackRange/AttackShape");
            CircleShape2D circle = (CircleShape2D)AttackShape.Shape;
            circle.Radius = CfgData2.Range;
            AttackRange.AreaEntered += Area2DEntered;
            AttackRange.AreaExited += Area2DExited;
        }
        #endregion


        public override void _Draw()
        {
            if (isSelected)
                DrawCircle(Vector2.Zero, CfgData2.Range, CfgData.RangeColor);
        }

        public override void _PhysicsProcess(double delta)
        {
            if(state != WeaponState.Building)//非建造状态
            {
                CheckTarget();//检查目标是否有效果
                UpdateRotation(delta);//每帧旋转角度
                Update_Attack();//攻击流程代码
                                // 在状态为 Ready 且有目标时触发攻击
                if (state == WeaponState.Ready && targetObject != null)
                {
                    Attack();
                }
            }
        }


    }
}