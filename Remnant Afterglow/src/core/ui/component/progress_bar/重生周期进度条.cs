using Godot;
using System;
namespace Remnant_Afterglow
{
	public partial class 重生周期进度条 : TextureProgressBar
	{
		public int frame = 0;
		/// <summary>
		/// 多少帧增加一次进度
		/// </summary>
		[Export] public int frameCount = 6;
		/// <summary>
		/// 一个周期多少秒
		/// </summary>
		[Export] public int WeekNum = 5;
		/// <summary>
		/// 步长
		/// </summary>
		[Export] public int step = 1;
		/// <summary>
		/// 每帧动画时长
		/// </summary>
		[Export] public int AnimaFrame = 12;
		int tempAnima = 0;

		bool IsAnimaPlay = false;
		public Sprite2D anima;
		public override void _Ready()
		{
			MaxValue = WeekNum * GameConstant.GameFrame / frameCount;
			ValueChanged += OnValueChanged;
			anima = GetNode<Sprite2D>("周期生效效果");
			anima.Visible = false;
		}
		public override void _PhysicsProcess(double delta)
		{
			frame++;
			if (frame >= frameCount)
			{
				frame = 0;
				AddValue();
			}
			if(IsAnimaPlay)//播放状态
			{
				anima.Visible = true;
				tempAnima += 1;
				if(tempAnima>=AnimaFrame)
				{
					tempAnima = 0;
					if (anima.Frame + 1 >= anima.Hframes)
					{
						anima.Visible = false;
						anima.Frame = 0;
						IsAnimaPlay = false;
						tempAnima = 0;
					}
					else
					{
						anima.Frame += 1;
					}
				}

				
			}
		}

		/// <summary>
		/// 进度改变
		/// </summary>
		/// <param name="value"></param>
		private void OnValueChanged(double value)
		{
			if (Value >= MaxValue)
			{
				MapCopy.Instance.mapLogic.RegenerationCycle();//地图 重生周期重置
				IsAnimaPlay = true;
				Value = 0;
			}
		}

		public void AddValue()
		{
			Value += step;
		}

	}
}
