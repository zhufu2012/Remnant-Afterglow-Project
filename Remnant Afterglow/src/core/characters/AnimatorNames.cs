
using Godot;
namespace Remnant_Afterglow;
/// <summary>
/// 预制动画名称
/// </summary>
public static class AnimatorNames
{
    /// <summary>
    /// 默认动画-播放动画时没有对应动画就播放这个
    /// </summary>
    public static readonly StringName Default = "1";
    /// <summary>
    /// 静止不动
    /// </summary>
    public static readonly StringName Idle = "2";
    /// <summary>
    /// 奔跑
    /// </summary>
    public static readonly StringName Run = "3";

    /// <summary>
    /// 攻击
    /// </summary>
    public static readonly StringName Attack = "attack";

    /// <summary>
    /// 死亡
    /// </summary>
    public static readonly StringName Die = "die";

}