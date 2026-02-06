using GameLog;
using Godot;
using Remnant_Afterglow_EditMap;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
	public partial class MapHelpControl : Control
	{
		/// <summary>
		/// 当前帧数
		/// </summary>
		int frame = 0;

		Vector2 gridSize;
		Rect2 rect;

		/// <summary>
		/// 绘制辅助线颜色
		/// </summary>
		[Export] Color DrawColor = new Color(0.5f, 0.5f, 0.5f, 0.8f);
		/// <summary>
		/// 格子文字颜色
		/// </summary>
		[Export] Color TextColor = new Color(0.5f, 0.5f, 0.5f, 0.8f);
		/// <summary>
		/// 笔刷预览线宽度
		/// </summary>
		[Export] int Line_Width = 3;
		/// <summary>
		/// 多少帧绘制一次
		/// </summary>
		[Export] int frame_count = 2;

		/// <summary>
		/// 计算开始和结束坐标
		/// </summary>
		int startX;
		int startY;
		int endX;
		int endY;

		int Width;
		int Height;
		public void InitData()
		{
			gridSize = EditMapView.Instance.tileMap.TileSet.TileSize;
			rect = new Rect2(0, 0, new Vector2(EditMapView.Instance.tileMap.drawData.Width * MapConstant.TileCellSize, EditMapView.Instance.tileMap.drawData.Height * MapConstant.TileCellSize));
			// 计算开始和结束坐标
			startX = (int)(Mathf.FloorToInt(rect.Position.X / gridSize.X) * gridSize.X);
			startY = (int)(Mathf.FloorToInt(rect.Position.Y / gridSize.Y) * gridSize.Y);
			endX = (int)(Mathf.CeilToInt((rect.Position.X + rect.Size.X) / gridSize.X) * gridSize.X);
			endY = (int)(Mathf.CeilToInt((rect.Position.Y + rect.Size.Y) / gridSize.Y) * gridSize.Y);
			Width = EditMapView.Instance.tileMap.drawData.Width;
			Height = EditMapView.Instance.tileMap.drawData.Height;
			Size = new Vector2(endX, endY);
		}


		public override void _Draw()
		{
			DrawBrush();
			DrawGuides();
		}

		public override void _Process(double delta)
		{
			frame++;
			if (frame >= frame_count)
			{
				QueueRedraw();
				frame = 0;
			}
		}


		/// <summary>
		/// 绘制笔刷
		/// </summary>
		public void DrawBrush()
		{
			switch (EditMapView.Instance.tileMap.MouseType)
			{
				case MouseButtonType.Brush:
					int cellSize = MapConstant.TileCellSize;
					Vector2 _mousePosition = EditMapView.Instance.tileMap._mousePosition;
					Vector2I position = EditMapView.Instance.tileMap._mouseCellPosition;
					// 获取笔刷大小
					int brushType = EditMapView.Instance.toolContainer.GetBrushType();

					// 计算笔刷的左上角和右下角

					Color color = new Color(1, 1, 1, 1); // RGBA: 白色，不透明
					switch (brushType)
					{
						case 1://圆形笔刷
							   // 计算笔刷的范围
							   //* cellSize
							int radius = EditMapView.Instance.toolContainer.brushSize / 2;// 实际像素半径
							Vector2 start1 = new Vector2(position.X - radius, position.Y - radius);
							Vector2 end1 = new Vector2(position.X + radius, position.Y + radius);
							HashSet<Vector2I> tilesInCircle = new HashSet<Vector2I>();
							for (int x = (int)start1.X; x <= end1.X; x++)
							{
								for (int y = (int)start1.Y; y <= end1.Y; y++)
								{
									Vector2 currentPos = new Vector2(x, y);
									float distance = currentPos.DistanceTo(position);
									if (distance <= radius)
									{
										tilesInCircle.Add(new Vector2I(x, y));
									}
								}
							}
							// 绘制每个瓦片的边缘
							foreach (Vector2I tile in tilesInCircle)
							{
								int x = tile.X;
								int y = tile.Y;

								// 检查四个方向邻居是否存在
								bool hasRight = tilesInCircle.Contains(new Vector2I(x + 1, y));
								bool hasLeft = tilesInCircle.Contains(new Vector2I(x - 1, y));
								bool hasTop = tilesInCircle.Contains(new Vector2I(x, y - 1));
								bool hasBottom = tilesInCircle.Contains(new Vector2I(x, y + 1));

								// 计算瓦片边界坐标
								float left = x * cellSize;
								float right = (x + 1) * cellSize;
								float top = y * cellSize;
								float bottom = (y + 1) * cellSize;

								// 绘制缺失邻居的边
								if (!hasRight) DrawLine(new Vector2(right, top), new Vector2(right, bottom), color, Line_Width);
								if (!hasLeft) DrawLine(new Vector2(left, top), new Vector2(left, bottom), color, Line_Width);
								if (!hasTop) DrawLine(new Vector2(left, top), new Vector2(right, top), color, Line_Width);
								if (!hasBottom) DrawLine(new Vector2(left, bottom), new Vector2(right, bottom), color, Line_Width);
							}
							break;
						case 2:
							// 计算笔刷的半径
							float halfBrushSize = EditMapView.Instance.toolContainer.brushSize / 2 * cellSize;
							Vector2 start = _mousePosition - new Vector2(halfBrushSize, halfBrushSize) + new Vector2(cellSize / 2, cellSize / 2);
							Vector2 end = _mousePosition + new Vector2(halfBrushSize, halfBrushSize) + new Vector2(cellSize / 2, cellSize / 2);
							// 绘制正方形笔刷的边界
							DrawLine(new Vector2(start.X, start.Y), new Vector2(end.X, start.Y), color, Line_Width); // 上边
							DrawLine(new Vector2(end.X, start.Y), new Vector2(end.X, end.Y), color, Line_Width);     // 右边
							DrawLine(new Vector2(end.X, end.Y), new Vector2(start.X, end.Y), color, Line_Width);     // 下边
							DrawLine(new Vector2(start.X, end.Y), new Vector2(start.X, start.Y), color, Line_Width); // 左边
							break;
						default:
							break;
					}
					break;
				default:
					break;
			}
		}


		/// <summary>
		/// 绘制辅助线
		/// </summary>
		public void DrawGuides()
		{
			if (EditMapView.Instance.toolContainer.IsLine)
			{
				// 绘制垂直线
				for (float x = startX; x <= endX; x += gridSize.X)
				{
					DrawLine(new Vector2(x, rect.Position.Y), new Vector2(x, rect.Position.Y + rect.Size.Y), DrawColor);
				}

				// 绘制水平线
				for (float y = startY; y <= endY; y += gridSize.Y)
				{
					DrawLine(new Vector2(rect.Position.X, y), new Vector2(rect.Position.X + rect.Size.X, y), DrawColor);
				}
			}
			if (EditMapView.Instance.toolContainer.IsPos)
			{
				// 绘制格子坐标
				for (int gridY = 0; gridY < Height; gridY++)
				{
					for (int gridX = 0; gridX < Width; gridX++)
					{
						// 计算格子中心位置
						Vector2 centerPosition = new Vector2(
							rect.Position.X + (gridX + 0.2f) * gridSize.X,
							rect.Position.Y + (gridY + 0.7f) * gridSize.Y
						);
						// 绘制文本
						DrawString(ThemeDB.FallbackFont, centerPosition, $"{gridX} {gridY}", HorizontalAlignment.Left, -1, 10, TextColor);
					}
				}
			}
		}

	}
}
