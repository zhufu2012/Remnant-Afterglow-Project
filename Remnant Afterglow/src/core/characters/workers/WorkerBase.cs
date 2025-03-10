using GameLog;
using Godot;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 单位，需要实现IUnit接口
    /// </summary>
    public partial class WorkerBase : BaseObject, IWorker
    {
        #region IWorker
        #endregion

        #region 初始化
        /// <summary>
        /// 单位配置id
        /// </summary>
        public WorkerData CfgData;


        /// <summary>
        /// 阴影偏移
        /// </summary>
        [Export]
        public Vector2 ShadowOffset { get; set; } = new Vector2(0, 2);

        public override void InitData(int ObjectId)
        {
            base.InitData(ObjectId);
            object_type = BaseObjectType.BaseWorker;
            CfgData = ConfigCache.GetWorkerData("" + ObjectId);
            Logotype = IdGenerator.Generate(IdConstant.ID_TYPE_WORKER);
            PoolId = (int)BaseObjectType.BaseUnit + "_" + ObjectId;
            InitChild();//初始化节点数据
        }
        /// <summary>
        /// 初始化节点数据
        /// </summary>
        public void InitChild()
        {
            AnimatedSprite = GetWorkerFrame(CfgData);
            AddChild(AnimatedSprite);
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
                        RectangleShape2D rectShape = new RectangleShape2D();
                        rectShape.Size = new Vector2(baseData.ShapePointList[0], baseData.ShapePointList[1]);
                        Collision.Shape = rectShape;
                        break;
                    case 3: //3 2D圆形
                        CircleShape2D cirShape = new CircleShape2D();
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
            area2D = GetNode<Area2D>("AttackedRange");
            area2D.AreaEntered += Area2DEntered;
            area2D.AreaExited += Area2DExited;
            area2D.AddToGroup("" + Camp);//添加分组数据到节点
            area2D.AddToGroup(MapGroup.WorkerGroup);

        }
        #endregion


    }

}