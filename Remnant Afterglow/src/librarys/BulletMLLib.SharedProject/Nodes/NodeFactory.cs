using System;

namespace BulletMLLib.SharedProject.Nodes;

/// <summary>
/// 这是一个用于创建不同类型节点的简单类。
/// </summary>
public static class NodeFactory
{
    /// <summary>
    /// 给定一个节点类型，创建正确的节点。
    /// </summary>
    /// <returns>正确节点类型的实例</returns>
    /// <param name="nodeType">我们想要的节点类型。</param>
    public static BulletMLNode CreateNode(ENodeName nodeType)
    {
        return nodeType switch
        {
            ENodeName.bullet => new BulletNode(),
            ENodeName.action => new ActionNode(),
            ENodeName.fire => new FireNode(),
            ENodeName.changeDirection => new ChangeDirectionNode(),
            ENodeName.changeSpeed => new ChangeSpeedNode(),
            ENodeName.accel => new AccelNode(),
            ENodeName.wait => new WaitNode(),
            ENodeName.repeat => new RepeatNode(),
            ENodeName.bulletRef => new BulletRefNode(),
            ENodeName.actionRef => new ActionRefNode(),
            ENodeName.fireRef => new FireRefNode(),
            ENodeName.vanish => new VanishNode(),
            ENodeName.horizontal => new HorizontalNode(),
            ENodeName.vertical => new VerticalNode(),
            ENodeName.term => new TermNode(),
            ENodeName.times => new TimesNode(),
            ENodeName.direction => new DirectionNode(),
            ENodeName.speed => new SpeedNode(),
            ENodeName.param => new ParamNode(),
            ENodeName.bulletml => new(ENodeName.bulletml),
            _ => throw new($"未处理的ENodeName类型: {nodeType}")
        };
    }
}
