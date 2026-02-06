using System.Diagnostics;
using BulletMLLib.SharedProject.Nodes;

namespace BulletMLLib.SharedProject.Tasks;

/// <summary>
/// 这个任务在指定的时间内暂停
/// </summary>
public class WaitTask : BulletMLTask
{
    #region Members

    /// <summary>
    /// 运行此任务的持续时间...以帧为单位测量
    /// 此任务将暂停直到持续时间结束，然后恢复运行任务
    /// </summary>
    private float Duration { get; set; }

    #endregion //Members

    #region Methods

    /// <summary>
    /// 初始化 <see cref="BulletMLTask"/> 类的新实例。
    /// </summary>
    /// <param name="node">节点。</param>
    /// <param name="owner">所有者。</param>
    public WaitTask(WaitNode node, BulletMLTask owner)
        : base(node, owner)
    {
        Debug.Assert(null != Node);
        Debug.Assert(null != Owner);
    }

    /// <summary>
    /// 设置任务准备运行。
    /// </summary>
    /// <param name="bullet">子弹。</param>
    protected override void SetupTask(Bullet bullet)
    {
        Duration = Node.GetValue(this, bullet);
    }

    /// <summary>
    /// 针对子弹运行此任务和所有子任务
    /// 在运行时每帧调用一次。
    /// </summary>
    /// <returns>ERunStatus: 此任务是完成、暂停还是仍在运行</returns>
    /// <param name="bullet">要针对其更新此任务的子弹。</param>
    public override ERunStatus Run(Bullet bullet)
    {
        Duration -= 1.0f * bullet.TimeSpeed;
        if (Duration >= 0.0f)
        {
            return ERunStatus.Stop;
        }

        TaskFinished = true;
        return ERunStatus.End;
    }

    #endregion //Methods
}
