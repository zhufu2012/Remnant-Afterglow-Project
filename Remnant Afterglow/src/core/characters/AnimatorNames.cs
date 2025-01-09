using Godot;
namespace Remnant_Afterglow;
/// <summary>
/// 预制动画名称
///1 默认动画
///2 移动动画
///3 攻击动画
///4 装填动画
///5 工作动画
///6 子弹命中
///7 子弹消失
///10 死亡动画
/// </summary>
public static class AnimatorNames
{
    /// <summary>
    /// 默认动画-播放动画时没有对应动画就播放这个
    /// </summary>
    public static readonly StringName Default = "1";
    /// <summary>
    /// 移动动画
    /// </summary>
    public static readonly StringName Run = "2";
    /// <summary>
    /// 攻击动画
    /// </summary>
    public static readonly StringName Attack = "3";

    /// <summary>
    /// 装填动画
    /// </summary>
    public static readonly StringName Attack = "3";

    /// <summary>
    /// 攻击动画
    /// </summary>
    public static readonly StringName Fill = "4";

    /// <summary>
    /// 工作动画
    /// </summary>
    public static readonly StringName Worker = "5";

    /// <summary>
    /// 死亡动画，死亡时播放，播放完之后就死
    /// </summary>
    public static readonly StringName Die = "10";

}