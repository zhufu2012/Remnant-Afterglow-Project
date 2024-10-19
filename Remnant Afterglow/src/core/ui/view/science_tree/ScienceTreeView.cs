

using GameLog;
using Godot;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 科技树界面
    /// </summary>
    public partial class ScienceTreeView : ViewObject
    {

        /// <summary>
        /// 科技范围 选项
        /// </summary>
        VBoxContainer _vBoxContainer = new VBoxContainer();
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
        public List<ScienceRange> scienceRanges;
        /// <summary>
        /// 当前显示的科技树界面
        /// </summary>
        public int ShowPanelIndex;
        /// <summary>
        /// 显示的科技范围
        /// </summary>
        public ScienceRange ShowscienceRange;

        /// <summary>
        /// 科技基础<科技范围id，科技基础配置>
        /// </summary>
        public Dictionary<int, List<ScienceBase>> scienceBaseDict = new Dictionary<int, List<ScienceBase>>();

        /// <summary>
        /// 科技基础<科技范围id，科技激活配置>
        /// </summary>
        public Dictionary<int, List<ScienceData>> scienceDataDict = new Dictionary<int, List<ScienceData>>();

        public ScienceTreeView(int cfgId) : base(cfgId)
        {
            scienceRanges = ConfigCache.GetAllScienceRange();
            List<ScienceBase> list = ConfigCache.GetAllScienceBase();
            List<ScienceData> list2 = ConfigCache.GetAllScienceData();
            if (list.Count != list2.Count)
            {
                Log.Error("错误！科技树cfg_ScienceBase配置数量与cfg_ScienceData配置不同！");
            }
            for (int i = 0; i < list.Count; i++)
            {
                ScienceBase item = list[i];
                ScienceData item2 = list2[i];
                if (scienceRanges.Find(x => item.ScienceRangeId == x.ScienceRangeId) != null)
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
            foreach (ScienceRange range in scienceRanges)///初始化科技范围按钮
            {
                Button button = new Button();
                button.Name = range.ScienceRangeName;
                button.Text = range.ScienceRangeName;
                button.ButtonDown += () =>
                {
                    foreach(Node child in  treePanel.GetChildren())
                    {
                        treePanel.RemoveChild(child);
                    }
                    ScienceTreeControl container = new ScienceTreeControl(range, scienceBaseDict[range.ScienceRangeId]);
                    container.Name = range.ScienceRangeName;
                    container.SetAnchorsPreset(LayoutPreset.FullRect);
                    treePanel.AddChild(container);

                };
                _vBoxContainer.AddChild(button);
            }
            _vBoxContainer.Position = new Vector2(0, 68);
            _vBoxContainer.Size = new Vector2(190, 580);


            treePanel.Position = new Vector2(200, 0);
            treePanel.Size = new Vector2(720, 648);
            showPanel.Position = new Vector2(930, 0);
            showPanel.Size = new Vector2(222, 648);


            if (scienceRanges.Count >= 1)
            {
                ShowscienceRange = scienceRanges[0];//默认选择第1个
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
