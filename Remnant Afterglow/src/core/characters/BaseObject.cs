using GameLog;
using Godot;
using ManagedAttributes;
using System.Collections.Generic;
using System.Linq;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 单位，炮塔，建筑，武器等对象的基类，不包含子弹,需要实现武器位搭载功能
    /// </summary>
    public partial class BaseObject : Area2D, IPoolItem
    {
        #region IPoolItem
        /// <summary>
        /// 对象唯一id,IdGenerator生成
        /// </summary>
        public string Logotype { get; set; }
        /// <summary>
        /// 返回物体是否已经被销毁
        /// </summary>
        public bool IsDestroyed { get; set; } = false;
        /// <summary>
        /// 当物体被回收时调用，也就是进入对象池
        /// </summary>
        public void OnReclaim()
        { }
        /// <summary>
        /// 离开对象池时调用
        /// </summary>
        public void OnLeavePool()
        { }
        /// <summary>
        /// 销毁实体
        /// </summary>
        public void Destroy()
        { }
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
        /// 实体类型
        /// </summary>
        public BaseObjectType object_type;

        /// <summary>
        /// 来源  0 地图生成时创建   1 建造系统创建
        /// </summary>
        public int Source = 0;

        /// <summary>
        /// 构造函数
        /// </summary>
        /// <param name="ObjectId"></param>
        public virtual void InitData(int ObjectId, int Scurce)
        {
            baseData = ConfigCache.GetBaseObjectData(ObjectId);
            this.ObjectId = ObjectId;
            this.Source = Scurce;
            InitAttr(ObjectId);//初始化属性
            InitBuff(ObjectId);//初始化Buff
        }

        public override void _Ready()
        {
            InitView();
            InitMove();//初始化移动
            InitStateData();
        }
        #region 节点
        /// <summary>
        /// 当前实体碰撞器节点, 节点名称必须叫 "Collision", 类型为 CollisionShape2D
        /// </summary>
        public CollisionShape2D Collision { get; set; }

        /// <summary>
        /// 占地形状
        /// </summary>
        [Export]
        public CollisionShape2D area2DShape;
        /// <summary>
        /// 属性条 结构值 - 护盾值
        /// </summary>
        public AttributeBar attributeBar;
        /// <summary>
        /// 初始化显示的界面-祝福注释-血条可以优化，思路是 默认隐藏（满血）  受伤再打开
        /// </summary>
        public virtual void InitView()
        {
            AttributeBar attributeBar = (AttributeBar)GD.Load<PackedScene>("res://src/core/ui/component/fight_view/属性条.tscn").Instantiate();
            AttrData hp_attr = (AttrData)attributeContainer[Attr.Attr_001];
            AttrData shield_attr = (AttrData)attributeContainer[Attr.Attr_003];
            attributeBar.Position = baseData.AttributeBarPos;
            attributeBar.Scale = new Vector2(baseData.Volume, baseData.Volume);
            AddChild(attributeBar);
            attributeBar.InitData(hp_attr, shield_attr);
        }
        #endregion


        /// <summary>
        /// 当前帧数
        /// </summary>
        public ulong NowTick = 0;
        /// <summary>
        /// 物理帧
        /// </summary>
        /// <param name="delta"></param>
        public override void _PhysicsProcess(double delta)
        {
            if (IsLogic)
            {
                NowTick += 1;
                if (NowTick % 60 == 0)
                {
                    attributeContainer.Update(NowTick);//属性系统刷新
                }
                stateMachine.FixedUpdate(delta);//状态系统刷新
                PhysicsProcess(delta);
            }
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
