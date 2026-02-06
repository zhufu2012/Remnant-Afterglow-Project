using System.Diagnostics;

namespace BulletMLLib.SharedProject.Nodes;

public class FireNode : BulletMLNode
{
    #region Members

    /// <summary>
    /// 此任务将使用的子弹节点，用于设置从此任务发射的任何子弹
    /// </summary>
    /// <value>子弹节点。</value>
    public BulletNode BulletDescriptionNode { get; set; }

    #endregion //Members

    #region Methods

    /// <summary>
    /// 初始化 <see cref="FireNode"/> 类的新实例。
    /// </summary>
    public FireNode()
        : this(ENodeName.fire) { }

    /// <summary>
    /// 初始化 <see cref="FireNode"/> 类的新实例。
    /// 这是子类使用的构造函数
    /// </summary>
    /// <param name="eNodeType">节点类型。</param>
    public FireNode(ENodeName eNodeType)
        : base(eNodeType) { }

    /// <summary>
    /// 验证节点。
    /// 在子类中重载以验证每种类型的节点是否遵循正确的业务逻辑。
    /// 这检查了XML验证未验证的内容
    /// </summary>
    public override void ValidateNode()
    {
        base.ValidateNode();

        //检查子弹节点
        BulletDescriptionNode = GetChild(ENodeName.bullet) as BulletNode;

        //如果没有找到，检查bulletref节点
        if (null == BulletDescriptionNode)
        {
            //确保那个家伙知道他在做什么
            if (GetChild(ENodeName.bulletRef) is BulletRefNode refNode)
            {
                refNode.FindMyBulletNode();
                BulletDescriptionNode = refNode.ReferencedBulletNode;
            }
        }

        Debug.Assert(null != BulletDescriptionNode);
    }

    #endregion Methods
}
