using System;

namespace BulletMLLib.SharedProject.Nodes;

/// <summary>
/// 动作引用节点。
/// 此节点类型引用另一个动作节点。
/// </summary>
public class ActionRefNode : ActionNode
{
    #region Members

    public ActionNode ReferencedActionNode { get; private set; }

    #endregion //Members

    #region Methods

    /// <summary>
    /// 初始化 <see cref="ActionRefNode"/> 类的新实例。
    /// </summary>
    public ActionRefNode()
        : base(ENodeName.actionRef) { }

    /// <summary>
    /// 验证节点。
    /// 在子类中重载以验证每种类型的节点是否遵循正确的业务逻辑。
    /// 这检查了XML验证未验证的内容
    /// </summary>
    public override void ValidateNode()
    {
        //执行任何基类验证
        base.ValidateNode();
        //查找这个家伙引用的动作节点
        var refNode = GetRootNode().FindLabelNode(Label, ENodeName.action);
        //确保我们找到了什么
        if (null == refNode)
        {
            throw new NullReferenceException("找不到动作节点 \"" + Label + "\"");
        }

        ReferencedActionNode = refNode as ActionNode;
        if (null == ReferencedActionNode)
        {
            throw new NullReferenceException(
                "BulletMLNode \"" + Label + "\" 不是一个动作节点"
            );
        }
    }

    #endregion //Methods
}
