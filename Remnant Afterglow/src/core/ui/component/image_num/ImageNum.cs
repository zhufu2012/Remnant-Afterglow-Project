using GameLog;
using Godot;
using System;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
	public partial class ImageNum : Control
	{
		/// <summary>
		/// 位数
		/// </summary>
		[Export] public int digit = 6;

		/// <summary>
		/// 显示的数字
		/// </summary>
		[Export] public int ShowNum = 0;

		/// <summary>
		/// 资源类型
		/// </summary>
		[Export] public int type = 0;
		/// <summary>
		/// 像素间隔
		/// </summary>
		[Export] public float space = 1;
		/// <summary>
		/// 自身的缩放比例
		/// </summary>
		[Export] public Vector2 SelfScale = new Vector2 (1, 1);
		[Export] public int SelfZIndex = 1000;

		public List<Sprite2D> spriteList = new List<Sprite2D>();

		public override void _Ready()
		{
			float posX = 0;
			for (int i = 0; i < digit; i++)
			{
				Sprite2D sprite2D = new Sprite2D();
				sprite2D.Texture = ImgNumber.imgDict[type];
				sprite2D.Vframes = 1;
				sprite2D.Hframes = 10;
				sprite2D.Position = new Vector2(posX, 0);
				sprite2D.TextureFilter = TextureFilterEnum.Nearest;
				sprite2D.ZIndex = SelfZIndex;
				sprite2D.Scale = SelfScale;
				spriteList.Add(sprite2D);
				AddChild(sprite2D);
				posX += ImgNumber.SizeList[type].X*SelfScale.X +space;
			}
			SetNum(ShowNum);
		}
		/// <summary>
		/// 设置显示的数字
		/// </summary>
		/// <param name="ShowNum"></param>
		public void SetNum(int  ShowNum)
		{
			this.ShowNum = ShowNum;
			string numStr = ShowNum.ToString();
			int start = digit - numStr.Length;
			int index = start;
			foreach (char c in numStr)
			{
				int num = c - '0';
				spriteList[index].Visible = true;
				spriteList[index].Frame = num;
				index++;
			}
			for (int i = 0;i<start;i++)
			{
				spriteList[i].Visible = false;
			}
		}



		public override void _Process(double delta)
		{
		}
	}
}
