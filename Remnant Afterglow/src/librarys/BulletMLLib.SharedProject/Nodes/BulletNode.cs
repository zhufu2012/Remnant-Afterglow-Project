namespace BulletMLLib.SharedProject.Nodes;

public class BulletNode : BulletMLNode
{
    /// <summary>
    /// 初始化 <see cref="BulletNode"/> 类的新实例。
    /// </summary>
    public BulletNode()
        : this(ENodeName.bullet) { }

    /// <summary>
    /// 初始化 <see cref="BulletNode"/> 类的新实例。
    /// 这是子类使用的构造函数
    /// </summary>
    /// <param name="eNodeType">节点类型。</param>
    public BulletNode(ENodeName eNodeType)
        : base(eNodeType) { }
}
