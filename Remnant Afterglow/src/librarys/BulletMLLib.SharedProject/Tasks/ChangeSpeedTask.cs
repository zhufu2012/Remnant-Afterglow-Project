using System.Diagnostics;
using BulletMLLib.SharedProject.Nodes;

namespace BulletMLLib.SharedProject.Tasks;

/// <summary>
/// 这个任务每帧都会稍微改变速度。
/// </summary>
public class ChangeSpeedTask : BulletMLTask
{
    #region 成员变量

    /// <summary>
    /// 从节点中提取的速度值
    /// </summary>
    private float NodeSpeed;

    /// <summary>
    /// 速度变化的类型，从节点中提取
    /// </summary>
    private ENodeType ChangeType;

    /// <summary>
    /// 运行此任务的时间长度...以帧为单位
    /// </summary>
    private float Duration { get; set; }

    /// <summary>
    /// 此任务已运行的帧数
    /// </summary>
    private float RunDelta { get; set; }

    #endregion //成员变量

    #region 方法

    /// <summary>
    /// 初始化 <see cref="BulletMLTask"/> 类的新实例。
    /// </summary>
    /// <param name="node">节点。</param>
    /// <param name="owner">所有者。</param>
    public ChangeSpeedTask(ChangeSpeedNode node, BulletMLTask owner)
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
        // 设置运行此任务的时间长度
        Duration = Node.GetChildValue(ENodeName.term, this, bullet);

        // 检查除零错误
        if (0.0f == Duration)
        {
            Duration = 1.0f;
        }
        //节点设置的速度
        NodeSpeed = Node.GetChildValue(ENodeName.speed, this, bullet);
        ChangeType = Node.GetChild(ENodeName.speed).NodeType;
    }

    private float GetVelocity(Bullet bullet)
    {
        return ChangeType switch
        {
            ENodeType.sequence => NodeSpeed,
            ENodeType.relative => NodeSpeed / Duration,
            _ => ((NodeSpeed - bullet.Speed) / (Duration - RunDelta))
        };
    }

    /// <summary>
    /// 针对子弹运行此任务和所有子任务
    /// 在运行时每帧调用一次。
    /// </summary>
    /// <returns>ERunStatus: 此任务是已完成、暂停还是仍在运行</returns>
    /// <param name="bullet">要针对其更新此任务的子弹。</param>
    public override ERunStatus Run(Bullet bullet)
    {
        bullet.Speed += GetVelocity(bullet);

        RunDelta += 1.0f * bullet.TimeSpeed;
        if (Duration <= RunDelta)
        {
            TaskFinished = true;
            return ERunStatus.End;
        }

        // 由于此任务未完成，下次继续运行
        return ERunStatus.Continue;
    }

    #endregion //方法
}
