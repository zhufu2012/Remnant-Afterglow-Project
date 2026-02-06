using Godot;
using SteeringBehaviors;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
	/// <summary>
	/// 单位，需要实现IUnit接口
	/// </summary>
	public partial class UnitBase : BaseObject, IUnit
	{
		#region IUnit
		#endregion

		#region 初始化
		/// <summary>
		/// 单位基础配置
		/// </summary>
		public UnitData unitData;
		/// <summary>
		/// 单位逻辑配置
		/// </summary>
		public UnitLogic unitLogic;
		/// <summary>
		/// 单位类型
		/// </summary>
		public UnitAIType unitType;

		/// <summary>
		/// 武器列表
		/// </summary>
		public List<WeaponBase> WeaponList = new List<WeaponBase>();

		public override void InitData(int ObjectId, int Scurce)
		{
			base.InitData(ObjectId, Scurce);
			Camp = baseData.CampId;
			object_type = BaseObjectType.BaseUnit;
			unitData = ConfigCache.GetUnitData(ObjectId);
			unitLogic = ConfigCache.GetUnitLogic(ObjectId);
			Logotype = IdGenerator.Generate(IdConstant.ID_TYPE_UNIT);
			InitChild();//初始化节点数据
			InitObjectMove();//初始化移动相关模块
		}

		/// <summary>
		/// 初始化节点数据
		/// </summary>
		public virtual void InitChild()
		{
			InitAnima();
			InitWeaponData();
		}

		public override void InitView()
		{
			base.InitView();
			if (baseData.IsCollide)
			{
				switch (baseData.ShapeType)
				{
					case 1: //2 2D矩形
						RectangleShape2D rectShape = new RectangleShape2D();
						rectShape.Size = new Vector2(baseData.ShapePointList[0], baseData.ShapePointList[1]);
						area2DShape.Shape = rectShape;
						break;
					case 2: //3 2D圆形
						CircleShape2D cirShape = new CircleShape2D();
						cirShape.Radius = baseData.ShapePointList[0];
						area2DShape.Shape = cirShape;
						break;
					default:
						break;
				}
				area2DShape.Position = baseData.CollidePos;
				CollisionMask = CampBase.GetCampLayer(Camp);
				SetCollisionMaskValue(6, true);
				SetCollisionLayerValue(Camp, true);
				BodyShapeEntered += Area2DBodyShapeEntered;
				AddToGroup("" + Camp);//添加分组数据到节点
				AddToGroup(MapGroup.TowerGroup);
			}
		}

		/// <summary>
		/// 初始化 武器数据
		/// </summary>
		/// <returns></returns>
		public virtual void InitWeaponData()
		{
			if(unitLogic.WeaponList.Count > 0)//有武器
			{
				// WeaponBase 场景在循环中重复加载，应该提前加载一次
				PackedScene weaponScene = GD.Load<PackedScene>("res://src/core/characters/weapons/WeaponBase.tscn");
				foreach (List<int> var in unitLogic.WeaponList)
				{
					WeaponBase weapon = weaponScene.Instantiate<WeaponBase>();
					weapon.InitData(this, var[0]);
					weapon.InitWeaponState(); // 武器设置为可以发射的状态
					weapon.Position = new Vector2I(var[1], var[2]);
					WeaponList.Add(weapon);
					AnimatedSprite.AddChild(weapon);
				}
	//            if (unitData.IsChassis) // 有机壳
				//{
				//	// 创建机壳节点
				//	hullBase = new HullBase();
				//	hullBase.Name = "Hull";
				//	hullBase.InitData(this);
				//	// 设置机壳初始朝向与单位底盘一致
				//	hullBase.UnitBaseDirection = AnimatedSprite.GlobalRotation; // 需要确认这个属性是否正确

				//	// 设置机壳纹理
				//	Sprite2D hullSprite = new Sprite2D();
				//	hullSprite.Texture = unitData.ChassisImg;
				//	hullBase.AddChild(hullSprite);

				//	AnimatedSprite.AddChild(hullBase);

				//	// 将所有武器添加到机壳下
				//	foreach (List<int> var in unitLogic.WeaponList)
				//	{
				//		WeaponBase weapon = weaponScene.Instantiate<WeaponBase>();
				//		weapon.InitData(this, var[0]);
				//		weapon.SetHullBase(hullBase); // 设置武器的机壳引用
				//		weapon.InitWeaponState(); // 武器设置为可以发射的状态
				//		weapon.Position = new Vector2I(var[1], var[2]);
				//		WeaponList.Add(weapon);
				//		hullBase.AddChild(weapon); // 添加到机壳节点下
				//	}
				//	HasHull = true;
				//}
				//else // 无机壳
				//{
				//	foreach (List<int> var in unitLogic.WeaponList)
				//	{
				//		WeaponBase weapon = weaponScene.Instantiate<WeaponBase>();
				//		weapon.InitData(this, var[0]);
				//		weapon.InitWeaponState(); // 武器设置为可以发射的状态
				//		weapon.Position = new Vector2I(var[1], var[2]);
				//		WeaponList.Add(weapon);
				//		AnimatedSprite.AddChild(weapon);
				//	}
				//}
			}
		}
		#endregion

		/// <summary>
		/// 每物理帧调用一次, 物体的 PhysicsProcess() 会在组件的 PhysicsProcess() 之前调用
		/// </summary>
		protected override void PhysicsProcess(double delta)
		{
			if (baseData.IsMove)//能移动
			{
				steering.Update();//行为模式力更新
				DoMove((float)delta);
				SpatialGrid.UpdateGrid(steering);
			}
		}
	}

}
