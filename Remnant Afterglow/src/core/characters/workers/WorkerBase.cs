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

        public WorkerBase(int ObjectId) : base(ObjectId)
        {
            object_type = BaseObjectType.BaseWorker;
            InitData();//初始化配置
            InitChild();//初始化节点数据
        }

        /// <summary>
        /// 根据实体id和阵营数据初始化配置数据
        /// </summary>
        public void InitData()
        {
            CfgData = ConfigCache.GetWorkerData("" + ObjectId);
            Logotype = IdGenerator.Generate(IdConstant.ID_TYPE_WORKER);
            PoolId = (int)BaseObjectType.BaseUnit + "_" + ObjectId;
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
            AddToGroup(MapGroup.WorkerGroup);
        }
        #endregion

        #region 单位属性
        //移动速度
        public float speed = 5f;
        // 当前位置
        public  Vector2 nowPosition;
        // 移动目标位置
        public Vector2I targetPosition;
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