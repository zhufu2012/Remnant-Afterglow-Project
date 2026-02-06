using Godot;


namespace Remnant_Afterglow
{
	/// <summary>  
	/// 建筑类，基础自 BaseObject ，需要实现IBuild接口
	/// </summary>
	public partial class BuildBase : BaseObject, IBuild
	{
		#region IBuild
		#endregion

		/// <summary>
		/// 建筑配置数据
		/// </summary>
		public BuildData buildData;

		/// <summary>
		/// 根据实体id和阵营数据初始化配置数据
		/// </summary>
		public override void InitData(int ObjectId, int Scurce)
		{
			base.InitData(ObjectId, Scurce);
			object_type = BaseObjectType.BaseBuild;
			buildData = ConfigCache.GetBuildData("" + ObjectId);
			Logotype = IdGenerator.Generate(IdConstant.ID_TYPE_BUILD);
			InitChild();
		}

		/// <summary>
		/// 初始化节点数据
		/// </summary>
		public void InitChild()
		{
			InitAnima();
		}

		public override void InitView()
		{
			base.InitView();
			
			switch(buildData.SubType)
			{
				case 0://常规建筑
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
						AddToGroup(MapGroup.BuildGroup);
					}
				break;
				case 1://埋地建筑
					// 禁用碰撞体
					area2DShape?.SetDeferred("disabled", true);
					Collision?.SetDeferred("disabled", true);

					// 清除碰撞层，避免被攻击
					CollisionLayer = 0;
					CollisionMask = 0;

					// 从攻击目标组中移除
					RemoveFromGroup($"{Camp}");
					RemoveFromGroup(MapGroup.BuildGroup);
					break;
				default:
					break;
			}
		}

		/// <summary>
		/// 累计时间
		/// </summary>
		public double time = 0;
		/// <summary>
		/// 每秒执行一次
		/// </summary>
		public double interval = 1.0;
		/// <summary>
		/// 每物理帧调用一次, 物体的 PhysicsProcess() 会在组件的 PhysicsProcess() 之前调用
		/// </summary>
		protected override void PhysicsProcess(double delta)
		{
			if (buildData.WeekLength > 0)
			{
				time += delta;
				if (time >= interval)
				{
					DoWork();
					time -= interval;
				}
			}
		}

		/// <summary>
		/// 逻辑执行完成
		/// </summary>
		public virtual void LogicalFinish()
		{
		}
	}
}
