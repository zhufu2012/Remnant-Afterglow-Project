
using Godot;

/// <summary>
/// 输入管理器
/// </summary>
public static class InputManager
{
    /// <summary>
    /// 移动方向, 已经归一化, 键鼠: 键盘WASD
    /// </summary>
    public static Vector2 MoveAxis { get; private set; }

    /// <summary>
    /// 鼠标在SubViewport节点下的坐标, 键鼠: 鼠标移动
    /// </summary>
    public static Vector2 CursorPosition { get; private set; }


    /// <summary>
    /// 更新输入管理器-祝福注释
    /// </summary>
    public static void Update(float delta)
    {
        //移动方向, 已经归一化, 键鼠: 键盘WASD
        MoveAxis = Input.GetVector(InputAction.Input_Key_A, InputAction.Input_Key_D, InputAction.Input_Key_W, InputAction.Input_Key_S);


        //ExchangeWeapon = Input.IsActionJustPressed(InputAction.ExchangeWeapon);
        //ThrowWeapon = Input.IsActionJustPressed(InputAction.ThrowWeapon);
        //Interactive = Input.IsActionJustPressed(InputAction.Interactive);
        //Reload = Input.IsActionJustPressed(InputAction.Reload);
        //Fire = Input.IsActionPressed(InputAction.Fire);
        //MeleeAttack = Input.IsActionJustPressed(InputAction.MeleeAttack);
        //Roll = Input.IsActionJustPressed(InputAction.Roll);
        //UseActiveProp = Input.IsActionJustPressed(InputAction.UseActiveProp);
        //RemoveProp = Input.IsActionJustPressed(InputAction.RemoveProp);
        //ExchangeProp = Input.IsActionJustPressed(InputAction.ExchangeProp);
        //Map = Input.IsActionPressed(InputAction.Map);
    }
}