using GameLog;
using Godot;
using System.Collections.Generic;
using System.Linq;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 流场导航系统
    /// </summary>
    public partial class FlowFieldSystem
    {
        /// <summary>
        /// 单例模式，用于全局访问FlowFieldSystem实例
        /// </summary>
        public static FlowFieldSystem Instance { get; set; }

        /// <summary>
        /// 用于显示的流场
        /// </summary>
        public FlowField ShowFlowField { get; set; }

        /// <summary>
        /// 地图横向长度
        /// </summary>
        public int Width;
        /// <summary>
        /// 地图纵向长度
        /// </summary>
        public int Height;
        /// <summary>
        /// 地板层 地图
        /// </summary>
        public Cell[,] layerData;
        /// <summary>
        /// 可通行类型配置字典 <材料id,可通行配置>
        /// </summary>
        public Dictionary<int, MapPassType> passDict = new Dictionary<int, MapPassType>();
        /// <summary>
        /// 位置流场字典  <目标位置,流场> 实体群体移动时使用， 地图变化时需要更新流场-祝福注释
        /// </summary>
        public Dictionary<Vector2I, FlowField> posFlowDict = new Dictionary<Vector2I, FlowField>();

        /// <summary>
        /// 副本id
        /// </summary>
        public int ChapterId;
        /// <summary>
        /// 关卡id
        /// </summary>
        public int CopyId;
        /// <summary>
        /// 刷新点的格子
        /// </summary>
        public List<Vector2I> CenterList = new List<Vector2I>();
        public FlowFieldSystem(int Width, int Height, Cell[,] layer, int ChapterId, int CopyId)
        {
            Instance = this;
            this.Width = Width;
            this.Height = Height;
            layerData = layer;
            this.ChapterId = ChapterId;
            this.CopyId = CopyId;

            //查询所有通过类型PassTypeId 非0的数据-祝福注释-可以优化到其他地方-比如MapFixedMaterial配置内部，提前计算
            List<Dictionary<string, object>> QueryList =
                ConfigLoadSystem.QueryCfgAllNonMatchingLines(ConfigConstant.Config_MapFixedMaterial, new Dictionary<string, object> { { "PassTypeId", 0 }
            });
            foreach (Dictionary<string, object> info in QueryList)//初始化通行类型 字典
            {
                passDict[(int)info["MaterialId"]] = ConfigCache.GetMapPassType((int)info["PassTypeId"]);
            }
            CopyBrush copyBrush = ConfigCache.GetCopyBrush(ChapterId + "_" + CopyId);
            foreach (int BrushId in copyBrush.BrushIdList)//遍历刷新点
            {
                BrushPoint brushPoint = ConfigCache.GetBrushPoint(BrushId);
                List<Vector2I> vector2Is = brushPoint.BrushPosList;
                Vector2I center = vector2Is[0] + vector2Is[1] / 2;
                CenterList.Add(center);
            }
        }


        /// <summary>
        /// 新增一个位置流场 地图格子位置
        /// </summary>
        /// <param name="targetPos">目标位置（地图格子）</param>
        /// <param name="unitType">单位类型</param>
        /// <param name="BrushId">刷新点id</param>
        public FlowField AddPosFlowField(Vector2I targetPos)
        {
            if (targetPos.X >= 0 && targetPos.Y >= 0 && targetPos.X < Width && targetPos.Y < Height)
            {
                if (!posFlowDict.ContainsKey(targetPos))//如果没有，才创建
                {
                    FlowField flow = new FlowField(targetPos);
                    posFlowDict[targetPos] = flow;
                    flow.SetTarget();//设置目标节点
                    flow.Generate();//生成流场
                    PathExpand(flow);
                }
                return posFlowDict[targetPos];
            }
            else
            {
                Log.Error("配置错误！流场目标不在地图范围内");
                return null;
            }
        }

        /// <summary>
        /// 移除不再使用的流场
        /// </summary>
        /// <param name="targetPos"></param>
        public void RemovePosFlowField(Vector2I targetPos)
        {
            posFlowDict.Remove(targetPos);
        }


        /// <summary>
        /// 设置实体，重新生成流场
        /// </summary>
        public void CreateBaseObject(string logotype, Vector2I mapPos, BuildData buildData, bool isPass)
        {
            switch (buildData.SubType)
            {
                case 0://常规建筑
                    int size = buildData.BuildingSize;
                    int p = size / 2;
                    bool isEven = size % 2 == 0;
                    // 预计算建筑影响范围
                    int startX = mapPos.X - p;
                    int endX = mapPos.X + p + (isEven ? -1 : 0);
                    int startY = mapPos.Y - p;
                    int endY = mapPos.Y + p + (isEven ? -1 : 0);
                    switch (IdGenerator.GetType(logotype))
                    {
                        case IdConstant.ID_TYPE_TOWER:
                        case IdConstant.ID_TYPE_BUILD:
                            // 预先收集所有需要修改的坐标
                            var modifiedCoordinates = new List<Vector2I>();
                            for (int i = startX; i <= endX; i++)
                            {
                                for (int j = startY; j <= endY; j++)
                                {
                                    modifiedCoordinates.Add(new Vector2I(i, j));
                                }
                            }
                            // 每个流场统一处理所有坐标修改
                            foreach (var flow in posFlowDict.Values)
                            {
                                // 批量修改节点属性
                                foreach (var coord in modifiedCoordinates)
                                {
                                    int x = coord.X;
                                    int y = coord.Y;

                                    //if (!flow.IsValid(x, y)) continue;

                                    FlowFieldNode node = flow.nodeData[x, y];
                                    node.cost = isPass ? node.pass_cost : int.MaxValue;
                                    node.isWalkable = isPass;
                                }
                                // 流场更新统一到循环外
                                flow.SetTarget();
                                flow.Generate();
                                PathExpand(flow);
                            }
                            break;
                        default:
                            Log.Error($"获取实体的类型报错！LogoType: {logotype}, {IdGenerator.GetType(logotype)}");
                            break;
                    }
                    ;
                    break;
                case 1://埋地建筑，不可被攻击，不会阻挡单位
                    break;
                case 2://核心建筑，可被攻击，不会阻挡单位
                    break;
            }
        }



        /// <summary>
        /// 重新生成所有流场，用于地图初始化完成后
        /// </summary>
        public void RegenerateAllFlowFields()
        {
            foreach (var flow in posFlowDict.Values)
            {
                flow.SetTarget();   // 重新设置目标节点
                flow.Generate();    // 重新生成流场
                PathExpand(flow);   // 重新进行路径拓展
            }
        }

        /// <summary>
        /// 路线拓展函数-对从各刷新点到核心的路线进行拓展（优化版）
        /// </summary>
        public void PathExpand(FlowField flowField)
        {
            //if(true) return;
            Vector2I targetPos = flowField.targetPos;
            // 预计算3x3邻域偏移量-祝福注释这里可以优化
            var neighborOffsets = new Vector2I[9];
            int index = 0;
            for (int x = -1; x <= 1; x++)
            {
                for (int y = -1; y <= 1; y++)
                {
                    neighborOffsets[index++] = new Vector2I(x, y);
                }
            }

            foreach (Vector2I center in CenterList)
            {
                // 路径生成阶段
                List<Vector2I> pathList = new List<Vector2I>();
                HashSet<Vector2I> visitedNodes = new HashSet<Vector2I>();
                FlowFieldNode current = flowField.nodeData[center.X, center.Y];

                pathList.Add(center);
                visitedNodes.Add(center);

                while (true)
                {
                    // 到达目标点则终止
                    if (current.x == targetPos.X && current.y == targetPos.Y) break;

                    // 获取有效邻居节点
                    var neighbors = flowField.GetNeighbouringNodes(current)
                        .Where(n => !visitedNodes.Contains(new Vector2I(n.x, n.y)))
                        .ToList();

                    // 找不到更低代价节点时提前终止
                    if (neighbors.Count == 0) break;

                    // 选择代价最小的节点
                    FlowFieldNode nextNode = neighbors[0];
                    foreach (var node in neighbors.Skip(1))
                    {
                        if (node.fCost < nextNode.fCost)
                            nextNode = node;
                    }

                    // 更新当前节点并记录路径
                    current = nextNode;
                    Vector2I currentPos = new Vector2I(current.x, current.y);
                    pathList.Add(currentPos);
                    visitedNodes.Add(currentPos);
                }

                // 路径扩散阶段
                HashSet<Vector2I> pathSet = new HashSet<Vector2I>(pathList);
                Dictionary<Vector2I, Vector2> directionUpdates = new Dictionary<Vector2I, Vector2>();
                Vector2I lastPos = center;
                Vector2I dir_off;
                foreach (Vector2I node in pathList)
                {
                    Vector2 direction = flowField.nodeData[node.X, node.Y].direction;
                    dir_off = new Vector2I(direction.X > 0 ? 1 : direction.X == 0 ? 0 : -1,
                        direction.Y > 0 ? 1 : direction.Y == 0 ? 0 : -1);

                    foreach (Vector2I offset in neighborOffsets)
                    {
                        int x = node.X + offset.X;
                        int y = node.Y + offset.Y;
                        if (!flowField.IsValid(x, y))
                            continue;
                        // 快速边界检查
                        if (x < 0 || x >= flowField.Width || y < 0 || y >= flowField.Height)
                            continue;

                        Vector2I neighborPos = new Vector2I(x, y);

                        // 跳过上一个位置和路径上的节点
                        if (neighborPos.Equals(lastPos) || pathSet.Contains(neighborPos))
                            continue;

                        //检测该位置是否为可通行，不可通行的话,neighborPos的方向不应该改变
                        Vector2I dir_pos = neighborPos + dir_off;
                        if (!flowField.IsValid(dir_pos.X, dir_pos.Y))
                            continue;

                        // 记录需要更新的方向（最后一次出现的路径节点会覆盖之前的）
                        directionUpdates[neighborPos] = direction;
                    }
                    lastPos = node;
                }

                // 批量更新方向
                foreach (var kvp in directionUpdates)
                {
                    Vector2 direction = kvp.Value;
                    // 跳过方向为0的节点
                    if (direction == Vector2.Zero)
                        continue;
                    flowField.nodeData[kvp.Key.X, kvp.Key.Y].direction = direction;
                }
            }
        }


        /// <summary>
        /// 根据目标和当前位置，获得流场方向
        /// </summary>
        /// <param name="targetPos"></param>
        /// <param name="mapPos"></param>
        /// <returns></returns>
        public static Vector2 GetDirection(Vector2I targetPos, Vector2I mapPos)
        {
            if (Instance.posFlowDict.TryGetValue(targetPos, out FlowField flowField))
            {
                return flowField.GetDirection(mapPos);
            }
            return new Vector2(0, 0);
        }

        /// <summary>
        /// 根据目标和当前位置，获得流场方向
        /// </summary>
        /// <param name="targetPos"></param>
        /// <param name="mapPos"></param>
        /// <returns></returns>
        public static Vector2 GetDirection(Vector2I targetPos, int X, int Y)
        {
            if (Instance.posFlowDict.TryGetValue(targetPos, out FlowField flowField))
            {
                return flowField.GetDirection(X, Y);
            }
            return new Vector2(0, 0);
        }

        /// <summary>
        /// 格子能否使用
        /// </summary>
        /// <param name="targetPos"></param>
        /// <param name="mapPos"></param>
        /// <returns></returns>
        public static bool IsValid(Vector2I targetPos, Vector2I mapPos)
        {
            if (Instance.posFlowDict.TryGetValue(targetPos, out FlowField flowField))
            {
                return flowField.IsValid(mapPos);
            }
            return false;
        }

        /// <summary>
        /// 格子能否使用
        /// </summary>
        /// <param name="targetPos"></param>
        /// <param name="mapPos"></param>
        /// <returns></returns>
        public static bool IsValid(Vector2I targetPos, int X, int Y)
        {
            if (Instance.posFlowDict.TryGetValue(targetPos, out FlowField flowField))
            {
                return flowField.IsValid(X, Y);
            }
            return false;
        }




    }
}