using System.Diagnostics;
using BulletMLLib.SharedProject.Nodes;

namespace BulletMLLib.SharedProject.Tasks;

/// <summary>
/// 动作任务，该对象包含一个可重复执行的任务列表
/// </summary>
public class ActionTask : BulletMLTask
{
    #region 成员变量

    /// <summary>
    /// 动作重复执行的最大次数
    /// </summary>
    public int RepeatNumMax { get; private set; }

    /// <summary>
    /// 此任务已执行的次数
    /// 从0开始计数，直到达到"最大值"时任务停止重复执行
    /// </summary>
    public int RepeatNum { get; private set; }

    #endregion //成员变量

    #region 方法

    /// <summary>
    /// 初始化 <see cref="BulletMLLib.ActionTask"/> 类的新实例
    /// </summary>
    /// <param name="repeatNumMax">最大重复次数</param>
    /// <param name="node">节点</param>
    /// <param name="owner">拥有者</param>
    public ActionTask(ActionNode node, BulletMLTask owner)
        : base(node, owner)
    {
        Debug.Assert(null != Node);
        Debug.Assert(null != Owner);
    }

    /// <summary>
    /// 将指定的节点和子弹解析到此任务中
    /// </summary>
    /// <param name="myNode">此任务的节点</param>
    /// <param name="bullet">此任务控制的子弹</param>
    public override void ParseTasks(Bullet bullet)
    {
        //设置此动作的重复次数
        var actionNode = Node as ActionNode;
        Debug.Assert(null != actionNode);
        RepeatNumMax = actionNode.RepeatNum(this, bullet);

        //这是actionref任务吗？
        if (ENodeName.actionRef == Node.Name)
        {
            //在此任务下添加一个引用动作的子任务
            var myActionRefNode = Node as ActionRefNode;

            //创建动作任务
            var actionTask = new ActionTask(myActionRefNode.ReferencedActionNode, this);

            //将动作节点的子节点解析到任务中
            actionTask.ParseTasks(bullet);

            //存储任务
            ChildTasks.Add(actionTask);
        }

        //调用基类方法
        base.ParseTasks(bullet);
    }

    /// <summary>
    /// 设置任务准备运行
    /// </summary>
    /// <param name="bullet">子弹</param>
    protected override void SetupTask(Bullet bullet)
    {
        RepeatNum = 0;
    }

    /// <summary>
    /// 对子弹运行此任务和所有子任务
    /// 在运行时每帧调用一次
    /// </summary>
    /// <returns>ERunStatus: 表示此任务已完成、暂停或仍在运行</returns>
    /// <param name="bullet">用于更新此任务的子弹</param>
    public override ERunStatus Run(Bullet bullet)
    {
        //重复运行动作直到达到限制次数
        while (RepeatNum < RepeatNumMax)
        {
            var runStatus = base.Run(bullet);

            //运行所有子动作后的返回值是什么？
            switch (runStatus)
            {
                case ERunStatus.End:
                    {
                        //动作成功完成，初始化所有内容并再次运行
                        RepeatNum++;
                        //重置所有子任务
                        foreach (var task in ChildTasks)
                        {
                            task.InitTask(bullet);
                        }
                    }
                    break;
                case ERunStatus.Stop:
                    {
                        //子任务中的某些内容暂停了此动作
                        return runStatus;
                    }
                default:
                    {
                        //某个子任务需要在下一帧继续运行
                        return ERunStatus.Continue;
                    }
            }
        }
        //如果执行到这里，说明所有子任务都已正确执行了指定次数
        TaskFinished = true;
        return ERunStatus.End;
    }

    #endregion //方法
}
