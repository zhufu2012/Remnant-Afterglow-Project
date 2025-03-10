using GameLog;
using Godot;
using System;
using System.Collections.Generic;


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
        public override void InitData(int ObjectId)
        {
            base.InitData(ObjectId);
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
            AnimatedSprite = GetBuildFrame(buildData);
            AnimatedSprite.Name = "AnimatedSprite";
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


            area2D = GetNode<Area2D>("占地");
            area2DShape = GetNode<CollisionShape2D>("占地/占地形状");
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
            area2D.AddToGroup(MapGroup.BuildGroup);
        }

        //累计时间
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