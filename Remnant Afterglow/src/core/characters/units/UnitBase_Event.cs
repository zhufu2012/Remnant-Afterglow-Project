using Godot;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 单位事件
    /// </summary>
    public partial class UnitBase : BaseObject, IUnit
    {
        /// <summary>
        /// 子弹碰撞
        /// </summary>
        /// <param name="bodyRid"></param>
        /// <param name="body"></param>
        /// <param name="bodyShapeIndex"></param>
        /// <param name="localShapeIndex"></param>
        public override void Area2DBodyShapeEntered(Rid bodyRid, Node2D body, long bodyShapeIndex, long localShapeIndex)
        {
            if (IsDestroyed)//死亡就不继续了
                return;
            EntityBullet bullet = MapCopy.Instance.bulletManager.bulletDict[bodyRid];
            //子弹高度大于零 并且 子弹处于可使用状态
            if (bullet.Used)
            {

                if (bullet.Camp != Camp)//非同阵营
                {
                    //给实体加上击中Buff
                    handler.SelfAddBuffList(bullet.bulletLogic.AddBuffList);
                    attributeContainer.ApplyDamage(
                        bullet.bulletLogic.ShieldHarm,
                        bullet.bulletLogic.ArmourHarm,
                        bullet.bulletLogic.StructureHarm,
                        bullet.bulletLogic.ElementHarm);

                    if (attributeContainer.IsDead())
                    {
                        IsDestroyed = true; // 已经被摧毁
                        DieEvent();
                    }
                    bullet.Used = false;//准备移除子弹
                    Flash();
                    foreach (WeaponBase weapon in WeaponList)
                    {
                        weapon.Flash();
                    }
                }
            }
        }

    }
}