
using System;

namespace Remnant_Afterglow
{
    public class TechTreeLayout
    {
        public (int, int)[][] Layout(TechNode root)
        {
            // 计算科技树的最大宽度和最大深度
            var (maxWidth, maxDepth) = CalculateDimensions(root);

            // 创建网格
            var grid = new (int, int)[maxDepth][];

            for (int i = 0; i < maxDepth; i++)
            {
                grid[i] = new (int, int)[maxWidth];
                for (int j = 0; j < maxWidth; j++)
                {
                    grid[i][j] = (-1, -1); // 使用(-1, -1)表示空位置
                }
            }

            // 放置节点
            PlaceNodes(root, 0, 0, ref grid);

            return grid;
        }

        private (int, int) CalculateDimensions(TechNode node, int depth = 0, int width = 0)
        {
            if (node == null) return (width, depth);

            int currentWidth = 1 + (node.Children.Count > 0 ? node.Children.Count - 1 : 0);
            int maxChildWidth = 0;
            int maxChildDepth = 0;

            foreach (var child in node.Children)
            {
                var (childWidth, childDepth) = CalculateDimensions(child, depth + 1, 0);
                maxChildWidth = Math.Max(maxChildWidth, childWidth);
                maxChildDepth = Math.Max(maxChildDepth, childDepth);
            }

            return (Math.Max(width, currentWidth + maxChildWidth), Math.Max(depth, maxChildDepth));
        }

        private void PlaceNodes(TechNode node, int row, int col, ref (int, int)[][] grid)
        {
            if (node == null) return;

            // 将当前节点放置到网格中
            grid[row][col] = (row, col);

            // 放置子节点
            int childCol = col;
            foreach (var child in node.Children)
            {
                // 如果同一行已经有节点，则换到下一行
                if (childCol >= grid[row].Length - 1)
                {
                    row++;
                    childCol = 0;
                }
                else
                {
                    childCol++;
                }

                PlaceNodes(child, row, childCol, ref grid);
            }
        }
    }
}