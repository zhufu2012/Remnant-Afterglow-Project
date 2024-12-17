using System;
using System.Collections;
using System.Collections.Generic;
using Godot;
using Godot.Collections;
namespace Remnant_Afterglow;

/// <summary>
/// 激光子弹
/// </summary>
public partial class Laser : Area2D, IPoolBullet
{
    #region IPoolBullet
    public event Action OnReclaimEvent;
    public event Action OnLeavePoolEvent;
    /// <summary>
    /// 是否已经回收
    /// </summary>
    public bool IsRecycled { get; set; }
    /// <summary>
    /// 对象唯一标识，哪儿用到了就哪个
    ///  用于在对象池中区分对象类型，可以是资源路径，也可以是配置表id
    ///  或者唯一数据id
    /// </summary>
    public string Logotype { get; set; }
    /// <summary>
    /// 子弹id
    /// </summary>
    public string BulletLabel { get; set; }
    /// <summary>
    /// 子弹状态
    /// </summary>
    public BulletStateEnum State { get; set; } = BulletStateEnum.Normal;
    /// <summary>
    /// 对象池id = 对象类型+ _ + object_id
    /// </summary>
    public string PoolId { get; set; }

    public bool IsDestroyed { get; }
    public virtual void InitData()
    { }
    public virtual void LogicalFinish()
    {
    }
    public void Destroy()
    {
    }
    #endregion

    /// <summary>
    /// 激光默认宽度
    /// </summary>
    public const float LaserDefaultWidth = 3f;
    /// <summary>
    /// 子节点包含的例子特效, 在创建完成后自动播放
    /// </summary>
    public Array<GpuParticles2D> Particles2D { get; set; }

    public CollisionShape2D Collision { get; private set; }
    public Sprite2D LineSprite { get; private set; }
    public RectangleShape2D Shape { get; private set; }

    /// <summary>
    /// 当前激光宽度
    /// </summary>
    public float Width { get; set; }

}
