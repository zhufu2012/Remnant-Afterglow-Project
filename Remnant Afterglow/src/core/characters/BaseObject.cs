using GameLog;
using Godot;
using Godot.Community.ManagedAttributes;
using System.Collections.Generic;
using System.Linq;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 单位，炮塔，建筑，武器等对象的基类，不包含子弹,需要实现武器位搭载功能
    /// </summary>
    public partial class BaseObject : CharacterBody2D, IPoolItem
    {
        #region IPoolItem
        /// <summary>
        /// 是否已经回收
        /// </summary>
        public bool IsRecycled { get; set; }
        /// <summary>
        /// 对象唯一id,IdGenerator生成
        /// </summary>
        public string Logotype { get; set; }
        /// <summary>
        /// 对象池id = 对象类型+ _ + cfg_id
        /// </summary>
        public string PoolId { get; set; }
        /// <summary>
        /// 返回物体是否已经被销毁
        /// </summary>
        public bool IsDestroyed { get;set; } = false;
        /// <summary>
        /// 当物体被回收时调用，也就是进入对象池
        /// </summary>
        public void OnReclaim()
        { }
        /// <summary>
        /// 离开对象池时调用
        /// </summary>
        public void OnLeavePool()
        {
        }
        /// <summary>
        /// 销毁实体
        /// </summary>
        public void Destroy()
        {
        }
        #endregion

        /// <summary>
        /// 是否开启实体逻辑
        /// </summary>
        public bool IsLogic = true;

        /// <summary>
        /// 实体相关配置
        /// </summary>
        public BaseObjectData baseData;
        /// <summary>
        /// 实体id
        /// </summary>
        public int ObjectId;
        /// <summary>
        /// 所在阵营
        /// </summary>
        public int Camp { get; set; }

        /// <summary>
        /// 当前帧数
        /// </summary>
        public ulong NowTick = 0;

        /// <summary>
        /// 实体类型
        /// </summary>
        public BaseObjectType object_type;



        /// <summary>
        /// 当前物体显示的精灵图像, 节点名称必须叫 "AnimatedSprite2D", 类型为 AnimatedSprite2D
        /// </summary>
        public AnimatedSprite2D AnimatedSprite = new AnimatedSprite2D();
        /// <summary>
        /// 当前物体显示的阴影图像, 节点名称必须叫 "ShadowSprite", 类型为 Sprite2D
        /// </summary>
        public Sprite2D ShadowSprite = new Sprite2D();
        /// <summary>
        /// 不需要根据旋转改变的节点放这里
        /// </summary>
        public Node2D node2D = new Node2D();

        /// <summary>
        /// 构造函数
        /// </summary>
        /// <param name="ObjectId"></param>
        public virtual void InitData(int ObjectId)
        {
            MotionMode = MotionModeEnum.Floating;//没有天花板之类的概念=
            baseData = ConfigCache.GetBaseObjectData(ObjectId);
            this.ObjectId = ObjectId;
            Camp = baseData.CampId;
            InitAttr(ObjectId);//初始化属性
            InitBuff(ObjectId);//初始化Buff
        }

        public override void _Ready()
        {
            InitView();
            InitObjectMove();//初始化移动相关模块
            InitMove();//初始化移动
            InitStateData();
        }
        #region 节点
        /// <summary>
        /// 当前实体碰撞器节点, 节点名称必须叫 "Collision", 类型为 CollisionShape2D
        /// </summary>
        public CollisionShape2D Collision { get; set; }
        /// <summary>
        /// 占地
        /// </summary>
        public Area2D area2D;
        /// <summary>
        /// 占地形状
        /// </summary>
        public CollisionShape2D area2DShape;
        /// <summary>
        /// 属性条
        /// </summary>
        public List<AttributeBar> attributeBars = new List<AttributeBar>();
        /// <summary>
        /// 初始化显示的界面
        /// </summary>
        /// <param name="delta"></param>
        public virtual void InitView()
        {
            int posY = 10;
            switch (baseData.ShapeType)
            {
                case 1:
                    posY = baseData.ShapePointList[0];
                    break;
                case 2:
                    posY = baseData.ShapePointList[0] / 2;
                    break;
                case 3:
                    posY = baseData.ShapePointList[0];
                    break;
                default: break;
            }
            node2D.Name = "Node2D";
            AddChild(node2D);

            foreach (var attr in baseData.AttributeBarList)
            {
                AttributeBar attributeBar = (AttributeBar)GD.Load<PackedScene>("res://src/core/ui/component/fight_view/属性条.tscn").Instantiate();
                FloatManagedAttribute floatManaged = (FloatManagedAttribute)attributeContainer["" + attr];
                if (floatManaged != null)
                {
                    attributeBar.InitData(attr, floatManaged);
                    attributeBars.Add(attributeBar);
                    attributeBar.Position = new Vector2(-18, posY);
                    attributeBar.Scale = new Vector2(baseData.Volume, baseData.Volume);

                    posY += (int)(4 * baseData.Volume);

                    node2D.AddChild(attributeBar);
                }
            }
        }
        #endregion


        /// <summary>
        /// 物理帧
        /// </summary>
        /// <param name="delta"></param>
        public override void _PhysicsProcess(double delta)
        {
            if (IsLogic)
            {
                NowTick += 1;
                Update(delta);//各系统刷新
                PhysicsProcess(delta);
            }
        }


        /// <summary>
        /// 实体更新
        /// </summary>
        /// <param name="tick"></param>
        public virtual void Update(double delta)
        {
            attributeContainer.Update(NowTick);//属性系统刷新
            StatePhysicsProcess(delta);//状态系统刷新
        }


        /// <summary>
        /// 每物理帧调用一次, 物体的 PhysicsProcess() 会在组件的 PhysicsProcess() 之前调用
        /// </summary>
        protected virtual void PhysicsProcess(double delta)
        {
        }

        /// <summary>
        /// 如果开启 debug, 则每帧调用该函数, 可用于绘制文字线段等
        /// </summary>
        protected virtual void DebugDraw()
        {
        }

    }
}