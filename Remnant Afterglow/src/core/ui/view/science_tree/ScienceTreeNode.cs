using GameLog;
using Godot;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
	/// <summary>
	/// 网格节点-祝福注释节点还得改成场景加载然后代码生存
	/// </summary>
	public partial class ScienceTreeNode : Control
	{
		/// <summary>
		/// 科技范围
		/// </summary>
		public ScienceRange range;
		/// <summary>
		/// 科技显示配置
		/// </summary>
		public ScienceBase scienceBase;

		[Export] public Panel panel;
		[Export] public Button button;
		/// <summary>
		/// 子节点列表
		/// </summary>
		public List<TreeNode> Children = new List<TreeNode>();
		/// <summary>
		/// 是否显示为科技节点
		/// </summary>
		public bool isShow = false;

		/// <summary>
		/// 节点位置
		/// </summary>
		public Vector2I Pos;


		public void IniData(TreeNode node)
		{
			range = node.range;
			scienceBase = node.scienceBase;
			Pos = node.Pos;
			isShow = node.isShow;
		}

		public override void _Ready()
		{
			ZIndex = 1;
			panel.SetAnchorsPreset(LayoutPreset.FullRect);
			button.Text = Pos.ToString();
			button.Size = range.NodeSize;
		}
	}
}
