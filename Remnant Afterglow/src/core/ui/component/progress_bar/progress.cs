using GameLog;
using Godot;
using Godot.Collections;
using Godot.NativeInterop;
using HarmonyLib;
using System;
using System.Threading.Tasks;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 进度条
    /// </summary>
    public partial class RadialProgress : Control
    {

        Label label;//用于显示文字

        /// <summary>
        /// 当前值
        /// </summary>
        public float NowValue { get; set; } = 0f;
        public float MinValue { get; set; } = 0f;
        public float MaxValue { get; set; } = 100.0f;

        /// <summary>
        /// 为0就是不动
        /// </summary>
        public float Progress { get; set; } = 0.0f;
        /// <summary>
        /// 背景颜色
        /// </summary>
        public Color BGColor { get; set; } = new Color(0.5f, 0.5f, 0.5f, 1.0f);
        /// <summary>
        /// 进度条颜色
        /// </summary>
        public Color BarColor { get; set; } = new Color(0.2f, 0.9f, 0.2f, 1.0f);
        /// <summary>
        /// 有多少格
        /// </summary>
        public int NBPoints { get; set; } = 100;
        public RadialProgress()
        {
            label = new Label();
            AddChild(label);
        }
        public RadialProgress(string text)
        {
            label = new Label();
            label.Text = text;
            AddChild(label);
        }
        public override void _Ready()
        {

        }

        public override void _Process(double delta)
        {

        }

    }
}
