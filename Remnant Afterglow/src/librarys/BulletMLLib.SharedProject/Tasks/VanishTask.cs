using System.Diagnostics;
using BulletMLLib.SharedProject.Nodes;

namespace BulletMLLib.SharedProject.Tasks;

/// <summary>
/// 此任务从游戏中移除子弹。
/// </summary>
public class VanishTask : BulletMLTask
{
    #region Methods

    /// <summary>
    /// 初始化 <see cref="BulletMLTask"/> 类的新实例。
    /// </summary>
    /// <param name="node">节点。</param>
    /// <param name="owner">所有者。</param>
    public VanishTask(VanishNode node, BulletMLTask owner)
        : base(node, owner)
    {
        Debug.Assert(null != Node);
        Debug.Assert(null != Owner);
    }

    /// <summary>
    /// 针对子弹运行此任务和所有子任务
    /// 在运行时每帧调用一次。
    /// </summary>
    /// <returns>ERunStatus: 此任务是完成、暂停还是仍在运行</returns>
    /// <param name="bullet">要针对其更新此任务的子弹。</param>
    public override ERunStatus Run(Bullet bullet)
    {
        //通过子弹管理器接口移除子弹
        var manager = bullet.MyBulletManager;
        Debug.Assert(null != manager);
        manager.RemoveBullet(bullet);
        return ERunStatus.End;
    }

    #endregion //Methods
}
