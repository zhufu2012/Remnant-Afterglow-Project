
using Godot;

/// <summary>
/// 输入事件名称
/// </summary>
public static class InputAction
{
    /// <summary>
    /// 鼠标左键
    /// </summary>
    public static readonly StringName MouseLeft = "left_click";
    /// <summary>
    /// 鼠标右键
    /// </summary>
    public static readonly StringName MouseRight = "right_click";
    /// <summary>
    /// 鼠标中键
    /// </summary>
    public static readonly StringName mouseMiddle = "middle_click";
    /// <summary>
    /// A键 向左
    /// </summary>
    public static readonly StringName MoveLeft = "cam_a";
    /// <summary>
    /// D键 向右
    /// </summary>
    public static readonly StringName MoveRight = "cam_d";
    /// <summary>
    /// W键 向上
    /// </summary>
    public static readonly StringName MoveUp = "cam_w";
    /// <summary>
    /// S键 向下
    /// </summary>
    public static readonly StringName MoveDown = "cam_s";
    /// <summary>
    /// Esc键-退出，或者关闭当前已经打开的界面
    /// </summary>
    public static readonly StringName Esc = "Esc";



    public static readonly StringName ExchangeWeapon = "exchangeWeapon";
    public static readonly StringName ThrowWeapon = "throwWeapon";
    public static readonly StringName Interactive = "interactive";
    public static readonly StringName Reload = "reload";
    public static readonly StringName Fire = "fire";
    public static readonly StringName MeleeAttack = "meleeAttack";
    public static readonly StringName Roll = "roll";
    public static readonly StringName UseActiveProp = "useActiveProp";
    public static readonly StringName ExchangeProp = "exchangeProp";
    public static readonly StringName RemoveProp = "removeProp";
    public static readonly StringName Map = "map";
}