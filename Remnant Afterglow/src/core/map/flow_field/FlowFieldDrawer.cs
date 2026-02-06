using Godot;

namespace Remnant_Afterglow
{
	public partial class FlowFieldDrawer : Node2D
	{
		// 常量预计算
		private static readonly float ArrowHeadAngle = Mathf.DegToRad(150);
		private static readonly float ArrowHeadLengthMultiplier = 0.4f;
		private static readonly Vector2 HalfVector = new Vector2(0.5f, 0.5f);

		// 配置参数
		private float _arrowLength = 8.0f;
		private Color _arrowColor = Colors.White;
		private int _redrawInterval = 60; // 重绘间隔帧数

		// 缓存变量
		private FlowField _cachedFlowField;
		private Vector2 _cachedTileCenterOffset;
		private int _tileSize;

		private int index = 0;
		public override void _Ready()
		{
			_tileSize = MapConstant.TileCellSize;
			_cachedTileCenterOffset = new Vector2(_tileSize, _tileSize) * 0.5f;
		}

		public override void _PhysicsProcess(double delta)
		{
			if (++index % _redrawInterval == 0)
			{
				index = 0;
				QueueRedraw();
			}
		}

		public override void _Draw()
		{
			var currentFlowField = FlowFieldSystem.Instance.ShowFlowField;
			if (currentFlowField == null) return;

			// 使用缓存减少属性访问
			int width = FlowFieldSystem.Instance.Width;
			int height = FlowFieldSystem.Instance.Height;
			Vector2I targetPos = currentFlowField.targetPos;
			Vector2 targetCenter = targetPos * _tileSize + _cachedTileCenterOffset;

			// 批量绘制准备
			var arrowLines = new Vector2[width * height * 6]; // 每个箭头3条线
			int lineIndex = 0;

			// 预计算公共值
			float radius = _tileSize * 0.5f;
			float headLength = _arrowLength * ArrowHeadLengthMultiplier;

			for (int x = 0; x < width; x++)
			{
				for (int y = 0; y < height; y++)
				{
					Vector2I position = new Vector2I(x, y);
					if (position == targetPos)
					{
						DrawCircle(targetCenter, radius, Colors.White);
						continue;
					}

					Vector2 direction = currentFlowField.nodeData[x, y].direction;
					if (direction == Vector2.Zero) continue;

					// 计算箭头基点
					Vector2 startPos = new Vector2(x * _tileSize, y * _tileSize) + _cachedTileCenterOffset;
					Vector2 endPos = startPos + direction * _arrowLength;

					// 存储主线段
					arrowLines[lineIndex++] = startPos;
					arrowLines[lineIndex++] = endPos;
					// 计算箭头边角
					Vector2 right = direction.Rotated(ArrowHeadAngle) * headLength;
					Vector2 left = direction.Rotated(-ArrowHeadAngle) * headLength;

					// 存储边角线段
					arrowLines[lineIndex++] = endPos;
					arrowLines[lineIndex++] = endPos + right;

					arrowLines[lineIndex++] = endPos;
					arrowLines[lineIndex++] = endPos + left;
				}
			}

			// 批量绘制所有线段
			DrawMultiline(arrowLines, _arrowColor, 2.0f);
		}
	}
}
