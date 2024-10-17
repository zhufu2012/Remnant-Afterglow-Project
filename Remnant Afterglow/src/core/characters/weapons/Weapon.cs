using Godot;
using System;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 武器，有实体但不继承BaseObject，需要实现IWeapon接口
    /// </summary>
    public partial class Weapon : Node2D, IWeapon
    {
        #region IWeapon
        /// <summary>
        /// 是否已经回收
        /// </summary>
        public bool IsRecycled { get; set; }
        /// <summary>
        /// 对象唯一标识，哪儿用到了就哪个
        ///  用于在对象池中区分对象类型，可以是资源路径，也可以是配置表id
        ///  或者唯一数据id
        /// </summary>
        public string Logotype { get; set; }
        /// <summary>
        /// 实体配置id
        /// </summary>
        public int cfg_id { get; set; }
        /// <summary>
        /// 对象池id = 对象类型+ _ + cfg_id
        /// </summary>
        public string PoolId { get; set; }
        /// <summary>
        /// 所在阵营
        /// </summary>
        public int Camp { get; set; }

        public bool IsDestroyed => throw new NotImplementedException();

        #endregion

        #region 初始化
        /// <summary>
        /// 武器基础数据
        /// </summary>
        public WeaponData CfgData { get; set; }

        /// <summary>
        /// 武器数据
        /// </summary>
        public WeaponBase weaponBase { get; set; }


        public Weapon(int cfg_id, int camp)
        {
            this.cfg_id = cfg_id;
            this.Camp = camp;
            InitData();//初始化配置
            InitChild();//初始化节点数据
        }

        /// <summary>
        /// 根据配置id和阵营数据初始化配置数据
        /// </summary>
        /// <param name="cfg_id"></param>
        /// <param name="camp"></param>
        public void InitData()
        {
            CfgData = ConfigCache.GetWeaponData(cfg_id);
            weaponBase = ConfigCache.GetWeaponBase(cfg_id);
        }

        /// <summary>
        /// 初始化节点数据
        /// </summary>
        public void InitChild()
        {
            AnimatedSprite = GetWeaponFrame(CfgData);
            AddChild(AnimatedSprite);
        }
        #endregion



        /// <summary>
        /// 目标单位
        /// </summary>
        public UnitBase target { get; set; }

        /// <summary>
        /// 是否处于冷却状态-未冷却无法攻击
        /// </summary>
        public bool IsCool = true;

        /// <summary>
        /// 是否被选中
        /// </summary>
        public bool isSelected = true;

        /// <summary>
        /// 武器管的开火点
        /// </summary>
        public Marker2D FirePoint { get; set; }


        /// <summary>
        /// 武器的当前散射半径
        /// </summary>
        public float CurrScatteringRange { get; set; } = 0;

        /// <summary>
        /// 是否在冷却中
        /// </summary>
        /// <value></value>
        public bool Reloading { get; set; } = false;

        /// <summary>
        /// 炮塔显示的帧图
        /// </summary>
        public AnimatedSprite2D AnimatedSprite { get; set; }

        /// <summary>
        /// 是否自动播放 SpriteFrames 的动画
        /// </summary>
        public bool IsAutoPlaySpriteFrames { get; set; } = true;


        public override void _Draw()
        {
            if (isSelected)
                DrawCircle(Vector2.Zero, weaponBase.Range, CfgData.RangeColor);
        }

        /// <summary>
        /// 查询敌人
        /// </summary>
        public void FindTarget()
        {
            CampBase campBase = ConfigCache.GetCampBase(Camp);
            List<string> HostileGroupNameList = campBase.GetHostileList(BaseObjectType.BaseUnit);//获取对应阵营的当前敌人组列表
            float MinLength = -1f;
            UnitBase currentTarget = null;
            foreach (string GroupName in HostileGroupNameList)
            {
                var UnitBaseList = GetTree().GetNodesInGroup(GroupName);//查找敌对单位组单位列表
                if (UnitBaseList.Count != 0)
                {
                    foreach (UnitBase unit in UnitBaseList)
                    {
                        float length = (Position - unit.Position).Length();
                        if (length < MinLength && length < weaponBase.Range)
                        {
                            currentTarget = unit;
                            MinLength = length;
                        }
                    }

                }
            }
            target = currentTarget;
        }

        /// <summary>
        /// 当物体被回收时调用，也就是进入对象池
        /// </summary>
        public void OnLeavePool()
        {
        }
        /// <summary>
        /// 离开对象池时调用
        /// </summary>
        public void OnReclaim()
        {
        }

        public void Destroy()
        {

        }

    }
}