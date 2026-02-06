using System;
using System.Collections.Generic;
using System.Linq;
using System.Xml;
using BulletMLLib.SharedProject.Tasks;

namespace BulletMLLib.SharedProject.Nodes;

/// <summary>
/// 这是BulletML文档中的单个节点 解析的代码
/// 用作所有其他节点类型的基节点。
/// </summary>
public class BulletMLNode
{
    /// <summary>
    /// 此项的XML节点名称
    /// </summary>
    public ENodeName Name { get; }

    /// <summary>
    /// 获取或设置节点的类型。
    /// 这是virtual的，因此子类可以覆盖它并进行自己的验证。
    /// </summary>
    /// <value>节点的类型。</value>
    public virtual ENodeType NodeType { get; protected set; } = ENodeType.none;

    /// <summary>
    /// 这是节点标签
    /// </summary>
    public string Label { get; private set; } = Guid.NewGuid().ToString();

    /// <summary>
    /// 用于获取此节点值的方程。
    /// </summary>
    /// <value>节点值。</value>
    private readonly BulletMLEquation NodeEquation = new();

    /// <summary>
    /// 此节点的所有子节点列表
    /// </summary>
    public List<BulletMLNode> ChildNodes { get; }

    /// <summary>
    /// 指向此节点的父节点
    /// </summary>
    protected BulletMLNode Parent { get; private set; }

    /// <summary>
    /// 初始化 <see cref="BulletMLNode"/> 类的新实例。
    /// </summary>
    public BulletMLNode(ENodeName nodeType)
    {
        ChildNodes = new();
        Name = nodeType;
        //NodeType = ENodeType.none;
    }

    /// <summary>
    /// 将字符串转换为其ENodeType枚举等价物
    /// </summary>
    /// <returns>ENodeType: 该字符串的枚举值</returns>
    /// <param name="str">要转换为枚举的字符串</param>
    public static ENodeType StringToType(string str)
    {
        //确保有内容
        if (string.IsNullOrEmpty(str))
        {
            return ENodeType.none;
        }

        return (ENodeType)Enum.Parse(typeof(ENodeType), str);
    }

    /// <summary>
    /// 将字符串转换为其ENodeName枚举等价物
    /// </summary>
    /// <returns>ENodeName: 该字符串的枚举值</returns>
    /// <param name="str">要转换为枚举的字符串</param>
    private static ENodeName StringToName(string str)
    {
        return (ENodeName)Enum.Parse(typeof(ENodeName), str);
    }

    /// <summary>
    /// 获取根节点。
    /// </summary>
    /// <returns>根节点。</returns>
    public BulletMLNode GetRootNode()
    {
        //递归向上直到获取到根节点
        return null != Parent ? Parent.GetRootNode() : this;
    }

    /// <summary>
    /// 查找特定类型和标签的节点
    /// 在XML树中递归查找！
    /// </summary>
    /// <returns>标签节点。</returns>
    /// <param name="label">我们要查找的节点的标签</param>
    /// <param name="name">我们要查找的节点的名称</param>
    public BulletMLNode FindLabelNode(string label, ENodeName name)
    {
        //使用广度优先搜索，因为标记的节点通常是顶级的

        //检查我们的任何子节点是否匹配请求
        foreach (var t in ChildNodes.Where(t => name == t.Name && (label == t.Label)))
        {
            return t;
        }

        //递归到子节点中查看是否找到任何匹配项
        return ChildNodes
            .Select(t => t.FindLabelNode(label, name))
            .FirstOrDefault(foundNode => null != foundNode);

        //未找到具有该名称的BulletMLNode :(
    }

    /// <summary>
    /// 查找指定节点类型的父节点
    /// </summary>
    /// <returns>该类型的第一个父节点，如果未找到则返回null</returns>
    /// <param name="nodeType">要查找的节点类型。</param>
    public BulletMLNode FindParentNode(ENodeName nodeType)
    {
        //首先检查我们是否有父节点
        if (null == Parent)
        {
            return null;
        }

        return nodeType == Parent.Name
            ?
            //我们的父节点匹配查询，返回它！
            Parent
            :
            //递归到父节点中检查祖父节点等。
            Parent.FindParentNode(nodeType);
    }

