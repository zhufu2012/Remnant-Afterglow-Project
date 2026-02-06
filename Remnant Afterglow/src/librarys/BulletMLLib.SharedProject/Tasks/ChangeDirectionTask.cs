using System;
using System.Diagnostics;
using BulletMLLib.SharedProject.Nodes;

namespace BulletMLLib.SharedProject.Tasks;

/// <summary>
/// 这个任务每帧都会稍微改变方向
/// </summary>
public class ChangeDirectionTask : BulletMLTask
{
    #region 成员变量
    /// <summary>
    /// 从节点中提取的数值
    /// </summary>
    private float NodeDirection;

    /// <summary>
    /// 方向变化的类型，从节点中提取
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
    public ChangeDirectionTask(ChangeDirectionNode node, BulletMLTask owner)
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
        RunDelta = 0;

        //设置运行此任务的时间长度
        Duration = Node.GetChildValue(ENodeName.term, this, bullet);

        //检查除零错误
        if (Duration == 0.0f)
        {
            Duration = 1.0f;
        }

        //从节点获取改变方向的数值
        var dirNode = Node.GetChild(ENodeName.direction) as DirectionNode;
        NodeDirection = dirNode.GetValue(this, bullet) * (float)Math.PI / 180.0f; //同时确保转换为弧度

        //我们想要如何改变方向？
        ChangeType = dirNode.NodeType;
    }

    private float GetDirection(Bullet bullet)
    {
        //我们想要如何改变方向？
        var direction = ChangeType switch
        {
            ENodeType.sequence
                =>
                //我们将在每一帧把这个量加到方向上
                NodeDirection,
            ENodeType.absolute
                =>
                //我们将按照给定的方向进行移动，不管我们现在指向哪里
                NodeDirection - bullet.Direction,
            ENodeType.relative
                =>
                //方向的改变将相对于我们当前的方向
                NodeDirection,
            _ =>
             (NodeDirection + bullet.GetAimDir()) - bullet.Direction
        };

        //保持方向在-180°和180°之间
        direction = MathHelper.WrapAngle(direction);

        //序列类型的方向改变不受持续时间影响
        if (ChangeType == ENodeType.absolute)
        {
            //除以剩余的时间量
            direction /= Duration - RunDelta;
        }
        else if (ChangeType != ENodeType.sequence)
        {
            //除以持续时间，这样我们可以平滑地进入方向变化
            direction /= Duration;
        }

        return direction;
    }

    public override ERunStatus Run(Bullet bullet)
    {
        //将子弹的方向改变正确的量
        bullet.Direction += GetDirection(bullet);

        //减少剩余运行时间，当此任务完成时返回End
        RunDelta += 1.0f * bullet.TimeSpeed;
        if (!(Duration <= RunDelta))
            return ERunStatus.Continue;

        TaskFinished = true;
        return ERunStatus.End;

        //由于此任务未完成，下次继续运行
    }
    #endregion //方法
}
