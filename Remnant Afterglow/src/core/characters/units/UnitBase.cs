using GameLog;
using Godot;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 单位，需要实现IUnit接口
    /// </summary>
    public partial class UnitBase : BaseObject, IUnit
    {
        #region IUnit
        /// <summary>
        /// 是否已经回收
        /// </summary>
        public bool IsRecycled { get; set; }
        /// <summary>
        /// 对象唯一id
        /// </summary>
        public string Logotype { get; set; }
        /// <summary>
        /// 配置id
        /// </summary>
        public int cfg_id { get; set; }
        /// <summary>
        /// 对象池id = 对象类型+ _ + cfg_id
        /// </summary>
        public string PoolId { get; set; }
        /// <summary>
        /// 所在阵营
        /// </summary>
        public int Camp { get; set; }
        /// <summary>
        /// 单位AI类型
        /// </summary>
        public UnitAIType AiType { get; set; }
        /// <summary>
        /// 返回物体是否已经被销毁
        /// </summary>
        public bool IsDestroyed { get; }
        #endregion

        #region 初始化
        /// <summary>
        /// 单位配置id
        /// </summary>
        public UnitData CfgData;
        /// <summary>
        /// 当前物体显示的精灵图像, 节点名称必须叫 "AnimatedSprite2D", 类型为 AnimatedSprite2D
        /// </summary>
        public AnimatedSprite2D AnimatedSprite { get; set; }
        /// <summary>
        /// 当前物体显示的阴影图像, 节点名称必须叫 "ShadowSprite", 类型为 Sprite2D
        /// </summary>
        public Sprite2D ShadowSprite { get; set; }
        /// <summary>
        /// 阴影偏移
        /// </summary>
        [Export]
        public Vector2 ShadowOffset { get; set; } = new Vector2(0, 2);

        /// <summary>
        /// 当前物体碰撞器节点, 节点名称必须叫 "Collision", 类型为 CollisionShape2D
        /// </summary>
        public CollisionShape2D Collision { get; set; }

        public UnitBase(int cfg_id, int camp_id)
        {
            this.cfg_id = cfg_id;
            this.Camp = camp_id;
            GroupName = MapGroup.GroupName_Unit + Camp;
            InitData();//初始化配置
            InitAttr(BaseObjectType.BaseUnit, CfgData.ObjectId, CfgData.TempLateList);//初始化属性
            InitChild();//初始化节点数据
        }

        /// <summary>
        /// 根据配置id和阵营数据初始化配置数据
        /// </summary>
        /// <param name="cfg_id"></param>
        /// <param name="camp"></param>
        public void InitData()
        {
            CfgData = ConfigCache.GetUnitData("" + cfg_id);
            Logotype = IdGenerator.Generate(IdConstant.ID_TYPE_UNIT);
            PoolId = (int)BaseObjectType.BaseUnit + "_" + cfg_id;
        }
        /// <summary>
        /// 初始化节点数据
        /// </summary>
        public void InitChild()
        {
            AnimatedSprite = GetUnitFrame(CfgData);
            AddChild(AnimatedSprite);
        }
        #endregion




        /// <summary>
        /// 离开对象池时调用
        /// </summary>
        public void OnLeavePool()
        {
        }

        /// <summary>
        /// 当物体被回收时调用，也就是进入对象池
        /// </summary>
        public void OnReclaim()
        {
        }

        public void Destroy()
        {
        }
    }

}