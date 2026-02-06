using System;
using System.Diagnostics;
using BulletMLLib.SharedProject.Nodes;

namespace BulletMLLib.SharedProject.Tasks;

/// <summary>
/// 发射子弹的任务
/// </summary>
public class FireTask : BulletMLTask
{
    #region 成员变量

    /// <summary>
    /// 此任务将发射子弹的方向。
    /// </summary>
    /// <value>发射方向。</value>
    public float FireDirection { get; private set; }

    /// <summary>
    /// 此任务将发射子弹的速度。
    /// </summary>
    /// <value>发射速度。</value>
    public float FireSpeed { get; private set; }

    /// <summary>
    /// 此任务已初始化的次数
    /// </summary>
    /// <value>初始化次数。</value>
    public int NumTimesInitialized { get; private set; }

    /// <summary>
    /// 标志位，用于判断是否是此任务第一次运行
    /// 用于确定我们是否应该使用"initial"或"sequence"节点来设置子弹。
    /// </summary>
    /// <value><c>true</c> 如果是初次运行; 否则, <c>false</c>。</value>
    public bool InitialRun
    {
        get { return NumTimesInitialized <= 0; }
    }

    /// <summary>
    /// 如果此发射节点从子弹引用节点发射，这将是一个为其创建的任务。
    /// 这是必需的，以便正确设置子弹引用的参数。
    /// </summary>
    /// <value>子弹引用任务。</value>
    public BulletMLTask BulletRefTask { get; private set; }

    /// <summary>
    /// 我们将用来设置用此任务发射的任何子弹方向的节点
    /// </summary>
    /// <value>方向节点。</value>
    public SetDirectionTask InitialDirectionTask { get; private set; }

    /// <summary>
    /// 我们将用来设置用此任务发射的任何子弹速度的节点
    /// </summary>
    /// <value>速度节点。</value>
    public SetSpeedTask InitialSpeedTask { get; private set; }

    /// <summary>
    /// 如果有序列方向节点用于递增每个连续发射子弹的方向
    /// </summary>
    /// <value>序列方向节点。</value>
    public SetDirectionTask SequenceDirectionTask { get; private set; }

    /// <summary>
    /// 如果有序列速度节点用于递增每个连续发射子弹的速度
    /// </summary>
    /// <value>序列速度节点。</value>
    public SetSpeedTask SequenceSpeedTask { get; private set; }

    #endregion //成员变量

    #region 方法

    /// <summary>
    /// 初始化 <see cref="FireTask"/> 类的新实例。
    /// </summary>
    /// <param name="node">节点。</param>
    /// <param name="owner">所有者。</param>
    public FireTask(FireNode node, BulletMLTask owner)
        : base(node, owner)
    {
        Debug.Assert(null != Node);
        Debug.Assert(null != Owner);

        NumTimesInitialized = 0;
    }

    /// <summary>
    /// 将指定的节点和子弹解析到此任务中
    /// </summary>
    /// <param name="bullet">此任务控制的子弹</param>
    public override void ParseTasks(Bullet bullet)
    {
        if (null == bullet)
        {
            throw new NullReferenceException("子弹参数不能为空");
        }

        foreach (var childNode in Node.ChildNodes)
        {
            ParseChildNode(childNode, bullet);
        }

        //设置所有方向节点
        GetDirectionTasks(this);
        GetDirectionTasks(BulletRefTask);

        //设置所有速度节点
        GetSpeedNodes(this);
        GetSpeedNodes(BulletRefTask);
    }

    /// <summary>
    /// 将指定的节点和子弹解析到此任务中
    /// </summary>
    /// <param name="childNode">此任务的节点</param>
    /// <param name="bullet">此任务控制的子弹</param>
    protected override void ParseChildNode(BulletMLNode childNode, Bullet bullet)
    {
        Debug.Assert(null != childNode);
        Debug.Assert(null != bullet);

        switch (childNode.Name)
        {
            case ENodeName.bulletRef:

                {
                    //为子弹引用创建任务
                    if (childNode is BulletRefNode refNode)
                        BulletRefTask = new(refNode.ReferencedBulletNode, this);

                    //填充子弹引用的参数
                    foreach (var node in childNode.ChildNodes)
                    {
                        BulletRefTask.ParamList.Add(node.GetValue(this, bullet));
                    }

                    BulletRefTask.ParseTasks(bullet);
                    ChildTasks.Add(BulletRefTask);
                }
                break;

            case ENodeName.bullet:

                {
                    //为子弹引用创建任务
                    BulletRefTask = new(childNode, this);
                    BulletRefTask.ParseTasks(bullet);
                    ChildTasks.Add(BulletRefTask);
                }
                break;

            default:

                {
                    //如果我们不需要这个节点，就通过基类运行它
                    base.ParseChildNode(childNode, bullet);
                }
                break;
        }
    }

    /// <summary>
    /// 当嵌套的重复节点被初始化时调用此方法。
    /// </summary>
    /// <param name="bullet">子弹。</param>
    protected override void HardReset(Bullet bullet)
    {
        //这就是硬重置的要点，所以序列节点会被重置。
        NumTimesInitialized = 0;

        base.HardReset(bullet);
    }

