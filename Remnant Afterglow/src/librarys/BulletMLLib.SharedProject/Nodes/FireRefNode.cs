using System;
using System.Diagnostics;

namespace BulletMLLib.SharedProject.Nodes;

public class FireRefNode : FireNode
{
    #region Members

    /// <summary>
    /// 获取引用的开火节点。
    /// </summary>
    /// <value>引用的开火节点。</value>
    public FireNode ReferencedFireNode { get; private set; }

    #endregion //Members

    #region Methods

    /// <summary>
    /// 初始化 <see cref="FireRefNode"/> 类的新实例。
    /// </summary>
    public FireRefNode()
        : base(ENodeName.fireRef) { }

    /// <summary>
    /// 验证节点。
    /// 在子类中重载以验证每种类型的节点是否遵循正确的业务逻辑。
    /// 这检查了XML验证未验证的内容
    /// </summary>
    public override void ValidateNode()
    {
        //查找这个家伙的动作节点
        Debug.Assert(null != GetRootNode());
        var refNode = GetRootNode().FindLabelNode(Label, ENodeName.fire);

        //确保我们找到了什么
        if (null == refNode)
        {
            throw new NullReferenceException("找不到开火节点 \"" + Label + "\"");
        }

        ReferencedFireNode = refNode as FireNode;
        if (null == ReferencedFireNode)
        {
            throw new NullReferenceException(
                "BulletMLNode \"" + Label + "\" 不是一个开火节点"
            );
        }

        //不要验证这个家伙的基类...它会试图查找子弹节点时出错！
    }

    #endregion //Methods
}
