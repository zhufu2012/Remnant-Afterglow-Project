using System.Diagnostics;
using BulletMLLib.SharedProject.Nodes;

namespace BulletMLLib.SharedProject.Tasks;

/// <summary>
/// 此任务设置子弹的方向
/// </summary>
public class SetDirectionTask : BulletMLTask
{
    #region Methods

    /// <summary>
    /// 初始化 <see cref="BulletMLTask"/> 类的新实例。
    /// </summary>
    /// <param name="node">节点。</param>
    /// <param name="owner">所有者。</param>
    public SetDirectionTask(DirectionNode node, BulletMLTask owner)
        : base(node, owner)
    {
        Debug.Assert(null != Node);
        Debug.Assert(null != Owner);
    }

    #endregion //Methods
}
