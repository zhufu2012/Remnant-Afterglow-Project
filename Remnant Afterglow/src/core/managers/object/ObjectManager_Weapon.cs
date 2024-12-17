using Godot;
using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 场上实体管理器-
    /// BaseWeapon = 4,//武器  4
    /// </summary>
    public partial class ObjectManager
    {
        /// <summary>
        /// 唯一id,对应单位
        /// </summary>
        public Dictionary<string, WeaponBase> weaponDict = new Dictionary<string, WeaponBase>();

        /// <summary>
        /// 创建一个武器
        /// </summary>
        /// <param name="ObjectId">武器实体id</param>
        /// <param name="mountObject">挂载实体</param>
        /// <param name="WeaponPosList">武器位数据</param>
        /// <param name="ObjectPos">实体上左上角位置偏移</param>
        /// 
        /// <returns></returns>
        public WeaponBase CreateWeapon(int ObjectId, BaseObject mountObject, List<int> WeaponPosList)
        {
            WeaponBase weaponBase = new WeaponBase(ObjectId);
            weaponBase.Position = new Vector2(WeaponPosList[2], WeaponPosList[3]);
            weaponBase.ZIndex = 9;//祝福注释-这里地图层要改,先用着
            weaponDict[weaponBase.Logotype] = weaponBase;
            //祝福注释，武器加在对应实体上
            //MainCopy.Instance.WeaponNode.AddChild(weaponBase);
            return weaponBase;
        }
    }
}