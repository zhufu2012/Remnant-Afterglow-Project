using Godot;
using System.Collections.Generic;
namespace Project_Core_Test
{
	public partial class MultiMeshTest : MultiMeshInstance2D
	{

		public override void _Ready()
		{


		}

		int index = 0;
		int indexX = 0;
		int indexY = 0;
		public override void _Process(double delta)
		{
			CreateBullet(index, new Vector2I(indexX, indexX));
			if (index >= 3000)
			{
				foreach (var item in dict)
				{
					dict[item.Key].QueueFree();
				}
				dict.Clear();
				index = 0;
			}

			if (indexX >= 1600)
			{
				indexX = 0;
			}
			if (indexY >= 800)
			{
				indexY = 0;
			}
			index++;
			indexX++;
			indexY++;
		}

		Dictionary<int, Sprite2D> dict = new Dictionary<int, Sprite2D>();
		public void CreateBullet(int index, Vector2I pos)
		{
			Sprite2D node2D = new Sprite2D();
			node2D.Position = pos;
			node2D.Texture = GD.Load<Texture2D>("res://data/config/images/ID_3B8EAE66BAEA4426B59F0AEE51C3CFD4.png");
			AddChild(node2D);
			dict[index] = node2D;
		}



	}
}
