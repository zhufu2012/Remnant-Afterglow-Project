namespace BulletMLLib.SharedProject.Nodes;

public class DirectionNode : BulletMLNode
{
    /// <summary>
    /// 初始化 <see cref="DirectionNode"/> 类的新实例。
    /// </summary>
    public DirectionNode()
        : base(ENodeName.direction)
    {
        //将默认类型设置为"aim"
        NodeType = ENodeType.aim;
    }

    /// <summary>
    /// 获取或设置节点的类型。
    /// 这是虚拟属性，因此子类可以覆盖它并验证它们自己的内容。
    /// </summary>
    /// <value>节点的类型。</value>
    public override ENodeType NodeType
    {
        get => base.NodeType;
        protected set
        {
            base.NodeType = value switch
            {
                ENodeType.absolute => value,
                ENodeType.relative => value,
                ENodeType.sequence => value,
                _ => ENodeType.aim
            };
        }
    }
}
