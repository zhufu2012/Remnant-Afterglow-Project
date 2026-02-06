using GameLog;
using Godot;
using System.Collections.Generic;
using System.Linq;

namespace Remnant_Afterglow
{
	/// <summary>
	/// 科技树界面
	/// </summary>
	public partial class ScienceTreeView : Control
	{

		/// <summary>
		/// 科技范围 选项
		/// </summary>
		VBoxContainer _vBoxContainer = new VBoxContainer();
		public Panel panel = new Panel();
		/// <summary>
		/// 科技树显示界面
		/// </summary>
		Panel treePanel = new Panel();
		/// <summary>
		/// 科技介绍界面
		/// </summary>
		Panel showPanel = new Panel();

		/// <summary>
		/// 科技范围
		/// </summary>
		public Dictionary<int, ScienceRange> RangeDict = new();
		/// <summary>
		/// 当前显示的科技树界面
		/// </summary>
		public int ShowPanelIndex;
		/// <summary>
		/// 显示的科技范围
		/// </summary>
		public ScienceRange ShowscienceRange;

		/// <summary>
		/// 科技基础<科技范围id，科技基础配置 列表>
		/// </summary>
		public Dictionary<int, List<ScienceBase>> scienceBaseDict = new();

		/// <summary>
		/// 科技基础<科技范围id，科技激活配置 列表>
		/// </summary>
		public Dictionary<int, List<ScienceData>> scienceDataDict = new();

		public ScienceTreeView()
		{
			foreach (ScienceRange range in ConfigCache.GetAllScienceRange())
			{
				RangeDict[range.ScienceRangeId] = range;
			}
			List<ScienceBase> list = ConfigCache.GetAllScienceBase();
			List<ScienceData> list2 = ConfigCache.GetAllScienceData();
			if (list.Count != list2.Count)
			{
				Log.Error("错误！科技树cfg_ScienceBase配置数量与cfg_ScienceData配置数量不同！");
			}
			foreach (ScienceRange range in RangeDict.Values)
			{
				scienceBaseDict[range.ScienceRangeId] = new List<ScienceBase>();
				scienceDataDict[range.ScienceRangeId] = new List<ScienceData>();
			}
			for (int i = 0; i < list.Count; i++)
			{
				ScienceBase item = list[i];
				ScienceData item2 = list2[i];
				if (RangeDict.ContainsKey(item.ScienceRangeId))
				{
					if (scienceBaseDict.ContainsKey(item.ScienceRangeId))
						scienceBaseDict[item.ScienceRangeId].Add(item);
					else
					{
						List<ScienceBase> newlist = new List<ScienceBase>();
						newlist.Add(item);
						scienceBaseDict[item.ScienceRangeId] = newlist;
					}
					if (scienceDataDict.ContainsKey(item.ScienceRangeId))
						scienceDataDict[item.ScienceRangeId].Add(item2);
					else
					{
						List<ScienceData> newlist2 = new List<ScienceData>();
						newlist2.Add(item2);
						scienceDataDict[item.ScienceRangeId] = newlist2;
					}
				}
			}
		}

		public override void _Ready()
		{
			foreach (ScienceRange range in RangeDict.Values)///初始化科技范围按钮
			{
				Button button = new Button();
				button.Name = range.ScienceRangeName;
				button.Text = range.ScienceRangeName;
				button.ButtonDown += () =>
				{
					// 清理旧的子节点
					foreach (Node child in treePanel.GetChildren())
					{
						if (child is ScienceTreeControl control)
						{
							control.QueueFree(); // 正确释放资源
						}
						else
						{
							treePanel.RemoveChild(child);
						}
					}
					ScienceTreeControl container = new ScienceTreeControl(range, scienceBaseDict[range.ScienceRangeId]);
					container.Name = range.ScienceRangeName;
					container.SetAnchorsPreset(LayoutPreset.FullRect);
					treePanel.AddChild(container);

				};
				_vBoxContainer.AddChild(button);
			}
			_vBoxContainer.Position = new Vector2(-247, -10);     // 左侧科技分类容器位置：X=0, Y=68
			_vBoxContainer.Size = new Vector2(230, 660);      // 左侧科技分类容器尺寸：宽190，高580
			
			treePanel.Position = new Vector2(30, -10);         // 中间科技树显示面板位置：X=200, Y=0
			treePanel.Size = new Vector2(800, 660);           // 中间科技树显示面板尺寸：宽720，高648
			
			showPanel.Position = new Vector2(880, -10);         // 右侧科技介绍面板位置：X=930, Y=0
			showPanel.Size = new Vector2(500, 660);           // 右侧科技介绍面板尺寸：宽222，高648


			if (RangeDict.Count >= 1)
			{
				ShowscienceRange = RangeDict.Values.First<ScienceRange>();//默认选择第1个
				ScienceTreeControl container = new ScienceTreeControl(ShowscienceRange, scienceBaseDict[ShowscienceRange.ScienceRangeId]);
				container.Name = ShowscienceRange.ScienceRangeName;
				container.SetAnchorsPreset(LayoutPreset.FullRect);
				treePanel.AddChild(container);
			}
			panel.AddChild(_vBoxContainer);
			panel.AddChild(treePanel);
			panel.AddChild(showPanel);
			AddChild(panel);
		}

	}
}
