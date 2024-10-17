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
        /// <summary>
        /// 是否已经回收
        /// </summary>
        public bool IsRecycled { get; set; }
        /// <summary>
        /// 对象唯一标识，哪儿用到了就哪个
        ///  用于在对象池中区分对象类型，可以是资源路径，也可以是配置表id
        ///  或者唯一数据id
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

        public bool IsDestroyed { get; }
        #endregion

        public BuildStateEnum State { get; set; }

        /// <summary>
        /// 当前物体显示的精灵图像, 节点名称必须叫 "AnimatedSprite2D", 类型为 AnimatedSprite2D
        /// </summary>
        public AnimatedSprite2D AnimatedSprite { get; set; }
        /// <summary>
        /// 建筑配置数据
        /// </summary>
        public BuildData CfgData;

        public BuildBase(int cfg_id, int camp)
        {
            this.cfg_id = cfg_id;
            this.Camp = camp;
            GroupName = MapGroup.GroupName_Build + Camp;
            InitData();//初始化配置
            InitAttr(BaseObjectType.BaseBuild, CfgData.ObjectId, CfgData.TempLateList);//初始化属性
            InitChild();
        }

        /// <summary>
        /// 根据配置id和阵营数据初始化配置数据
        /// </summary>
        /// <param name="cfg_id"></param>
        /// <param name="camp"></param>
        public void InitData()
        {
            CfgData = ConfigCache.GetBuildData("" + cfg_id);
            Logotype = IdGenerator.Generate(IdConstant.ID_TYPE_BUILD);
        }

        /// <summary>
        /// 初始化节点数据
        /// </summary>
        public void InitChild()
        {
            AnimatedSprite = GetBuildFrame(CfgData);
            AddChild(AnimatedSprite);
        }

        /// <summary>
        /// 逻辑执行完成
        /// </summary>
        public virtual void LogicalFinish()
        {
        }

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
            throw new NotImplementedException();
        }
    }
}