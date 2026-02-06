using System;
using System.Collections.Generic;
using System.Diagnostics;
using BulletMLLib.SharedProject.Nodes;

namespace BulletMLLib.SharedProject.Tasks;

/// <summary>
/// 这是一个任务..每个任务都是单个xml节点对一个子弹的操作。
/// 基本上每个子弹都会创建一个这样的树来匹配其模式
/// </summary>
public class BulletMLTask
{
    #region 成员变量

    /// <summary>
    /// 此任务的子任务列表
    /// </summary>
    public List<BulletMLTask> ChildTasks { get; private set; }

    /// <summary>
    /// 此任务的参数列表
    /// </summary>
    public List<float> ParamList { get; private set; }

    /// <summary>
    /// 此任务在树中的父任务
    /// 用于获取参数值。
    /// </summary>
    public BulletMLTask Owner { get; set; }

    /// <summary>
    /// 此任务代表的子弹ml节点
    /// </summary>
    public BulletMLNode Node { get; private set; }

    /// <summary>
    /// 此任务是否已完成运行
    /// </summary>
    public bool TaskFinished { get; protected set; }

    #endregion //成员变量

    #region 方法

    /// <summary>
    /// 初始化 <see cref="BulletMLTask"/> 类的新实例。
    /// </summary>
    /// <param name="node">节点。</param>
    /// <param name="owner">所有者。</param>
    public BulletMLTask(BulletMLNode node, BulletMLTask owner)
    {
        ChildTasks = new();
        ParamList = new();
        TaskFinished = false;
        Owner = owner;
        Node = node ?? throw new NullReferenceException("节点参数不能为空");
    }

    /// <summary>
    /// 将指定的节点和子弹解析到此任务中
    /// </summary>
    /// <param name="bullet">此任务控制的子弹</param>
    public virtual void ParseTasks(Bullet bullet)
    {
        if (null == bullet)
        {
            throw new NullReferenceException("子弹参数不能为空");
        }

        foreach (var childNode in Node.ChildNodes)
        {
            ParseChildNode(childNode, bullet);
        }
    }

    /// <summary>
    /// 将指定的节点和子弹解析到此任务中
    /// </summary>
    /// <param name="childNode">此任务的节点</param>
    /// <param name="bullet">此任务控制的子弹</param>
    protected virtual void ParseChildNode(BulletMLNode childNode, Bullet bullet)
    {
        Debug.Assert(null != childNode);
        Debug.Assert(null != bullet);

        //构建正确类型的节点
        switch (childNode.Name)
        {
            case ENodeName.repeat://重复一个动作
				{
					//将节点转换为repeatnode
					var myRepeatNode = childNode as RepeatNode;
					//为重复节点创建占位符bulletmltask
					var repeatTask = new RepeatTask(myRepeatNode, this);
					//将子节点解析到重复任务中
					repeatTask.ParseTasks(bullet);
					//存储任务
					ChildTasks.Add(repeatTask);
				}
                break;
            case ENodeName.action://定义子弹的行为
				{
					//将节点转换为ActionNode
					var myActionNode = childNode as ActionNode;
					//创建动作任务
					var actionTask = new ActionTask(myActionNode, this);
					//将动作节点的子节点解析到任务中
					actionTask.ParseTasks(bullet);
					//存储任务
					ChildTasks.Add(actionTask);
				}
                break;
            case ENodeName.actionRef://引用动作
				{
					//将节点转换为ActionNode
					var myActionNode = childNode as ActionRefNode;
					//创建动作任务
					var actionTask = new ActionTask(myActionNode, this);
					//将参数添加到动作任务中
					for (var i = 0; i < childNode.ChildNodes.Count; i++)
					{
						actionTask.ParamList.Add(
							childNode.ChildNodes[i].GetValue(this, bullet)
						);
					}
					//将动作节点的子节点解析到任务中
					actionTask.ParseTasks(bullet);
					//存储任务
					ChildTasks.Add(actionTask);
				}
                break;
            case ENodeName.changeSpeed://改变速度
				{
					ChildTasks.Add(new ChangeSpeedTask(childNode as ChangeSpeedNode, this));
				}
			    break;
            case ENodeName.changeDirection://改变子弹的方向
				{
					ChildTasks.Add(new ChangeDirectionTask(childNode as ChangeDirectionNode, this));
				}
                break;
            case ENodeName.fire://发射子弹
				{
					//将节点转换为fire节点
					var myFireNode = childNode as FireNode;
					//创建发射任务
					var fireTask = new FireTask(myFireNode, this);
					//将发射节点的子节点解析到任务中
					fireTask.ParseTasks(bullet);
					//存储任务
					ChildTasks.Add(fireTask);
				}
                break;
            case ENodeName.fireRef://引用发射动作
				{
					//将节点转换为fireref节点
					//创建发射任务
					if (childNode is FireRefNode myFireNode)
					{
						var fireTask = new FireTask(myFireNode.ReferencedFireNode, this);
						//将参数添加到发射任务中
						for (var i = 0; i < childNode.ChildNodes.Count; i++)
						{
							fireTask.ParamList.Add(
								childNode.ChildNodes[i].GetValue(this, bullet)
							);
						}
						//将动作节点的子节点解析到任务中
						fireTask.ParseTasks(bullet);
						//存储任务
						ChildTasks.Add(fireTask);
					}
				}
                break;
            case ENodeName.wait://等待
				{
					ChildTasks.Add(new WaitTask(childNode as WaitNode, this));
				}
                break;
            case ENodeName.vanish://让子弹消失
				{
					ChildTasks.Add(new VanishTask(childNode as VanishNode, this));
				}
                break;
            case ENodeName.accel://添加加速度
				{
					ChildTasks.Add(new AccelTask(childNode as AccelNode, this));
				}
                break;
        }
    }

