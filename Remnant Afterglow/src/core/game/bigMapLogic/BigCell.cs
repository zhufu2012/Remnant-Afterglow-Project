using Godot;

namespace Remnant_Afterglow
{
	public partial class BigCell : Control
	{
		public int index;//材料序号
		/// <summary>
		/// 位置
		/// </summary>
		public Vector2I pos;
		public Label label;

		public BigMapMaterial bigcellMaterial;
		public bool IsCopy = false;
		/// <summary>
		/// 关卡基础配置
		/// </summary>
		public ChapterCopyBase chapterCopy = null;

		public BigCell(int index, Vector2I pos)
		{
			this.index = index;
			this.pos = pos;
		}
		public BigCell(int index, Vector2I pos, ChapterCopyBase chapterCopy)
		{
			this.index = index;
			this.pos = pos;
			this.chapterCopy = chapterCopy;
			IsCopy = true;
			
		}

		public void InitData()
		{
			bigcellMaterial = new BigMapMaterial(index);
			label = new Label();
			label.Text = "cell_x:" + pos.X + ",cell_y:" + pos.Y;
			AddChild(label);
		}


	}
}
