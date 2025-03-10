using Godot;
using System;

namespace Remnant_Afterglow
{
    public partial class FlowFieldDrawer : Node2D
    {
        private FlowField flowField;
        private float _arrowLength = 8.0f; // 箭头长度
        private Color _arrowColor = new Color("white"); // 箭头颜色
        public override void _Ready()
        {
        }

        public override void _PhysicsProcess(double delta)
        {
            QueueRedraw();
        }

        public override void _Draw()
        {
            DrawFlowFieldArrows();
        }

        private void DrawFlowFieldArrows()
        {
            flowField = FlowFieldSystem.Instance.ShowFlowField;
            if (flowField != null)
            {
                Vector2I targetPos = flowField.targetPos;
                int TileSize = MapConstant.TileCellSize;
                for (int x = 0; x < FlowFieldSystem.Instance.Width; x++)
                {
                    for (int y = 0; y < FlowFieldSystem.Instance.Height; y++)
                    {
                        Vector2I position = new Vector2I(x, y);
                        if (position == targetPos)
                        {
                            DrawCircle(targetPos * TileSize + new Vector2(TileSize / 2, TileSize / 2), TileSize / 2, Colors.White);

                        }
                        else
                        {
                            Vector2 direction = flowField.nodeData[x, y].direction;
                            if (direction == Vector2.Zero)
                                continue;
                            // 计算箭头的起点和终点
                            Vector2 startPos = new Vector2(position.X, position.Y) * TileSize + new Vector2(TileSize / 2, TileSize / 2);
                            Vector2 endPos = startPos + direction * _arrowLength;

                            // 绘制箭头线段
                            DrawLine(startPos, endPos, _arrowColor, 2.0f);
                            // 计算箭头的两个边角
                            Vector2 right = direction.Rotated(Mathf.DegToRad(-30)) * _arrowLength * 0.4f;
                            Vector2 left = direction.Rotated(Mathf.DegToRad(30)) * _arrowLength * 0.4f;
                            // 绘制箭头的两个边角
                            DrawLine(endPos, endPos + right, _arrowColor, 2.0f);
                            DrawLine(endPos, endPos + left, _arrowColor, 2.0f);
                        }
                    }
                }
            }
        }
    }
}
