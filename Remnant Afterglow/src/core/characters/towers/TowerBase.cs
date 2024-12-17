using GameLog;
using Godot;
using System.Collections.Generic;


namespace Remnant_Afterglow
{
    //炮塔，需要实现ITower接口
    public partial class TowerBase : BaseObject, ITower
    {
        #region ITower
        #endregion

        #region 初始化
        /// <summary>
        /// 炮塔配置id
        /// </summary>
        public TowerData CfgData;

        public TowerBase(int ObjectId) : base(ObjectId)
        {
            object_type = BaseObjectType.BaseTower;
            CampSubName = MapCamp.CampName_Tower + Camp;
            InitData();//初始化配置
            InitChild();//初始化节点数据
        }

        /// <summary>
        /// 根据实体id和阵营数据初始化配置数据
        /// </summary>
        public void InitData()
        {
            CfgData = ConfigCache.GetTowerData("" + ObjectId);
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
        /// <summary>
        /// 是否已被放置-没放置无法攻击
        /// </summary>
        public bool hasBeenPlaced = false;

        /// <summary>
        /// 武器列表
        /// </summary>
        public List<WeaponBase> WeaponList = new List<WeaponBase>();

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
            for (int i = 0; i < WeaponList.Count; i++)
            {

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