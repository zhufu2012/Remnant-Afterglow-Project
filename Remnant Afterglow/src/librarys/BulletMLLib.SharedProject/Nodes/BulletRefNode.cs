using System;

namespace BulletMLLib.SharedProject.Nodes;

public class BulletRefNode : BulletNode
{
    #region Members

    /// <summary>
    /// 获取引用的子弹节点。
    /// </summary>
    /// <value>引用的子弹节点。</value>
    public BulletNode ReferencedBulletNode { get; private set; }

    #endregion //Members

    #region Methods

    /// <summary>
    /// 初始化 <see cref="BulletRefNode"/> 类的新实例。
    /// </summary>
    public BulletRefNode()
        : base(ENodeName.bulletRef) { }

    /// <summary>
    /// 验证节点。
    /// 在子类中重载以验证每种类型的节点是否遵循正确的业务逻辑。
    /// 这检查了XML验证未验证的内容
    /// </summary>
    public override void ValidateNode()
    {
        //执行任何基类验证
        base.ValidateNode();

        //确保这个家伙知道他的子弹节点在哪里
        FindMyBulletNode();
    }

    /// <summary>
    /// 查找引用的子弹节点。
    /// </summary>
    public void FindMyBulletNode()
    {
        if (null == ReferencedBulletNode)
        {
            //查找这个家伙引用的动作节点
            var refNode = GetRootNode().FindLabelNode(Label, ENodeName.bullet);

            //确保我们找到了什么
            if (null == refNode)
            {
                throw new NullReferenceException(
                    "找不到子弹节点 \"" + Label + "\""
                );
            }

            ReferencedBulletNode = refNode as BulletNode;
            if (null == ReferencedBulletNode)
            {
                throw new NullReferenceException(
                    "BulletMLNode \"" + Label + "\" 不是一个子弹节点"
                );
            }
        }
    }

    #endregion //Methods
}
