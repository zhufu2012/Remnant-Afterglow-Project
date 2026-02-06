using System.Diagnostics;
using BulletMLLib.SharedProject.Nodes;
using Godot;

namespace BulletMLLib.SharedProject.Tasks;

/// <summary>
/// 这个任务给子弹添加加速度。
/// </summary>
public class AccelTask : BulletMLTask
{
    #region 成员变量

    /// <summary>
    /// 运行此任务的持续时间...以帧为单位
    /// </summary>
    public float Duration { get; private set; }

    /// <summary>
    /// 加速度的方向
    /// </summary>
    private Vector2 _acceleration = Vector2.Zero;

    /// <summary>
    /// 获取或设置加速度。
    /// </summary>
    /// <value>加速度。</value>
    public Vector2 Acceleration
    {
        get { return _acceleration; }
        private set { _acceleration = value; }
    }

    #endregion //成员变量

    #region 方法

    /// <summary>
    /// 初始化 <see cref="BulletMLTask"/> 类的新实例。
    /// </summary>
    /// <param name="node">节点。</param>
    /// <param name="owner">所有者。</param>
    public AccelTask(AccelNode node, BulletMLTask owner)
        : base(node, owner)
    {
        Debug.Assert(null != Node);
        Debug.Assert(null != Owner);
    }

    /// <summary>
    /// 设置任务以准备运行。
    /// </summary>
    /// <param name="bullet">子弹。</param>
    protected override void SetupTask(Bullet bullet)
    {
        //设置我们将要添加到子弹上的加速度
        Duration = Node.GetChildValue(ENodeName.term, this, bullet);

        //检查除零错误
        if (0.0f == Duration)
        {
            Duration = 1.0f;
        }

        //获取水平节点
        var horiz = Node.GetChild(ENodeName.horizontal) as HorizontalNode;
        if (null != horiz)
        {
            //设置加速度的x分量
            _acceleration.X = horiz.NodeType switch
            {
                ENodeType.sequence
                    =>
                    //在加速度节点中的序列意味着"每帧添加这个量"
                    horiz.GetValue(this, bullet),
                ENodeType.relative
                    =>
                    //按一定量加速
                    horiz.GetValue(this, bullet) / Duration,
                _ => (horiz.GetValue(this, bullet) - bullet.Acceleration.X) / Duration
            };
        }

        //获取垂直节点
        if (Node.GetChild(ENodeName.vertical) is not VerticalNode vert)
            return;
        //设置加速度的y分量
        _acceleration.Y = vert.NodeType switch
        {
            ENodeType.sequence
                =>
                //在加速度节点中的序列意味着"每帧添加这个量"
                vert.GetValue(this, bullet),
            ENodeType.relative
                =>
                //按一定量加速
                vert.GetValue(this, bullet) / Duration,
            _ => (vert.GetValue(this, bullet) - bullet.Acceleration.Y) / Duration
        };
    }

    /// <summary>
    /// 对子弹运行此任务和所有子任务
    /// 在运行时每帧调用一次。
    /// </summary>
    /// <returns>ERunStatus: 此任务是否完成、暂停或仍在运行</returns>
    /// <param name="bullet">要更新此任务的子弹。</param>
    public override ERunStatus Run(Bullet bullet)
    {
        //给子弹添加加速度
        bullet.Acceleration += Acceleration;

        //减少剩余运行时间，当此任务完成时返回结束状态
        Duration -= 1.0f * bullet.TimeSpeed;
        if (Duration <= 0.0f)
        {
            TaskFinished = true;
            return ERunStatus.End;
        }

        //由于此任务未完成，下次继续运行
        return ERunStatus.Continue;
    }

    #endregion //方法
}