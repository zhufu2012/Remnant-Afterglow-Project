using Godot;
using Remnant_Afterglow_EditMap;
/// <summary>
/// 模板导入控件
/// </summary>
public partial class TempSelectPanel : Control
{
	/// <summary>
	/// 是否启用模板导入
	/// </summary>
	public CheckButton checkButton;

	/// <summary>
	/// 选择的模板
	/// </summary>
	public OptionButton tempOption;

	
	public override void _Ready()
	{
		checkButton = GetNode<CheckButton>("Panel/CheckButton");
		checkButton.Toggled += (bool toggledOn)=> 
		{ 
			if(toggledOn)//如果开启
			{
				EditMapView.Instance.toolContainer.CheckClear();//清除笔刷选择
				EditMapView.Instance.tileMap.MouseType = MouseButtonType.ImportMap;
			}
			else//如果关闭
			{
				EditMapView.Instance.tileMap.MouseType = MouseButtonType.Pen;
			}
		};
		tempOption = GetNode<OptionButton>("Panel/OptionButton");
	}


	public override void _Process(double delta)
	{
	}
}
