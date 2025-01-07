using GameLog;
using Godot;
using System;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 武器，有实体，需要实现IWeapon接口
    /// </summary>
    public partial class WeaponBase : BaseObject, IWeapon
    {
        #region IWeapon
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


        #region 初始化
        public WeaponBase(int object_id) : base(object_id)
        {
            object_type = BaseObjectType.BaseUnit;
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
            CfgData = ConfigCache.GetWeaponData(ObjectId);
            CfgData2 = ConfigCache.GetWeaponData2(ObjectId);
        }

        /// <summary>
        /// 初始化节点数据
        /// </summary>
        public void InitChild()
        {
            AnimatedSprite = GetWeaponFrame(CfgData);
            AddChild(AnimatedSprite);
            rangeArea = new Area2D();//攻击范围
            rangeArea.AreaEntered += Area2DEntered;
            rangeArea.AreaExited += Area2DExited;
        }

        public override void InitView()
        {
            base.InitView();
            AddToGroup(MapGroup.WeaponGroup);
        }
        #endregion


        public override void _Draw()
        {
            if (isSelected)
                DrawCircle(Vector2.Zero, CfgData2.Range, CfgData.RangeColor);
        }

        public override void Update(double delta)
        {
            base.Update(delta);
            Update_Attack();
        }


    }
}