using System.Diagnostics;
using BulletMLLib.SharedProject.Nodes;

namespace BulletMLLib.SharedProject.Tasks;

/// <summary>
/// 这是一个任务..每个任务都是单个xml节点对一个子弹的操作。
/// 基本上每个子弹都会创建一个这样的树来匹配其模式
/// </summary>
public class RepeatTask : BulletMLTask
{
    #region 方法

    /// <summary>
    /// 初始化 <see cref="BulletMLTask"/> 类的新实例。
    /// </summary>
    /// <param name="node">节点。</param>
    /// <param name="owner">所有者。</param>
    public RepeatTask(RepeatNode node, BulletMLTask owner)
        : base(node, owner)
    {
        Debug.Assert(null != Node);
        Debug.Assert(null != Owner);
    }

    /// <summary>
    /// 初始化此任务及其所有子任务。
    /// 此方法应在节点解析之后、运行之前调用。
    /// </summary>
    /// <param name="bullet">此任务控制的子弹</param>
    public override void InitTask(Bullet bullet)
    {
        // 在RepeatTask上调用Init task，这意味着该任务下的所有序列节点都需要重置

        // 调用基类的HardReset方法
        HardReset(bullet);
    }

    #endregion //方法
}
