using GameLog;
using Godot;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
	/// <summary>
	/// 无人机，需要实现IUnit接口
	/// </summary>
	public partial class WorkerBase : BaseObject, IWorker
	{
		#region IWorker
		#endregion

		#region 初始化
		/// <summary>
		/// 无人机配置
		/// </summary>
		public WorkerData workerData;


		/// <summary>
		/// 阴影偏移
		/// </summary>
		[Export]
		public Vector2 ShadowOffset { get; set; } = new Vector2(0, 2);

		public override void InitData(int ObjectId, int Scurce)
		{
			base.InitData(ObjectId, Scurce);
			object_type = BaseObjectType.BaseWorker;
			workerData = ConfigCache.GetWorkerData("" + ObjectId);
			Logotype = IdGenerator.Generate(IdConstant.ID_TYPE_WORKER);
			InitChild();//初始化节点数据
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
			area2DShape = GetNode<CollisionShape2D>("占地形状");
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
			}
			CollisionMask = CampBase.GetCampLayer(Camp);
			SetCollisionMaskValue(6, true);
			SetCollisionLayerValue(Camp, true);
			BodyShapeEntered += Area2DBodyShapeEntered;
			AddToGroup("" + Camp);//添加分组数据到节点
			AddToGroup(MapGroup.WorkerGroup);
		}
		#endregion


	}

}
