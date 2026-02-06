using Godot;
namespace Remnant_Afterglow
{
	/// <summary>
	/// 操作界面
	/// </summary>
	public partial class MapOpView : Control
	{

		public static MapOpView Instance;
		public MapOpView()
		{
			Instance = this;
		}

		public override void _Ready()
		{
			InitView();
		}
	}
}