    /// <summary>
    /// 设置任务准备运行。
    /// </summary>
    /// <param name="bullet">子弹。</param>
    protected override void SetupTask(Bullet bullet)
    {
        //获取发射子弹的方向

        //这是第一次运行吗？如果没有序列节点，我们不关心！
        if (InitialRun || null == SequenceDirectionTask)
        {
            //我们有初始方向节点吗？
            if (null != InitialDirectionTask)
            {
                //将发射方向设置为"初始"值
                var newBulletDirection =
                    InitialDirectionTask.GetNodeValue(bullet) * (float)Math.PI / 180.0f;
                FireDirection = InitialDirectionTask.Node.NodeType switch
                {
                    ENodeType.absolute
                        =>
                        //新子弹直接指向特定方向
                        newBulletDirection,
                    ENodeType.relative
                        =>
                        //新子弹方向将相对于旧子弹
                        newBulletDirection + bullet.Direction,
                    _ =>  bullet.GetAimDir()
                };
            }
            else
            {
                //没有初始方向任务，所以让子弹瞄准玩家
                FireDirection = bullet.GetAimDir();
            }
        }
        else
        {
            //否则如果有序列节点，将值添加到"射击方向"
            FireDirection +=
                SequenceDirectionTask.GetNodeValue(bullet) * (float)Math.PI / 180.0f;
        }

        //设置发射子弹的速度

        //这是第一次运行吗？如果没有序列节点，我们不关心！
        if (InitialRun || (null == SequenceSpeedTask))
        {
            //我们有初始速度节点吗？
            if (null != InitialSpeedTask)
            {
                //将射击速度设置为"初始"值。
                var newBulletSpeed = InitialSpeedTask.GetNodeValue(bullet);
                FireSpeed = InitialSpeedTask.Node.NodeType switch
                {
                    ENodeType.relative
                        =>
                        //新子弹速度将相对于旧子弹
                        newBulletSpeed + bullet.Speed,
                    _ => newBulletSpeed
                };
            }
            else
            {
                //没有初始速度任务，使用旧子弹的速度
                FireSpeed = bullet.Speed;
            }
        }
        else
        {
            //否则如果有序列节点，将值添加到"射击方向"
            FireSpeed += SequenceSpeedTask.GetNodeValue(bullet);
        }

        //确保方向在0到359之间
        while (FireDirection > Math.PI)
        {
            FireDirection -= (2.0f * (float)Math.PI);
        }
        while (-Math.PI > FireDirection)
        {
            FireDirection += (2.0f * (float)Math.PI);
        }

        //确保我们不会覆盖不应该覆盖的初始值
        NumTimesInitialized++;
    }

    /// <summary>
    /// 针对子弹运行此任务和所有子任务
    /// 在运行时每帧调用一次。
    /// </summary>
    /// <returns>ERunStatus: 此任务是已完成、暂停还是仍在运行</returns>
    /// <param name="bullet">要针对其更新此任务的子弹。</param>
    public override ERunStatus Run(Bullet bullet)
    {
        //创建新子弹
        var newBullet = bullet.MyBulletManager.CreateBullet(bullet, bullet.targetObject, bullet.createObject);

        if (newBullet == null)
        {
            TaskFinished = true;
            return ERunStatus.End;
        }

        //设置新子弹的位置
        newBullet.X = bullet.X;
        newBullet.Y = bullet.Y;

        //设置新子弹的方向
        newBullet.Direction = FireDirection;

        //设置新子弹的速度
        newBullet.Speed = FireSpeed;

        //使用存储在Fire节点中的子弹节点初始化子弹
        var myFireNode = Node as FireNode;
        Debug.Assert(null != myFireNode);
        newBullet.InitNode(myFireNode.BulletDescriptionNode, bullet.targetObject, bullet.createObject);

        //将新子弹的所有顶级任务的所有者设置为此任务
        foreach (var task in newBullet.Tasks)
        {
            task.Owner = this;
        }

        TaskFinished = true;
        return ERunStatus.End;
    }

    /// <summary>
    /// 给定一个节点，从中提取方向节点并在必要时存储它们
    /// </summary>
    /// <param name="taskToCheck">要检查是否具有子方向节点的任务。</param>
    private void GetDirectionTasks(BulletMLTask taskToCheck)
    {
        //检查是否有方向节点
        if (taskToCheck?.Node.GetChild(ENodeName.direction) is not DirectionNode dirNode)
            return;

        //检查它是否是序列类型的节点
        if (ENodeType.sequence == dirNode.NodeType)
        {
            //我们需要序列节点吗？
            SequenceDirectionTask ??= new(dirNode, taskToCheck);
        }
        else
        {
            //否则我们需要初始节点吗？
            InitialDirectionTask ??= new(dirNode, taskToCheck);
        }
    }

    /// <summary>
    /// 给定一个节点，从中提取速度节点并在必要时存储它们
    /// </summary>
    /// <param name="taskToCheck">要检查的节点。</param>
    private void GetSpeedNodes(BulletMLTask taskToCheck)
    {
        //检查这个家伙是否有速度节点
        if (taskToCheck?.Node.GetChild(ENodeName.speed) is not SpeedNode spdNode)
            return;

        //检查它是否是序列类型的节点
        if (ENodeType.sequence == spdNode.NodeType)
        {
            //我们需要序列节点吗？
            SequenceSpeedTask ??= new(spdNode, taskToCheck);
        }
        else
        {
            //否则我们需要初始节点吗？
            InitialSpeedTask ??= new(spdNode, taskToCheck);
        }
    }

    #endregion //方法
}
