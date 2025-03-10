using System;
using System.Diagnostics;
using BulletMLLib.SharedProject.Nodes;

namespace BulletMLLib.SharedProject.Tasks;

/// <summary>
/// This task changes the direction a little bit every frame
/// </summary>
public class ChangeDirectionTask : BulletMLTask
{
    #region Members
    /// <summary>
    /// The amount pulled out of the node
    /// </summary>
    private float NodeDirection;

    /// <summary>
    /// the type of direction change, pulled out of the node
    /// </summary>
    private ENodeType ChangeType;

    /// <summary>
    /// How long to run this task... measured in frames
    /// </summary>
    private float Duration { get; set; }

    /// <summary>
    /// How many frames this dude has ran
    /// </summary>
    private float RunDelta { get; set; }
    #endregion //Members

    #region Methods
    /// <summary>
    /// Initializes a new instance of the <see cref="BulletMLTask"/> class.
    /// </summary>
    /// <param name="node">Node.</param>
    /// <param name="owner">Owner.</param>
    public ChangeDirectionTask(ChangeDirectionNode node, BulletMLTask owner)
        : base(node, owner)
    {
        Debug.Assert(null != Node);
        Debug.Assert(null != Owner);
    }

    /// <summary>
    /// this sets up the task to be run.
    /// </summary>
    /// <param name="bullet">Bullet.</param>
    protected override void SetupTask(Bullet bullet)
    {
        RunDelta = 0;

        //set the time length to run this dude
        Duration = Node.GetChildValue(ENodeName.term, this, bullet);

        //check for divide by 0
        if (Duration == 0.0f)
        {
            Duration = 1.0f;
        }

        //Get the amount to change direction from the nodes
        var dirNode = Node.GetChild(ENodeName.direction) as DirectionNode;
        NodeDirection = dirNode.GetValue(this, bullet) * (float)Math.PI / 180.0f; //also make sure to convert to radians

        //How do we want to change direction?
        ChangeType = dirNode.NodeType;
    }

    private float GetDirection(Bullet bullet)
    {
        //How do we want to change direction?
        var direction = ChangeType switch
        {
            ENodeType.sequence
                =>
                //我们将在每一帧把这个量加到方向上
                NodeDirection,
            ENodeType.absolute
                =>
                //We are going to go in the direction we are given, regardless of where we are pointing right now
                NodeDirection - bullet.Direction,
            ENodeType.relative
                =>
                //方向的改变将是相对于我们当前的方向
                NodeDirection,
            _ => (NodeDirection + bullet.GetAimDir()) - bullet.Direction
        };

        //保持方向在-180°和180°之间
        direction = MathHelper.WrapAngle(direction);

        //改变方向的序列类型不受持续时间的影响
        if (ChangeType == ENodeType.absolute)
        {
            //divide by the amount fo time remaining
            direction /= Duration - RunDelta;
        }
        else if (ChangeType != ENodeType.sequence)
        {
            //Divide by the duration so we ease into the direction change
            direction /= Duration;
        }

        return direction;
    }

    public override ERunStatus Run(Bullet bullet)
    {
        //将项目子弹的方向改变正确的量
        bullet.Direction += GetDirection(bullet);

        //decrement the amount if time left to run and return End when this task is finished
        RunDelta += 1.0f * bullet.TimeSpeed;
        if (!(Duration <= RunDelta))
            return ERunStatus.Continue;

        TaskFinished = true;
        return ERunStatus.End;

        //since this task isn't finished, run it again next time
    }
    #endregion //Methods
}