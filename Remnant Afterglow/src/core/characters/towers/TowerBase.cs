using Godot;
using System.Collections.Generic;


namespace Remnant_Afterglow
{
    //炮塔，需要实现ITower接口
    public partial class TowerBase : BaseObject, ITower
    {
        #region ITower
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

        #region 初始化
        /// <summary>
        /// 炮塔配置id
        /// </summary>
        public TowerData CfgData;

        public TowerBase(int cfg_id, int camp)
        {
            this.cfg_id = cfg_id;
            this.Camp = camp;
            GroupName = MapGroup.GroupName_Tower + Camp;
            InitData();//初始化配置
            InitAttr(BaseObjectType.BaseTower, CfgData.ObjectId, CfgData.TempLateList);//初始化属性
            InitChild();//初始化节点数据
        }

        /// <summary>
        /// 根据配置id和阵营数据初始化配置数据
        /// </summary>
        /// <param name="cfg_id"></param>
        /// <param name="camp"></param>
        public void InitData()
        {
            CfgData = ConfigCache.GetTowerData("" + cfg_id);
            Logotype = IdGenerator.Generate(IdConstant.ID_TYPE_TOWER);
        }

        /// <summary>
        /// 初始化节点数据
        /// </summary>
        public void InitChild()
        {
            AnimatedSprite = GetTowerFrame(CfgData);
            InitWeaponData();
            AddChild(AnimatedSprite);
            for (int i = 0; i < WeaponList.Count; i++)
            {
                AddChild(WeaponList[i]);
            }
        }
        #endregion


        /// <summary>
        /// 是否被选中
        /// </summary>
        public bool isSelected = true;
        //是否已被放置-没放置无法攻击
        public bool hasBeenPlaced = false;

        /// <summary>
        /// 炮塔底座显示的帧图
        /// </summary>
        public AnimatedSprite2D AnimatedSprite { get; set; }
        /// <summary>
        /// 武器列表
        /// </summary>
        public List<Weapon> WeaponList = new List<Weapon>();

        /// <summary>
        /// 能否建造
        /// </summary>
        /// <returns></returns>
        public bool CanBeBuilt()
        {
            return false;
        }

        /// <summary>
        /// 工作
        /// </summary>
        public virtual void Work()
        {
        }

        public void SetSelect(bool isSelect)
        {
            isSelected = isSelect;
            for (int i = 0;i < WeaponList.Count;i++)
            {

            }
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
        }
    }
}