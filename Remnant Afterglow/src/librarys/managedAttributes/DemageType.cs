namespace Godot.Community.ManagedAttributes
{
    public enum DemageType
    {
        /// <summary>
        /// 非伤害
        /// </summary>
        None,
        /// <summary>
        /// 对护盾伤害
        /// </summary>
        LiveAmmunition = 1,
        /// <summary>
        /// 对装甲伤害
        /// </summary>
        Laser = 2,
        /// <summary>
        /// 对结构伤害
        /// </summary>
        Explosion = 3,
        /// <summary>
        /// 直接对结构伤害
        /// </summary>
        Element = 4
    }
}
