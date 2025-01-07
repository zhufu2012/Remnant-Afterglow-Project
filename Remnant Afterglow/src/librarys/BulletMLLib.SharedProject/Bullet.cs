using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using BulletMLLib.SharedProject.Nodes;
using BulletMLLib.SharedProject.Tasks;
using Godot;
using Remnant_Afterglow;

namespace BulletMLLib.SharedProject;

/// <summary>
/// 这是外部程序集将与其交互的子弹类。
/// 只需继承此类并重写抽象函数！
/// </summary>
public abstract class Bullet : IBullet
{
    #region 成员变量

    /// <summary>
    /// 子弹的飞行方向。以弧度为单位测量
    /// </summary>
    private float _direction;

    /// <summary>
    /// 描述此子弹的树节点。这些节点在多个子弹之间共享
    /// </summary>
    public BulletMLNode MyNode { get; private set; }

    /// <summary>
    /// 游戏中时间的速度。
    /// 可用于实现慢动作、快进等功能。
    /// </summary>
    /// <value>时间速度。</value>
    public float TimeSpeed { get; set; }

    /// <summary>
    /// 更改此bulletml脚本的大小
    /// 如果你想在一个游戏中重复使用一个脚本但其大小不正确，可以使用此属性来调整大小
    /// </summary>
    /// <value>缩放比例。</value>
    public float Scale { get; set; }

    /// <summary>
    /// 子弹标签名称
    /// </summary>
    public string BulletLabel { get; set; }

    // TODO: 实现任务工厂，我们将要创建大量的小对象

    #endregion //成员变量

    #region 属性

    /// <summary>
    /// 此子弹的加速度
    /// </summary>
    /// <value>加速度，单位为像素/帧^2</value>
    public Vector2 Acceleration { get; set; }

    /// <summary>
    /// 获取或设置速度
    /// </summary>
    /// <value>速度，单位为像素/帧</value>
    public virtual float Speed { get; set; }

    /// <summary>
    /// 定义此子弹行为的任务列表
    /// </summary>
    public List<BulletMLTask> Tasks { get; }

    /// <summary>
    /// 抽象属性，获取或设置此子弹的X位置。
    /// 从左上角开始测量，单位为像素
    /// </summary>
    /// <value>X轴位置。</value>
    public abstract float X { get; set; }

    /// <summary>
    /// 获取或设置Y位置参数
    /// 从左上角开始测量，单位为像素
    /// </summary>
    /// <value>Y轴位置。</value>
    public abstract float Y { get; set; }

    /// <summary>
    /// 获取我的子弹管理器。
    /// </summary>
    /// <value>我的子弹管理器。</value>
    public IBulletManager MyBulletManager { get; }

    /// <summary>
    /// 获取或设置方向。
    /// </summary>
    /// <value>方向（弧度）。</value>
    public virtual float Direction
    {
        get => _direction;
        set => _direction = MathHelper.WrapAngle(value);
    }
    /// <summary>
    /// 当前子弹已经飞行的距离
    /// </summary>
    public float CurrFlyDistance { get; set; }
    /// <summary>
    /// 方便获取子弹标签的属性。
    /// </summary>
    /// <value>标签。</value>
    public string Label => MyNode.Label;

    /// <summary>
    /// 这是子弹发射时的初始速度。
    /// 例如，如果敌人向前移动并发射子弹，则子弹会聚集在一起，因为它们不会保留敌人的速度。
    /// 如果你有快速移动的敌人或枪，并希望子弹模式继承发射它们的对象的速度，请设置此属性。
    /// </summary>
    public Vector2 InitialVelocity { get; } = Vector2.Zero;

    #endregion //属性
    /// <summary>
    /// 创建子弹者
    /// </summary>
    public BaseObject createObject;
    /// <summary>
    /// 攻击目标
    /// </summary>
    public BaseObject targetObject;



    #region 方法

    /// <summary>
    /// 初始化 <see cref="Bullet"/> 类的新实例。
    /// </summary>
    /// <param name="myBulletManager">我的子弹管理器。</param>
    /// <param name="targetObject">目标</param>
    /// <param name="createObject">创建者</param>
    protected Bullet(IBulletManager myBulletManager, BaseObject targetObject, BaseObject createObject)
    {
        this.targetObject = targetObject;
        this.createObject = createObject;
        // 获取此子弹的子弹管理器
        Debug.Assert(null != myBulletManager);
        MyBulletManager = myBulletManager;

        Acceleration = Vector2.Zero;

        Tasks = new();

        // 将这些初始化为默认值
        TimeSpeed = 1.0f;
        Scale = 1.0f;
        CurrFlyDistance = 0f;//飞行的距离
    }