    /// <summary>
    /// 获取任务的特定类型子节点的值
    /// </summary>
    /// <returns>子节点的值。如果未找到节点则返回0.0</returns>
    /// <param name="name">我们想要的子节点类型。</param>
    /// <param name="task">获取值的任务</param>
    /// <param name="bullet">子弹。</param>
    public float GetChildValue(ENodeName name, BulletMLTask task, Bullet bullet) =>
    (
        from tree in ChildNodes
        where tree.Name == name
        select tree.GetValue(task, bullet)
    ).FirstOrDefault();

    /// <summary>
    /// 获取特定类型的直接子节点。不递归！
    /// </summary>
    /// <returns>子节点。如果未找到则返回null</returns>
    /// <param name="name">我们想要的节点类型</param>
    public BulletMLNode GetChild(ENodeName name) =>
        ChildNodes.FirstOrDefault(node => node.Name == name);

    /// <summary>
    /// 获取此节点在任务特定实例中的值。
    /// </summary>
    /// <returns>值。</returns>
    /// <param name="task">任务。</param>
    /// <param name="bullet">获取值的子弹</param>
    public float GetValue(BulletMLTask task, Bullet bullet)
    {
        //发送到方程以获得答案
        return (float)NodeEquation.Solve(task.GetParamValue, bullet.MyBulletManager.Tier);
    }

    /// <summary>
    /// 解析指定的bulletNodeElement。
    /// 将所有数据从xml节点读入此节点。
    /// </summary>
    /// <param name="bulletNodeElement">子弹节点元素。</param>
    /// <param name="parentNode"></param>
    public void Parse(XmlNode bulletNodeElement, BulletMLNode parentNode)
    {
        // 处理null参数。
        if (null == bulletNodeElement)
        {
            throw new ArgumentNullException(nameof(bulletNodeElement));
        }

        //获取父节点
        Parent = parentNode;

        //解析所有属性
        XmlNamedNodeMap mapAttributes = bulletNodeElement.Attributes;
        for (var i = 0; i < mapAttributes!.Count; i++)
        {
            var strName = mapAttributes.Item(i)!.Name;
            var strValue = mapAttributes.Item(i)!.Value;

            switch (strName)
            {
                //跳过顶级节点中的类型属性
                case "type" when ENodeName.bulletml == Name:
                    continue;
                //获取子弹节点类型
                case "type":
                    NodeType = StringToType(strValue);
                    break;
                case "label":
                    Label = strValue;
                    break;
            }
        }

        //解析所有子节点
        if (!bulletNodeElement.HasChildNodes)
            return;

        for (
            var childNode = bulletNodeElement.FirstChild;
            null != childNode;
            childNode = childNode.NextSibling
        )
        {
            switch (childNode.NodeType)
            {
                //如果子节点是文本节点，就把它解析成这个
                case XmlNodeType.Text:
                    //获取子xml节点的文本，但将其存储在此子弹节点中
                    NodeEquation.Parse(childNode.Value);
                    continue;
                case XmlNodeType.Comment:
                    //跳过bulletml脚本中的任何注释
                    continue;
                default:
                    //创建新节点
                    var childBulletNode = NodeFactory.CreateNode(StringToName(childNode.Name));
                    //读入节点并存储它
                    childBulletNode.Parse(childNode, this);
                    ChildNodes.Add(childBulletNode);
                    break;
            }
        }
    }

    /// <summary>
    /// 验证节点。
    /// 在子类中重载以验证每种类型的节点是否遵循正确的业务逻辑。
    /// 这检查XML验证未验证的内容
    /// </summary>
    public virtual void ValidateNode()
    {
        //验证所有子节点
        foreach (var childNode in ChildNodes)
        {
            childNode.ValidateNode();
        }
    }
}
