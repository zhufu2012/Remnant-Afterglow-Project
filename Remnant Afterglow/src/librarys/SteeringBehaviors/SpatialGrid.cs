using System;
using System.Collections.Generic;
using System.Linq;
using Collections.Pooled;
using GameLog;
using Godot;

namespace SteeringBehaviors
{
    /// <summary>
    /// 空间网格管理类
    /// </summary>
    public static class SpatialGrid
    {
        /// <summary>
        /// 网格大小应略大于最大分离半径
        /// </summary>
        private const float CellSize = 40f;
        /// <summary>
        /// 最大分离力
        /// </summary>
        public static float MaxSeparation = 50;
        /// <summary>
        /// SpatialGrid类中添加
        /// </summary>
        private const float INV_CELL_SIZE = 1f / CellSize;

        /// <summary>
        /// 每x帧 更新一次缓存
        /// </summary>
        public static int UpdateCacheTime = 1;


        private static readonly Dictionary<Vector2I, HashSet<Steering>> grid = new Dictionary<Vector2I, HashSet<Steering>>();

        /// <summary>
        /// 新增缓存字典，存储每个网格单元周围3x3区域的单位列表
        /// </summary>
        private static readonly Dictionary<Vector2I, List<Steering>> _cachedNearbyUnits = new Dictionary<Vector2I, List<Steering>>();

        /// <summary>
        /// 更新网格-祝福注释-全加入再批量
        /// </summary>
        /// <param name="steer"></param>
        public static void UpdateGrid(Steering steer)
        {
            // 计算新网格位置
            var cellPos = new Vector2I(
                (int)(steer.baseObject.Position.X * INV_CELL_SIZE),
                (int)(steer.baseObject.Position.Y * INV_CELL_SIZE)
            );
            // 如果网格单元未变化，直接返回
            if (steer.LastGridCell == cellPos)
                return;
            // 移除旧位置
            if (steer.LastGridCell != Vector2I.Zero &&
                grid.TryGetValue(steer.LastGridCell, out var oldCell))
            {
                oldCell.Remove(steer);
                if (oldCell.Count == 0)
                    grid.Remove(steer.LastGridCell);
            }

            // 添加新位置
            if (!grid.TryGetValue(cellPos, out var newCell))
            {
                newCell = new HashSet<Steering>();
                grid[cellPos] = newCell;
            }
            newCell.Add(steer);
            steer.LastGridCell = cellPos;
        }

        /// <summary>
        /// 每帧刷新逻辑，需在所有UpdateGrid之后调用
        /// </summary>
        public static void UpdateCache()
        {
            _cachedNearbyUnits.Clear();
            foreach (var cell in grid.Keys.ToList()) // 遍历所有有单位的网格单元
            {
                List<Steering> nearby = new List<Steering>();
                // 检查周围3x3网格区域
                for (int x = -1; x <= 1; x++)
                {
                    for (int y = -1; y <= 1; y++)
                    {
                        Vector2I checkCell = new Vector2I(cell.X + x, cell.Y + y);
                        if (grid.TryGetValue(checkCell, out var steerings))
                        {
                            nearby.AddRange(steerings);
                        }
                    }
                }
                _cachedNearbyUnits[cell] = nearby;
            }
        }

        /// <summary>
        /// 从空间网格中去除
        /// </summary>
        public static void RemoveFromGrid(Steering steer)
        {
            if (grid.TryGetValue(steer.LastGridCell, out var cell))
            {
                cell.Remove(steer);
            }
        }


        public static IEnumerable<Steering> GetNearby(Vector2 position, float radius)
        {
            var centerCell = new Vector2I(
                (int)(position.X * INV_CELL_SIZE),
                (int)(position.Y * INV_CELL_SIZE)
            );
            if (!_cachedNearbyUnits.TryGetValue(centerCell, out var nearbyList))
                yield break;

            foreach (var obj in nearbyList)
            {
                float radius_add = obj.SeparationRadius + radius;
                if (!obj.baseObject.IsDestroyed && position.DistanceSquaredTo(obj.baseObject.Position) <= radius_add * radius_add)
                {
                    yield return obj;
                }
            }
        }

