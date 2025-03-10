
using GameLog;
using Godot;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 子弹节点
    /// </summary>
    public partial class BulletNode : Node2D
    {
        #region 子弹配置数据
        /// <summary>
        /// 子弹自身
        /// </summary>
        public BulletBase bulletBase;
        /// <summary>
        /// 子弹基础的数据
        /// </summary>
        public BulletData bulletData;
        /// <summary>
        /// 子弹逻辑数据
        /// </summary>
        public BulletLogic bulletLogic;
        /// <summary>
        /// 子弹碰撞数据
        /// </summary>
        public BulletCollide bulletCollide;
        /// <summary>
        /// 阵营组参数
        /// </summary>
        public int Camp;
        #endregion
        /// <summary>
        /// 碰撞体
        /// </summary>
        Area2D Area;
        public void InitData(BulletBase bulletBase,int Camp, string BulletLabel)
        {
            this.Camp = Camp;
            this.bulletBase = bulletBase;
            bulletData = ConfigCache.GetBulletData(BulletLabel);
            bulletLogic = ConfigCache.GetBulletLogic(BulletLabel);
            bulletCollide = ConfigCache.GetBulletCollide(bulletData.CollideId);
        }



    }
}
