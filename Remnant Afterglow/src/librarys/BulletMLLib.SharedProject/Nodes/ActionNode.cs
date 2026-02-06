using System;
using BulletMLLib.SharedProject.Tasks;

namespace BulletMLLib.SharedProject.Nodes;

/// <summary>
/// 动作节点...也是动作引用节点的基类
/// </summary>
public class ActionNode : BulletMLNode
{
    #region Members

    /// <summary>
    /// 获取或设置父重复节点。
    /// 这是紧接在此节点上方的节点，用于指定重复此动作的次数。
    /// </summary>
    /// <value>父重复节点。</value>
    public RepeatNode ParentRepeatNode { get; private set; }

    #endregion //Members

    #region Methods

    /// <summary>
    /// 初始化 <see cref="ActionNode"/> 类的新实例。
    /// </summary>
    public ActionNode()
        : this(ENodeName.action) { }

    /// <summary>
    /// 初始化 <see cref="ActionNode"/> 类的新实例。
    /// 这是子类使用的构造函数
    /// </summary>
    /// <param name="eNodeType">节点类型。</param>
    public ActionNode(ENodeName eNodeType)
        : base(eNodeType) { }

    /// <summary>
    /// 验证节点。
    /// 在子类中重载以验证每种类型的节点是否遵循正确的业务逻辑。
    /// 这检查了XML验证未验证的内容
    /// </summary>
    public override void ValidateNode()
    {
        //获取我们的父重复节点（如果有的话）
        ParentRepeatNode = FindParentRepeatNode();

        //执行任何基类验证
        base.ValidateNode();
    }

    /// <summary>
    /// 查找父重复节点。
    /// 此方法不是递归的，因为动作和动作引用节点可以嵌套。
    /// </summary>
    /// <returns>父重复节点。</returns>
    private RepeatNode FindParentRepeatNode()
    {
        //动作节点上的父节点绝不应为空
        if (null == Parent)
        {
            throw new NullReferenceException(
                "动作或动作引用节点上的父节点不能为空"
            );
        }

        //如果父节点是重复节点，则检查重复此动作的次数
        if (Parent.Name == ENodeName.repeat)
        {
            return Parent as RepeatNode;
        }

        //这个节点不在重复节点下
        return null;
    }

    /// <summary>
    /// 获取此动作应重复的次数。
    /// </summary>
    /// <param name="myTask">要获取重复次数的任务</param>
    /// <param name="bullet">子弹对象</param>
    /// <returns>根据父重复节点指定的重复此节点的次数。</returns>
    public int RepeatNum(ActionTask myTask, Bullet bullet)
    {
        if (null != ParentRepeatNode)
        {
            //获取重复节点的方程值
            return (int)ParentRepeatNode.GetChildValue(ENodeName.times, myTask, bullet);
        }

        //没有重复节点，只重复一次
        return 1;
    }

    #endregion //Methods
}
