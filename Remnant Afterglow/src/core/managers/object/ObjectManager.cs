using GameLog;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 场上实体管理器-
    /// BaseUnit = 1,//单位   1
    /// BaseTower = 2,//炮塔  2
    /// BaseBuild = 3,//建筑  3
    /// BaseWeapon = 4,//武器  4
    /// WorkerBase = 5,//无人机  5
    /// </summary>
    public partial class ObjectManager
    {

        /// <summary>
        /// 实体管理器单例
        /// </summary>
        public static ObjectManager Instance { get; set; }

        /// <summary>
        /// 实体管理器
        /// </summary>
        public ObjectManager()
        {
            Instance = this;
        }




        /// <summary>
        /// 特殊更新逻辑
        /// </summary>
        /// <param name="delta"></param>
        public void Update(double delta)
        {

        }

        /// <summary>
        /// 获取实体的类型
        /// </summary>
        /// <param name="Logotype">唯一id</param>
        /// <returns></returns>
        public static BaseObjectType GetObjectType(string Logotype)
        {
            switch (IdGenerator.GetType(Logotype))
            {
                case IdConstant.ID_TYPE_UNIT://单位
                    return BaseObjectType.BaseUnit;
                case IdConstant.ID_TYPE_TOWER://炮塔
                    return BaseObjectType.BaseTower;
                case IdConstant.ID_TYPE_BUILD://建筑
                    return BaseObjectType.BaseBuild;
                case IdConstant.ID_TYPE_WEAPON://武器
                    return BaseObjectType.BaseWeapon;
                case IdConstant.ID_TYPE_WORKER://无人机
                    return BaseObjectType.BaseWorker;
                default:
                    Log.Error(" 获取实体的类型报错！LogoType:", Logotype);
                    return BaseObjectType.BaseUnit;
            }
        }

    }
}