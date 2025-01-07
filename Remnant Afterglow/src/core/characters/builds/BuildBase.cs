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
        /// <summary>
        /// 建筑状态
        /// </summary>
        BuildStateEnum State { get; set; }
        #endregion

        BuildStateEnum IBuild.State { get => throw new NotImplementedException(); set => throw new NotImplementedException(); }

        /// <summary>
        /// 建筑配置数据
        /// </summary>
        public BuildData CfgData;

        public BuildBase(int ObjectId) : base(ObjectId)
        {
            object_type = BaseObjectType.BaseBuild;
            InitData();//初始化配置
            InitChild();
        }

        /// <summary>
        /// 根据实体id和阵营数据初始化配置数据
        /// </summary>
        public void InitData()
        {
            CfgData = ConfigCache.GetBuildData("" + ObjectId);
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

        public override void InitView()
        {
            base.InitView();
            AddToGroup(MapGroup.BuildGroup);
        }
        /// <summary>
        /// 逻辑执行完成
        /// </summary>
        public virtual void LogicalFinish()
        {
        }


    }
}