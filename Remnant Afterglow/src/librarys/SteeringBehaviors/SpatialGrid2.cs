using System.Collections.Generic;
using System.Linq;
using GameLog;
using Godot;

namespace SteeringBehaviors
{
    public static class SpatialGrid2
    {
        // 调整为动态网格大小，建议为平均对象尺寸的2倍
        public static float CellSize = 50f;
        /// <summary>
        /// 最大分离力
        /// </summary>
        public static float MaxSeparation = 50;
        private static readonly Dictionary<Vector2I, HashSet<Steering2>> grid = new();

        // 修改后的UpdateGrid方法
        public static void UpdateGrid(Steering2 steer)
        {
            var newAABB = steer.GetAABB();
            var newCells = CalculateCoveredCells(newAABB);

            // 使用Except找出需要移除的旧网格
            var cellsToRemove = steer.LastCoveredCells.Except(newCells).ToList();
            foreach (var cell in cellsToRemove)
            {
                if (grid.TryGetValue(cell, out var set))
                {
                    set.Remove(steer);
                }
            }

            // 添加新网格（使用Union处理新增区域）
            foreach (var cell in newCells)
            {
                if (!grid.ContainsKey(cell))
                {
                    grid[cell] = new HashSet<Steering2>();
                }
                grid[cell].Add(steer);
            }

            // 更新记录时创建新集合避免引用问题
            steer.LastCoveredCells = new HashSet<Vector2I>(newCells);
        }


        /// <summary>
        /// 完全移除对象时调用（如对象被销毁）
        /// </summary>
        public static void FullRemoveFromGrid(Steering2 steer)
        {
            if (steer.LastCoveredCells == null) return;

            // 从所有注册的网格单元中移除
            foreach (var cell in steer.LastCoveredCells)
            {
                if (grid.TryGetValue(cell, out var cellSet))
                {
                    cellSet.Remove(steer);
                }
            }
            steer.LastCoveredCells.Clear();
        }


        /// <summary>
        /// 更新时清理旧网格的残留数据
        /// </summary>
        private static void CleanStaleData()
        {
            // 定期调用（如每10帧）清理空网格
            var emptyCells = grid.Where(p => p.Value.Count == 0)
                                .Select(p => p.Key).ToList();
            foreach (var cell in emptyCells)
            {
                grid.Remove(cell);
            }
        }
        /// <summary>
        /// 计算AABB覆盖的网格单元
        /// </summary>
        /// <param name="aabb"></param>
        /// <returns></returns>
        private static HashSet<Vector2I> CalculateCoveredCells(Rect2 aabb)
        {
            var cells = new HashSet<Vector2I>();

            int startX = (int)(aabb.Position.X / CellSize);
            int startY = (int)(aabb.Position.Y / CellSize);
            int endX = (int)((aabb.Position.X + aabb.Size.X) / CellSize);
            int endY = (int)((aabb.Position.Y + aabb.Size.Y) / CellSize);

            for (int x = startX; x <= endX; x++)
            {
                for (int y = startY; y <= endY; y++)
                {
                    cells.Add(new Vector2I(x, y));
                }
            }
            return cells;
        }

        /// <summary>
        /// 优化后的分离力计算（基于AABB重叠）
        /// </summary>
        /// <param name="self"></param>
        /// <returns></returns>
        public static Vector2 GetSeparation(Steering2 self)
        {
            var selfAABB = self.GetAABB();
            Vector2 force = Vector2.Zero;
            int neighborCount = 0;

            foreach (var cell in self.LastCoveredCells)
            {
                if (!grid.TryGetValue(cell, out var set)) continue;

                foreach (var other in set)
                {
                    if (other == self || other.baseObject.IsDestroyed) continue;

                    var otherAABB = other.GetAABB();
                    if (CheckAABBOverlap(selfAABB, otherAABB, out var overlap))
                    {
                        // 根据重叠区域计算排斥方向
                        Vector2 dir = GetSeparationDirection(selfAABB, otherAABB);
                        float weight = CalculateOverlapWeight(overlap, selfAABB);

                        force += dir * weight * (other.Mass / self.Mass);
                        neighborCount++;
                    }
                }
            }

            return neighborCount > 0 ?
                force.LimitLength(MaxSeparation) :
                Vector2.Zero;
        }

        // AABB碰撞检测
        private static bool CheckAABBOverlap(Rect2 a, Rect2 b, out Rect2 overlap)
        {
            overlap = new Rect2();

            float x1 = Mathf.Max(a.Position.X, b.Position.X);
            float y1 = Mathf.Max(a.Position.Y, b.Position.Y);
            float x2 = Mathf.Min(a.End.X, b.End.X);
            float y2 = Mathf.Min(a.End.Y, b.End.Y);

            if (x2 >= x1 && y2 >= y1)
            {
                overlap = new Rect2(x1, y1, x2 - x1, y2 - y1);
                return true;
            }
            return false;
        }



        /// <summary>
        /// 获取两个AABB之间的分离方向（基于最小平移向量原理）
        /// </summary>
        private static Vector2 GetSeparationDirection(Rect2 selfAABB, Rect2 otherAABB)
        {
            // 计算重叠区域
            float overlapLeft = otherAABB.End.X - selfAABB.Position.X;
            float overlapRight = selfAABB.End.X - otherAABB.Position.X;
            float overlapTop = otherAABB.End.Y - selfAABB.Position.Y;
            float overlapBottom = selfAABB.End.Y - otherAABB.Position.Y;
            Mathf.Min(Mathf.Min(Mathf.Abs(overlapLeft), Mathf.Abs(overlapRight)),
                Mathf.Min(Mathf.Abs(overlapTop), Mathf.Abs(overlapBottom)));
            // 找出最小重叠方向
            float minOverlap = Mathf.Min(Mathf.Min(Mathf.Abs(overlapLeft), Mathf.Abs(overlapRight)),
    Mathf.Min(Mathf.Abs(overlapTop), Mathf.Abs(overlapBottom)));

            // 根据最小重叠方向确定分离方向
            if (minOverlap == Mathf.Abs(overlapLeft))
                return Vector2.Left;
            if (minOverlap == Mathf.Abs(overlapRight))
                return Vector2.Right;
            if (minOverlap == Mathf.Abs(overlapTop))
                return Vector2.Up; // Godot坐标系Y轴向下，这里可能需要调整
            return Vector2.Down;
        }

        /// <summary>
        /// 计算重叠权重（基于重叠面积和对象尺寸比例）
        /// </summary>
        private static float CalculateOverlapWeight(Rect2 overlapArea, Rect2 selfAABB)
        {
            // 方法1：简单面积比例
            // return overlapArea.Area / selfAABB.Area;

            // 方法2：归一化距离（推荐）
            Vector2 selfCenter = selfAABB.Position + selfAABB.Size / 2;
            Vector2 otherCenter = overlapArea.Position + overlapArea.Size / 2;
            float distance = selfCenter.DistanceTo(otherCenter);
            return 1f - Mathf.Clamp(distance / (selfAABB.Size.Length() * 0.5f), 0, 1);
        }
    }
}