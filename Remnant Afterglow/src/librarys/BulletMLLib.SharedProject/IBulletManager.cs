using Godot;
using Remnant_Afterglow;

namespace BulletMLLib.SharedProject;

/// <summary>
/// 这个接口用于外部程序集管理子弹，主要是创建和销毁它们。
/// </summary>
public interface IBulletManager
{
    #region Properties

    // 可以在这里定义一些属性，例如：
    // int MaxBullets { get; }

    #endregion Properties

    #region Methods

    /// <summary>
    /// 获取玩家当前位置的方法。
    /// 用于将子弹瞄准该位置。
    /// </summary>
    /// <returns>要瞄准的子弹的目标位置</returns>
    /// <param name="targettedBullet">我们正在获取目标的子弹</param>
    Vector2 PlayerPosition(IBullet targettedBullet);

    /// <summary>
    /// 子弹不再被使用，需要处理以移除它。
    /// </summary>
    /// <param name="deadBullet">已死亡的子弹。</param>
    void RemoveBullet(IBullet deadBullet);

    /// <summary>
    /// 创建一个新的子弹。
    /// </summary>
    /// <returns>一个全新的子弹</returns>
    IBullet CreateBullet(Bullet parBullet,BaseObject targetObject, BaseObject createObject);

    /// <summary>
    /// 将发射子弹请求加入队列
    /// </summary>
    /// <returns>一个全新的顶级子弹</returns>
    void EnqueueBulletRequest(BulletRequest request);

    /// <summary>
    /// 这是在运行时由子弹管理器传递给 Equationator 的项。
    /// 例如，可以随着Boss受到伤害，等级从 0.0 到 3.0 变化，并在脚本中做如下操作：
    /// $tier % 3
    /// </summary>
    double Tier();

    #endregion //Methods
}