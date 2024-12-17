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
        public bool IsDestroyed { get; }
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
        /// 实体武器配置
        /// </summary>
        public BaseObjectWeapon baseWeapon;
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
        /// 阵营子名称
        /// </summary>
        public string CampSubName;
        /// <summary>
        /// 当前物体显示的精灵图像, 节点名称必须叫 "AnimatedSprite2D", 类型为 AnimatedSprite2D
        /// </summary>
        public AnimatedSprite2D AnimatedSprite = new AnimatedSprite2D();
        /// <summary>
        /// 当前物体显示的阴影图像, 节点名称必须叫 "ShadowSprite", 类型为 Sprite2D
        /// </summary>
        public Sprite2D ShadowSprite = new Sprite2D();
        /// <summary>
        /// 构造函数
        /// </summary>
        /// <param name="ObjectId"></param>
        public BaseObject(int ObjectId)
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
            InitObjectMove();//初始化移动相关模块
            InitMove();//初始化移动
        }

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

        }


        /// <summary>
        /// 每物理帧调用一次, 物体的 PhysicsProcess() 会在组件的 PhysicsProcess() 之前调用
        /// </summary>
        protected virtual void PhysicsProcess(double delta)
        {
            if (baseData.IsMove)//能移动
                DoMove();
        }

        /// <summary>
        /// 如果开启 debug, 则每帧调用该函数, 可用于绘制文字线段等
        /// </summary>
        protected virtual void DebugDraw()
        {
        }

    }
}