using Godot;

namespace Remnant_Afterglow
{
	/// <summary>
	/// 武器，需要实现IWeapon接口
	/// </summary>
	public partial class WeaponBase : Area2D, IWeapon
	{
		#region IWeapon
		public int weaponId { get; set; }
		#endregion

		/// <summary>
		/// 所在武器位，从1开始，祝福注释-这个没用上
		/// </summary>
		public int WeaponPos = 0;
		/// <summary>
		/// 挂载在哪个实体，可以是建筑，炮塔，单位，无人机等等
		/// </summary>
		public BaseObject baseObject;
		/// <summary>
		/// 挂载的机壳（如果有的话）
		/// </summary>
		public HullBase hullBase = null;
		/// <summary>
		/// 攻击范围形状
		/// </summary>
		[Export]
		public CollisionShape2D AttackShape;

		#region 初始化
		public void InitData(BaseObject baseObject, int weaponId)
		{
			this.baseObject = baseObject;
			this.weaponId = weaponId;
			WeaponData CfgData = ConfigCache.GetWeaponData(weaponId);
			WeaponData2 CfgData2 = ConfigCache.GetWeaponData2(weaponId);
			InitWeaponAttack(CfgData2);
			SelfModulate = new Color(0, 0, 0, 0);
			InitAnima(CfgData);
			CollisionMask = CampBase.GetCampLayer(baseObject.Camp);//祝福注释-可以优化为先计算完成
			CircleShape2D circle = (CircleShape2D)AttackShape.Shape;
			circle.Radius = CfgData2.Range;
			AreaEntered += Area2DEntered;
			AreaExited += Area2DExited;
			// 如果是机壳武器，设置初始角度
			if (this is HullWeapon hullWeapon && hullBase != null)
			{
				// 设置初始角度与机壳一致
				GlobalRotationDegrees = hullBase.GlobalRotationDegrees;
				// 可以设置偏移角度
				hullWeapon.HullOffsetAngle = 0f; // 根据需要设置
			}
		}

		/// <summary>
		/// 设置武器挂载的机壳
		/// </summary>
		public void SetHullBase(HullBase hullBase)
		{
			this.hullBase = hullBase;
		}
		#endregion


		int index = 0;
		public override void _PhysicsProcess(double delta)
		{
			index++;
			if (state != WeaponState.Building)//非建造状态
			{
				if (index == 20)
					Monitoring = true;
				if (index >= 21)
				{
					index = 0;
					CheckTarget();//每20帧检测一次
					if (targetObject == null)
					{
						PlayAnimaImmediate(ObjectStateNames.Default);
					}
				}
				UpdateRotation(delta);//每帧旋转角度
				Update_Attack();//攻击流程代码
			}
		}
	}
}
