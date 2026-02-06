

using Godot;

namespace Remnant_Afterglow
{
	/// <summary>
	/// 波数刷怪-结算界面
	/// </summary>
	public partial class BrushSettleView : Popup
	{

		/// <summary>
		/// 返回大地图
		/// </summary>
		[Export] public Button RetButton;
		/// <summary>
		/// 任务结算
		/// </summary>
		[Export] public Button SettleButton;
		public override void _Ready()
		{
			RetButton.ButtonDown += () =>
			{
				SceneManager.ChangeSceneBackward(this);
			};

			SettleButton.ButtonDown += () =>
			{
			};
		}
	}
}
