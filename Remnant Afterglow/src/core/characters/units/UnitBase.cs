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
        /// 单位AI类型
        /// </summary>
        public UnitAIType AiType { get; set; }
        #endregion

        #region 初始化
        /// <summary>
        /// 单位基础配置
        /// </summary>
        public UnitData unitData;
        /// <summary>
        /// 单位逻辑配置
        /// </summary>
        public UnitLogic unitLogic;


        public UnitBase(int ObjectId) : base(ObjectId)
        {
            object_type = BaseObjectType.BaseUnit;
            CampSubName = MapCamp.CampName_Unit + Camp;//设置组名
            InitData();//初始化配置
            InitChild();//初始化节点数据
        }



        /// <summary>
        /// 根据实体id和阵营数据初始化配置数据
        /// </summary>
        public void InitData()
        {
            unitData = ConfigCache.GetUnitData(ObjectId);
            unitLogic = ConfigCache.GetUnitLogic(ObjectId);
            Logotype = IdGenerator.Generate(IdConstant.ID_TYPE_UNIT);
            PoolId = (int)BaseObjectType.BaseUnit + "_" + ObjectId;
        }
        /// <summary>
        /// 初始化节点数据
        /// </summary>
        public void InitChild()
        {
            AnimatedSprite = GetUnitFrame(unitData);
            AddChild(AnimatedSprite);
        }
        #endregion

        #region 单位属性
        //移动速度
        public float speed = 5f;
        // 当前位置
        public  Vector2 nowPosition;
        // 目标位置
        public Vector2 targetPosition;
        #endregion

        #region 单位组数据
        //单位是否在单位组中
        public bool IsGroup = false;
        /// <summary>
        /// 单位当前目标位置
        /// </summary>
        public Vector2 movePos;
        /// <summary>
        /// 单位组内类型
        /// </summary>
        public GroupUnitType groupType;
        #endregion


    }

}