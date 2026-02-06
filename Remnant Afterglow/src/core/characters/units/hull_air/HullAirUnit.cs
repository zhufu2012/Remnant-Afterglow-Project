

using Godot;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
	/// <summary>
	/// 空中机壳单位
	/// </summary>
	public partial class HullAirUnit : UnitBase, IUnit
	{
        /// <summary>
        /// 单位机壳（Hull）节点
        /// </summary>
        public HullBase hullBase { get; set; } = null;
        /// <summary>
        /// 是否拥有机壳
        /// </summary>
        public bool HasHull { get; set; } = false;

        /// <summary>
        /// 机壳旋转角度（用于炮塔公转）
        /// </summary>
        public float HullRotation { get; set; } = 0f;

        public override void InitWeaponData()
        {
            if (unitLogic.WeaponList.Count > 0)//有武器
            {
                if (unitData.IsChassis) // 有机壳
                {
                    // WeaponBase 场景在循环中重复加载，应该提前加载一次
                    PackedScene weaponScene = GD.Load<PackedScene>("res://src/core/characters/weapons/WeaponBase.tscn");
                    // 创建机壳节点
                    hullBase = new HullBase();
                    hullBase.Name = "Hull";
                    hullBase.InitData(this);
                    // 设置机壳初始朝向与单位底盘一致
                    hullBase.UnitBaseDirection = AnimatedSprite.GlobalRotation; // 需要确认这个属性是否正确

                    // 设置机壳纹理
                    Sprite2D hullSprite = new Sprite2D();
                    hullSprite.Texture = unitData.ChassisImg;
                    hullBase.AddChild(hullSprite);

                    AnimatedSprite.AddChild(hullBase);

                    // 将所有武器添加到机壳下
                    foreach (List<int> var in unitLogic.WeaponList)
                    {
                        WeaponBase weapon = weaponScene.Instantiate<WeaponBase>();
                        weapon.InitData(this, var[0]);
                        weapon.SetHullBase(hullBase); // 设置武器的机壳引用
                        weapon.InitWeaponState(); // 武器设置为可以发射的状态
                        weapon.Position = new Vector2I(var[1], var[2]);
                        WeaponList.Add(weapon);
                        hullBase.AddChild(weapon); // 添加到机壳节点下
                    }
                    HasHull = true;
                }
            }
        }
    }
}
