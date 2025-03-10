using GameLog;
using Godot;
using Remnant_Afterglow_EditMap;
using System;

public partial class ToolContainer : GridContainer
{
    public CheckButton checkButton_Line;
    public CheckButton checkButton_Pos;
    /// <summary>
    /// 是否绘制辅助线
    /// </summary>
    public bool IsLine = true;
    /// <summary>
    /// 是否绘制位置
    /// </summary>
    public bool IsPos = false;

    public ButtonGroup buttonGroup = new ButtonGroup();
    public CheckBox checkBox1;
    public CheckBox checkBox2;
    [Export]
    public int brushSize = 5;
    public LineEdit lineEdit;


    public override void _Ready()
    {
        checkButton_Line = GetNode<CheckButton>("CheckButton_Line");
        checkButton_Pos = GetNode<CheckButton>("CheckButton_Pos");
        checkBox1 = GetNode<CheckBox>("CheckBox");
        buttonGroup.AllowUnpress = true;
        checkBox1.ButtonGroup = buttonGroup;
        checkBox1.Toggled += (bool toggled_on) =>
        {
            if (toggled_on)
            {
                EditMapView.Instance.tileMap.MouseType = MouseButtonType.Brush;
            }
        };
        checkBox2 = GetNode<CheckBox>("CheckBox2");
        checkBox2.ButtonGroup = buttonGroup;
        checkBox2.Toggled += (bool toggled_on) =>
        {//按钮状态被切换
            if (toggled_on)
            {
                EditMapView.Instance.tileMap.MouseType = MouseButtonType.Brush;
            }
        };

        lineEdit = GetNode<LineEdit>("LineEdit");
        lineEdit.Text = "" + brushSize;
        checkButton_Line.ButtonPressed = IsLine;
        checkButton_Line.Toggled += (bool toggled_on) =>
        {//按钮状态被切换
            IsLine = toggled_on;
        };
        checkButton_Pos.ButtonPressed = IsPos;
        checkButton_Pos.Toggled += (bool toggled_on) =>
        {//按钮状态被切换
            IsPos = toggled_on;
        };
    }

    public void AddBrushSize(int value)
    {
        int newSize = brushSize + value;
        if (newSize > 0)
        {
            brushSize = newSize;
            lineEdit.Text = "" + brushSize;
        }
    }

    public void SubBrushSize(int value)
    {
        int newSize = brushSize - value;
        if (newSize > 0)
        {
            brushSize = newSize;
            lineEdit.Text = "" + brushSize;
        }
    }

    /// <summary>
    /// 是否有使用笔刷
    /// </summary>
    /// <returns></returns>
    public bool IsBrush()
    {
        return checkBox1.ButtonPressed || checkBox2.ButtonPressed;
    }

    /// <summary>
    /// 获取笔刷类型
    /// </summary>
    /// <returns></returns>
    public int GetBrushType()
    {
        if (checkBox1.ButtonPressed)
            return 1;
        if (checkBox2.ButtonPressed)
            return 2;
        return 0;
    }

    /// <summary>
    /// 清除笔刷选择
    /// </summary>
    public void CheckClear()
    {
        checkBox1.ButtonPressed = false;
        checkBox2.ButtonPressed = false;
    }

}
