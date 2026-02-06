using GameLog;
using Godot;
using System.Collections.Generic;


namespace Remnant_Afterglow
{
	/// <summary>
	/// 炮塔，需要实现ITower接口
	/// </summary>
	public partial class TowerBase : BaseObject, ITower
	{
		#region ITower
		#endregion

		#region 初始化
		/// <summary>
		/// 炮塔配置id
		/// </summary>
		public BuildData buildData;
		/// <summary>
		/// 武器列表
		/// </summary>
		public List<WeaponBase> WeaponList = new List<WeaponBase>();
		public override void InitData(int ObjectId, int Scurce)
		{
			base.InitData(ObjectId, Scurce);
			object_type = BaseObjectType.BaseTower;
			buildData = ConfigCache.GetBuildData("" + ObjectId);
			Logotype = IdGenerator.Generate(IdConstant.ID_TYPE_TOWER);
			InitChild();//初始化节点数据
		}

		/// <summary>
		/// 初始化节点数据
		/// </summary>
		public void InitChild()
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
					case 1: //1 2D矩形
						RectangleShape2D rectShape = new RectangleShape2D();
						rectShape.Size = new Vector2(baseData.ShapePointList[0], baseData.ShapePointList[1]);
						area2DShape.Shape = rectShape;
						break;
					case 2: //2 2D圆形
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
		/// 初始化远程武器数据
		/// </summary>
		/// <returns></returns>
		public void InitWeaponData()
		{
			foreach (List<int> var in buildData.WeaponList)
			{
				WeaponBase weapon = GD.Load<PackedScene>("res://src/core/characters/weapons/WeaponBase.tscn").Instantiate<WeaponBase>();
				weapon.InitData(this, var[0]);
				if (Source == 0)
					weapon.InitWeaponState();
				weapon.Position = new Vector2I(var[1], var[2]);
				WeaponList.Add(weapon);//祝福注释-这里位置等参数要改
				AnimatedSprite.AddChild(weapon);
			}
		}
		#endregion


		/// <summary>
		/// 逻辑执行完成
		/// </summary>
		public virtual void LogicalFinish()
		{
		}
	}
}
