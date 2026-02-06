using System.Diagnostics;
using BulletMLLib.SharedProject.Nodes;

namespace BulletMLLib.SharedProject.Tasks;

/// <summary>
/// 此操作设置子弹的速度
/// </summary>
public class SetSpeedTask : BulletMLTask
{
    #region Methods

    /// <summary>
    /// 初始化 <see cref="BulletMLTask"/> 类的新实例。
    /// </summary>
    /// <param name="node">节点。</param>
    /// <param name="owner">所有者。</param>
    public SetSpeedTask(SpeedNode node, BulletMLTask owner)
        : base(node, owner)
    {
        Debug.Assert(null != Node);
        Debug.Assert(null != Owner);
    }

    #endregion //Methods
}