    /// <summary>
    /// 使用顶级节点初始化此子弹
    /// </summary>
    /// <param name="rootNode">这是一个顶级节点... 找到第一个“top”节点并使用它来定义此子弹</param>
    public void InitTopNode(BulletMLNode rootNode, BaseObject baseObject, BaseObject baseObject2)
    {
        Debug.Assert(null != rootNode);

        // 好的，找到标记为 'top' 的项
        var bValidBullet = false;
        var topNode = rootNode.FindLabelNode("top", ENodeName.action);
        if (topNode != null)
        {
            // 使用我们找到的顶部节点进行初始化！
            InitNode(topNode, baseObject, baseObject2);
            bValidBullet = true;
        }
        else
        {
            // 没有 'top' 节点，这意味着我们有一系列 'top#' 节点
            for (var i = 1; i < 10; i++)
            {
                topNode = rootNode.FindLabelNode("top" + i, ENodeName.action);
                if (topNode != null)
                {
                    if (!bValidBullet)
                    {
                        // 使用这个子弹！
                        InitNode(topNode, baseObject, baseObject2);
                        bValidBullet = true;
                    }
                    else
                    {
                        // 创建一个新的子弹
                        var newDude = MyBulletManager.CreateTopBullet(rootNode.Label, baseObject, baseObject2);

                        // 设置新子弹的位置为此子弹的位置
                        newDude.X = X;
                        newDude.Y = Y;

                        // 使用我们找到的节点进行初始化
                        newDude.InitNode(topNode, baseObject, baseObject2);
                    }
                }
            }
        }

        if (!bValidBullet)
        {
            // 我们没有找到此子弹的 "top" 节点，将其从游戏中移除。
            MyBulletManager.RemoveBullet(this);
        }
    }

    /// <summary>
    /// 此子弹由另一个子弹发射，从发射它的节点初始化
    /// </summary>
    /// <param name="subNode">定义此子弹的子节点</param>
    public void InitNode(BulletMLNode subNode, BaseObject baseObject, BaseObject baseObject2)
    {
        Debug.Assert(null != subNode);

        // 清空所有内容
        Tasks.Clear();

        // 获取顶级节点
        MyNode = subNode;

        // 找到了一个顶级编号节点，为其添加一个任务
        var task = new BulletMLTask(subNode, null);

        // 解析节点到任务列表
        task.ParseTasks(this);

        // 初始化所有任务
        task.InitTask(this);

        Tasks.Add(task);

        // 检查是否应更改起始方向和速度以适应初始速度
        if (Vector2.Zero == InitialVelocity)
            return;

        // 现在方向和速度已被设置，根据初始速度进行调整。
        var final = (Direction.ToVector2() * Speed * Scale) + InitialVelocity;
        Direction = final.Angle();
        Speed = final.Length() / Scale;
    }

    /// <summary>
    /// 异步更新方法
    /// </summary>
    /// <returns></returns>
    public Task UpdateAsync()
    {
        // 在不同线程上运行更新方法
        return Task.Factory.StartNew(() =>
        {
            Update();
        });
    }

    /// <summary>
    /// 更新此子弹。在运行期间每秒调用一次
    /// </summary>
    public virtual void Update()
    {
        // 标志位，指示此子弹的所有任务是否已完成
        foreach (var t in Tasks)
        {
            t.Run(this);
        }
        // 仅在此子弹未完成时执行以下操作，因为 sin/cosin 是昂贵的操作
        var vel = (Acceleration + (Direction.ToVector2() * (Speed * TimeSpeed))) * Scale;
        X += vel.X;
        Y += vel.Y;
        CurrFlyDistance += (float)Math.Sqrt(vel.X * vel.X + vel.Y * vel.Y);//飞行距离

    }

    /// <summary>
    /// 此方法在更新方法之后调用
    /// </summary>
    public abstract void PostUpdate();

    /// <summary>
    /// 获取瞄准该子弹的方向
    /// </summary>
    /// <returns>瞄准子弹的角度</returns>
    public virtual float GetAimDir()
    {
        // 获取玩家位置以便瞄准那个家伙
        Debug.Assert(null != MyBulletManager);
        var shipPos = targetObject.GlobalPosition;//祝福注释-看全局对不对

        // 获取我们的位置
        var pos = new Vector2(X, Y);

        // 获取指向他的角度
        return (shipPos - pos).Angle();
    }

    /// <summary>
    /// 根据标签查找任务。
    /// 此方法递归进入子任务以查找具有正确标签的任务
    /// 仅用于单元测试！
    /// </summary>
    /// <returns>具有指定标签的任务。</returns>
    /// <param name="strLabel">任务的字符串标签</param>
    public BulletMLTask FindTaskByLabel(string strLabel)
    {
        // 检查任何子任务是否有具有该标签的任务
        foreach (var childTask in Tasks)
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
    /// 给定标签和名称，查找匹配的任务
    /// </summary>
    /// <returns>具有指定标签和名称的任务。</returns>
    /// <param name="strLabel">任务的字符串标签</param>
    /// <param name="eName">任务应附加到的节点名称</param>
    public BulletMLTask FindTaskByLabelAndName(string strLabel, ENodeName eName)
    {
        // 检查任何子任务是否有具有该标签的任务
        foreach (var childTask in Tasks)
        {
            var foundTask = childTask.FindTaskByLabelAndName(strLabel, eName);
            if (null != foundTask)
            {
                return foundTask;
            }
        }

        return null;
    }

    /// <summary>
    /// 检查此子弹是否已完成所有任务。
    /// </summary>
    /// <returns>布尔值，表示任务是否全部完成。</returns>
    public bool TasksFinished()
    {
        return Tasks.All(t => t.TaskFinished);

        // 所有的任务及其子任务都已完成运行
    }

    #endregion //方法
}