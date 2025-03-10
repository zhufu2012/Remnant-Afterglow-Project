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
        public override void InitData(int ObjectId)
		{
			base.InitData(ObjectId);
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
			AnimatedSprite = GetTowerFrame(buildData);
			AnimatedSprite.Name = "AnimatedSprite";
			AddChild(AnimatedSprite);
			InitWeaponData();
		}

		public override void InitView()
		{
			base.InitView();
			Collision = GetNode<CollisionShape2D>("碰撞体");
			if (baseData.IsCollide)
			{
				switch (baseData.ShapeType)
				{
					case 1: //1 2D胶囊形状
						CapsuleShape2D capShape = new CapsuleShape2D();
						capShape.Height = baseData.ShapePointList[0];
						capShape.Radius = baseData.ShapePointList[1];
						Collision.Shape = capShape;
						break;
					case 2: //2 2D矩形
						RectangleShape2D  rectShape= new RectangleShape2D();
						rectShape.Size = new Vector2(baseData.ShapePointList[0],baseData.ShapePointList[1]);
						Collision.Shape = rectShape;
						break;
					case 3: //3 2D圆形
						CircleShape2D cirShape= new CircleShape2D();
						cirShape.Radius = baseData.ShapePointList[0];
						Collision.Shape = cirShape;
						break;
					default:
						break;
				}
				Collision.Position = baseData.CollidePos;
				Collision.RotationDegrees = baseData.CollideRotate;
			}
			CollisionMask = Common.CalculateMaskSum(baseData.MaskLayerList);
			CollisionLayer = Common.CalculateMaskSum(baseData.CollisionLayerList);


			area2D = GetNode<Area2D>("占地");
            area2DShape =  GetNode<CollisionShape2D>("占地/占地形状");
            if (baseData.IsCollide)
            {
                switch (baseData.ShapeType)
                {
                    case 1: //1 2D胶囊形状
                        CapsuleShape2D capShape = new CapsuleShape2D();
                        capShape.Height = baseData.ShapePointList[0];
                        capShape.Radius = baseData.ShapePointList[1];
                        area2DShape.Shape = capShape;
                        break;
                    case 2: //2 2D矩形
                        RectangleShape2D rectShape = new RectangleShape2D();
                        rectShape.Size = new Vector2(baseData.ShapePointList[0], baseData.ShapePointList[1]);
                        area2DShape.Shape = rectShape;
                        break;
                    case 3: //3 2D圆形
                        CircleShape2D cirShape = new CircleShape2D();
                        cirShape.Radius = baseData.ShapePointList[0];
                        area2DShape.Shape = cirShape;
                        break;
                    default:
                        break;
                }
                area2DShape.Position = baseData.CollidePos;
                area2DShape.RotationDegrees = baseData.CollideRotate;
            }
            area2D.CollisionMask = Common.CalculateMaskSum(baseData.MaskLayerList);
            area2D.CollisionLayer = Common.CalculateMaskSum(baseData.CollisionLayerList);
            area2D.AreaEntered += Area2DEntered;
			area2D.AreaExited += Area2DExited;
			area2D.AddToGroup("" + Camp);//添加分组数据到节点
			area2D.AddToGroup(MapGroup.TowerGroup);
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
				weapon.InitData(this,var[0]);
				weapon.Position = new Vector2I(var[1], var[2]);
				WeaponList.Add(weapon);//祝福注释-这里位置等参数要改
			}
            for (int i = 0; i < WeaponList.Count; i++)
            {
                AnimatedSprite.AddChild(WeaponList[i]);
            }
        }

        /// <summary>
        /// 建造完成
        /// </summary>
        public void BuildFinish()
        {
            for (int i = 0; i < WeaponList.Count; i++)
            {
				WeaponList[i].InitWeaponState();
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