    /// <summary>
    /// 当嵌套的重复节点被初始化时调用此方法。
    /// </summary>
    /// <param name="bullet">子弹。</param>
    protected virtual void HardReset(Bullet bullet)
    {
        TaskFinished = false;
        foreach (var task in ChildTasks)
        {
            task.HardReset(bullet);
        }
        SetupTask(bullet);
    }

    /// <summary>
    /// 初始化此任务及其所有子任务。
    /// 此方法应在节点解析之后、运行之前调用。
    /// </summary>
    /// <param name="bullet">此任务控制的子弹</param>
    public virtual void InitTask(Bullet bullet)
    {
        TaskFinished = false;
        foreach (var task in ChildTasks)
        {
            task.InitTask(bullet);
        }
        SetupTask(bullet);
    }

    /// <summary>
    /// 设置任务准备运行。
    /// </summary>
    /// <param name="bullet">子弹。</param>
    protected virtual void SetupTask(Bullet bullet)
    {
        //在子类中重载
    }

    /// <summary>
    /// 针对子弹运行此任务和所有子任务
    /// 在运行时每帧调用一次。
    /// </summary>
    /// <returns>ERunStatus: 此任务是已完成、暂停还是仍在运行</returns>
    /// <param name="bullet">要针对其更新此任务的子弹。</param>
    public virtual ERunStatus Run(Bullet bullet)
    {
        //运行所有子任务
        TaskFinished = true;
        for (var i = 0; i < ChildTasks.Count; i++)
        {
            //子任务是否已完成运行？
            if (!ChildTasks[i].TaskFinished)
            {
                //运行子任务...
                var childStatus = ChildTasks[i].Run(bullet);
                if (childStatus == ERunStatus.Stop)
                {
                    //子任务已暂停，所以未完成
                    TaskFinished = false;
                    return childStatus;
                }

                if (childStatus == ERunStatus.Continue)
                {
                    //子任务需要做更多工作
                    TaskFinished = false;
                }
            }
        }

        return TaskFinished ? ERunStatus.End : ERunStatus.Continue;
    }

    /// <summary>
    /// 获取此任务参数的值。
    /// </summary>
    /// <returns>参数值。</returns>
    /// <param name="iParamNumber">要获取的参数索引</param>
    public double GetParamValue(int iParamNumber)
    {
        //如果该任务没有任何参数，则向上查找直到找到有参数的任务
        if (ParamList.Count < iParamNumber)
        {
            //当前任务没有足够的参数来解决此值
            return Owner?.GetParamValue(iParamNumber) ?? 0.0f;
        }

        //该参数的值就是我们想要的
        return ParamList[iParamNumber - 1];
    }

    /// <summary>
    /// 获取节点值。
    /// </summary>
    /// <returns>节点值。</returns>
    public float GetNodeValue(Bullet bullet)
    {
        return Node.GetValue(this, bullet);
    }

    /// <summary>
    /// 根据标签查找任务。
    /// 这会递归进入子任务以找到具有正确标签的任务
    /// 仅用于单元测试！
    /// </summary>
    /// <returns>按标签查找的任务。</returns>
    /// <param name="strLabel">字符串标签。</param>
    public BulletMLTask FindTaskByLabel(string strLabel)
    {
        //检查这是否是正确的任务
        if (strLabel == Node.Label)
        {
            return this;
        }

        //检查任何子任务是否具有该标签的任务
        foreach (var childTask in ChildTasks)
        {
            var foundTask = childTask.FindTaskByLabel(strLabel);
            if (null != foundTask)
            {
                return foundTask;
            }
        }

        return null;
    }

    /// <summary>
    /// 给定标签和名称，找到匹配的任务
    /// </summary>
    /// <returns>按标签和名称查找的任务。</returns>
    /// <param name="strLabel">任务的字符串标签</param>
    /// <param name="eName">任务应附加到的节点名称</param>
    public BulletMLTask FindTaskByLabelAndName(string strLabel, ENodeName eName)
    {
        //检查这是否是正确的任务
        if ((strLabel == Node.Label) && (eName == Node.Name))
        {
            return this;
        }

        //检查任何子任务是否具有该标签的任务
        foreach (var childTask in ChildTasks)
        {
            var foundTask = childTask.FindTaskByLabelAndName(strLabel, eName);
            if (null != foundTask)
            {
                return foundTask;
            }
        }

        return null;
    }

    #endregion //方法
}
