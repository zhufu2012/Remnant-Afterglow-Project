using Godot;
using Godot.Collections;
using System;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
	/// <summary>
	/// 资源进度条
	/// </summary>
	public partial class ResourceProgressBar : Control
	{
		[Export]
		public PackedScene PackedScene;

		/// <summary>
		/// 进度条列表
		/// </summary>
		public List<ResourceBar> progressBarList = new List<ResourceBar>();

		/// <summary>
		/// 活塞图列表
		/// </summary>
		public List<Sprite2D> spriteList = new List<Sprite2D>();

		/// <summary>
		/// 每个进度条代表的资源量
		/// </summary>
		private int unitsPerBar = 100;

		/// <summary>
		/// 总进度条数量
		/// </summary>
		private int totalBars = 0;

		/// <summary>
		/// 当前资源总量
		/// </summary>
		private int totalResource = 0;

		/// <summary>
		/// 当前资源量
		/// </summary>
		private int currentResource = 0;

		/// <summary>
		/// 进度条列表节点
		/// </summary>
		[Export]
		private Control progress;
		/// <summary>
		/// 活塞动画列表节点
		/// </summary>
		[Export]
		private Control player;
		/// <summary>
		/// 进度条位置
		/// </summary>
		[Export]
		private Vector2 barPos = new Vector2(5, 2.5f);
		/// <summary>
		/// 进度条尺寸
		/// </summary>
		[Export]
		private Vector2 barSize = new Vector2(12, 29);
		/// <summary>
		/// 进度条间距
		/// </summary>
		[Export]
		private int barSpacing = 0;
		/// <summary>
		/// 活塞的图
		/// </summary>
		[Export]
		private Texture2D texture;
		/// <summary>
		/// 活塞图位置
		/// </summary>
		[Export]
		private Vector2 texturePos = new Vector2(11, 45f);
		/// <summary>
		/// 活塞图的大小
		/// </summary>
		[Export]
		private Vector2 textureSize = new Vector2(12, 15);
		/// <summary>
		/// 活塞图帧数
		/// </summary>
		[Export]
		private int textureFrame = 7;
		/// <summary>
		/// 活塞图播放速度，每秒多少帧
		/// </summary>
		[Export]
		private int Speed = 60;

		/// <summary>
		/// 进度条九宫格背景1
		/// </summary>
		[Export]
		private NinePatchRect ninePatchRect1;
		/// <summary>
		/// 进度条的背景光条
		/// </summary>
		[Export]
		private TextureRect textureRect;

		[Export]
		private Vector2 ninePatchRectSize = new Vector2(10, 47);
		/// <summary>
		/// 次元岛齿轮动画
		/// </summary>
		[Export]
		private Sprite2D sprite = null;

		private double PlaySpeed = 1;

		public ResourceProgressBar()
		{
		}

		public override void _Ready()
		{
			SetTotalResource(1200);
			SetCurrentResource(100);
		}

		int index_frame = 0;
		double second = 0;
		public override void _PhysicsProcess(double delta)
		{
			second += delta;
			PlaySpeed = 60f / Speed;
			if (second > PlaySpeed)
			{
				index_frame++;
				for (int i = 0; i < progressBarList.Count; i++)
				{
					// 从右到左排列
					int barIndex = progressBarList.Count - 1 - i;
					Sprite2D spr = spriteList[barIndex];
					spr.Frame = (index_frame + i) % textureFrame;
				}
				if (index_frame >= textureFrame)
					index_frame = 0;
				if (sprite.Frame >= sprite.Hframes - 1)
					sprite.Frame = 0;
				else
					sprite.Frame += 1;
				second = 0;
			}
		}

		/// <summary>
		/// 设置资源总量（决定显示多少个进度条）
		/// </summary>
		/// <param name="total">资源总量</param>
		public void SetTotalResource(int total)
		{
			totalResource = total;
			// 计算需要多少个进度条
			int neededBars = (total + unitsPerBar - 1) / unitsPerBar; // 向上取整

			if (progressBarList.Count != neededBars)///不等于就清空
			{
				foreach (Node node in progress.GetChildren())
					node.QueueFree();
				foreach (Node node in player.GetChildren())
					node.QueueFree();
				progressBarList.Clear();
				spriteList.Clear();
			}

			// 如果需要的进度条数量发生变化，则调整进度条数量
			while (progressBarList.Count < neededBars)
			{
				// 创建新的进度条
				ResourceBar bar = (ResourceBar)PackedScene.Instantiate();
				// 设置进度条属性
				bar.MaxValue = unitsPerBar;
				bar.Value = 0;
				bar.Size = barSize;
				// 添加到列表
				progressBarList.Add(bar);
				progress.AddChild(bar);

				Sprite2D sprite2D = new Sprite2D();
				sprite2D.Texture = texture;
				sprite2D.Hframes = 7;
				sprite2D.ZIndex = 101;
				spriteList.Add(sprite2D);
				player.AddChild(sprite2D);
			}

			totalBars = neededBars;

			// 更新进度条位置 和活塞位置
			UpdateProgressBarPositions();

			// 更新当前资源显示
			SetCurrentResource(currentResource);
		}

		/// <summary>
		/// 更新进度条位置（从右到左排列）
		/// </summary>
		private void UpdateProgressBarPositions()
		{
			int Length = progressBarList.Count;
			for (int i = 0; i < Length; i++)
			{
				// 从右到左排列
				int barIndex = Length - 1 - i;
				TextureProgressBar bar = progressBarList[barIndex];
				Sprite2D spr = spriteList[barIndex];

				// 计算位置
				float xPos = (barSize.X + barSpacing) * i;
				bar.Position = barPos + new Vector2(xPos, 0);
				float xPos2 = (textureSize.X + barSpacing) * i;
				spr.Position = texturePos + new Vector2(xPos2, 0);
			}
			ninePatchRect1.Size = new Vector2(ninePatchRectSize.X + barSize.X * Length, ninePatchRectSize.Y);
			textureRect.Size = new Vector2(6 + barSize.X * Length, 35);
			sprite.Position = new Vector2(barSize.X * Length + 14, sprite.Position.Y);
		}

		/// <summary>
		/// 设置当前资源量
		/// </summary>
		/// <param name="current">当前资源量</param>
		public void SetCurrentResource(int current)
		{
			this.currentResource = Math.Min(current, totalResource);

			// 计算每个进度条的值
			for (int i = 0; i < progressBarList.Count; i++)
			{
				int barIndex = progressBarList.Count - 1 - i; // 从右到左
				TextureProgressBar bar = progressBarList[barIndex];

				int startValue = i * unitsPerBar;
				int endValue = (i + 1) * unitsPerBar;

				if (currentResource >= endValue)
				{
					bar.Value = unitsPerBar;
				}
				else if (currentResource > startValue)
				{
					bar.Value = currentResource - startValue;
				}
				else
				{
					bar.Value = 0;
				}

				// 设置进度条可见性
				bar.Visible = i < totalBars;
			}
		}

		// 可选：设置进度条尺寸的方法
		public void SetBarSize(Vector2 size)
		{
			barSize = size;
			foreach (var bar in progressBarList)
			{
				bar.Size = barSize;
			}
			UpdateProgressBarPositions();
		}

		// 可选：设置进度条间距的方法
		public void SetBarSpacing(int spacing)
		{
			barSpacing = spacing;
			UpdateProgressBarPositions();
		}
	}
}
