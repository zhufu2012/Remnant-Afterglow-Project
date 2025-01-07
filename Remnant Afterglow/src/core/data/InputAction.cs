
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
    public static readonly StringName Input_Key_A = "cam_a";
    /// <summary>
    /// D键 向右
    /// </summary>
    public static readonly StringName Input_Key_D = "cam_d";
    /// <summary>
    /// W键 向上
    /// </summary>
    public static readonly StringName Input_Key_W = "cam_w";
    /// <summary>
    /// S键 向下
    /// </summary>
    public static readonly StringName Input_Key_S = "cam_s";

    /// <summary>
    /// S键 向下
    /// </summary>
    public static readonly StringName Input_Key_Q = "cam_q";

    /// <summary>
    /// S键 向下
    /// </summary>
    public static readonly StringName Input_Key_E = "cam_e";

    /// <summary>
    /// B键，复制鼠标选中的建筑
    /// </summary>
    public static readonly StringName Input_Key_B = "cam_b";

    /// <summary>
    /// M，按住放大小地图
    /// </summary>
    public static readonly StringName Input_Key_M = "cam_m";

    /// <summary>
    /// Esc键-退出，或者关闭当前已经打开的界面
    /// </summary>
    public static readonly StringName Input_Key_Esc = "Esc";


    /// <summary>
    /// 回车键，对话发送键，对话结束键
    /// </summary>
    public static readonly StringName Input_Key_Enter = "Enter";

    /// <summary>
    /// 空格键，剧情对话时点击进入下一句
    /// </summary>
    public static readonly StringName Input_Key_Space = "Space";
    /// <summary>
    // 按住用于批量建造
    /// </summary>
    public static readonly StringName Input_Key_Shift = "Shift";
    /// <summary>
    /// 点击后进入拆除模式，通知所有玩家拆除的建筑及位置
    /// </summary>
    public static readonly StringName Input_Key_Ctrl = "Ctrl";
}