        /// <summary>
        /// 获取指定位置半径范围内的所有单位（支持大范围检测）
        /// </summary>
        public static IEnumerable<Steering> GetNearbyList(Vector2 position, float radius)
        {
            var checkedCells = new HashSet<Vector2I>();
            int searchLayers = Mathf.CeilToInt(radius * INV_CELL_SIZE);

            // 计算需要检测的网格范围
            int centerX = (int)(position.X * INV_CELL_SIZE);
            int centerY = (int)(position.Y * INV_CELL_SIZE);

            // 根据搜索层数生成偏移
            for (int dx = -searchLayers; dx <= searchLayers; dx++)
            {
                for (int dy = -searchLayers; dy <= searchLayers; dy++)
                {
                    var checkCell = new Vector2I(centerX + dx, centerY + dy);

                    // 避免重复检测同一个网格
                    if (checkedCells.Contains(checkCell)) continue;
                    checkedCells.Add(checkCell);

                    // 尝试获取缓存数据
                    if (_cachedNearbyUnits.TryGetValue(checkCell, out var cellUnits))
                    {
                        foreach (var obj in cellUnits)
                        {
                            float combinedRadius = obj.SeparationRadius + radius;
                            if (!obj.baseObject.IsDestroyed &&
                                position.DistanceSquaredTo(obj.baseObject.Position) <= combinedRadius * combinedRadius)
                            {
                                yield return obj;
                            }
                        }
                    }

                    // 补充检测未缓存的边缘网格
                    if (searchLayers > 1 && grid.TryGetValue(checkCell, out var rawUnits))
                    {
                        foreach (var obj in rawUnits)
                        {
                            float combinedRadius = obj.SeparationRadius + radius;
                            if (!obj.baseObject.IsDestroyed &&
                                position.DistanceSquaredTo(obj.baseObject.Position) <= combinedRadius * combinedRadius)
                            {
                                yield return obj;
                            }
                        }
                    }
                }
            }
        }

        /// <summary>
        /// 获取分离力
        /// </summary>
        /// <param name="position"></param>
        /// <param name="radiusSq">半径的平方</param>
        /// <returns></returns>
        /// <summary>
        /// 获取分离力（使用预缓存数据优化性能）
        /// </summary>
        public static Vector2 GetSeparation(string Logotype,int Mass, Vector2 position, float radius)
        {
            var centerCell = new Vector2I(
                (int)(position.X * INV_CELL_SIZE),
                (int)(position.Y * INV_CELL_SIZE)
            );

            if (!_cachedNearbyUnits.TryGetValue(centerCell, out var nearbyList))
                return Vector2.Zero;

            Vector2 force = Vector2.Zero;
            int neighborCount = 0;
            foreach (var entity in nearbyList)
            {
                if (entity.baseObject.IsDestroyed || entity.Logotype==Logotype)
                    continue;
                float rad_add = entity.SeparationRadius + radius;
                Vector2 entityPos = entity.baseObject.Position;
                float dx = position.X - entityPos.X;
                float dy = position.Y - entityPos.Y;
                float distanceSq = dx * dx + dy * dy;
                // 当distanceSq为0时，检查是否为不同单位
                if (distanceSq == 0)
                {
                    // 如果是不同单位（通过Logotype判断），则添加随机分离力
                    // 注意：这里假设Logotype是单位的唯一标识符
                    if (entity.Logotype != null && entity.Logotype != "")
                    {
                        // 使用随机力分离重叠的不同单位
                        var rng = new Random(entity.Logotype.GetHashCode());
                        float randomDx = (float)rng.NextDouble() * 2 - 1; // -1 到 1之间
                        float randomDy = (float)rng.NextDouble() * 2 - 1; // -1 到 1之间

                        // 确保随机向量不为零向量
                        if (randomDx != 0 || randomDy != 0)
                        {
                            force += new Vector2(randomDx, randomDy).Normalized() * MaxSeparation * 0.1f;
                            neighborCount++;
                        }
                    }
                    continue;
                }
                if (distanceSq > rad_add * rad_add)
                    continue;
                float distance = Mathf.Sqrt(distanceSq);
                float weight = (rad_add - distance) / rad_add;
                force += new Vector2(dx, dy) * weight * (entity.Mass / Mass);
                neighborCount++;
            }
            if (neighborCount == 0)
                return Vector2.Zero;

            force /= neighborCount;
            float magnitude = force.Length();
            return magnitude > 0 ? force * (MaxSeparation / magnitude) : Vector2.Zero;
        }

        /// <summary>
        /// 清理数据
        /// </summary>
        public static void Clear()
        {
            grid.Clear();
            _cachedNearbyUnits.Clear();
        }
    }
}