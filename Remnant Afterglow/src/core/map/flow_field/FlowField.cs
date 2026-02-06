using Godot;
using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 单个流场
    /// </summary>
    public class FlowField
    {
        /// <summary>
        /// 宽度
        /// </summary>
        public int Width;
        /// <summary>
        /// 高度
        /// </summary>
        public int Height;
        /// <summary>
        /// 目标位置
        /// </summary>
        public Vector2I targetPos;
        /// <summary>
        /// 流场类型 0 位置目标流场  1 实体目标流场
        /// </summary>
        public int type;
        /// <summary>
        /// 流场数据<坐标，对应流场节点>
        /// </summary>
        public FlowFieldNode[,] nodeData;
        /// <summary>
        /// 创建一个位置流场
        /// </summary>
        /// <param name="targetPos">地图格子位置</param>
        public FlowField(Vector2I targetPos)
        {
            type = 0;
            this.targetPos = targetPos;
            Width = FlowFieldSystem.Instance.Width;
            Height = FlowFieldSystem.Instance.Height;
            nodeData = new FlowFieldNode[Width, Height];
            InitNodeData();
        }


        /// <summary>
        /// 初始化流场数据
        /// </summary>
        public void InitNodeData()
        {
            Cell[,] layer = FlowFieldSystem.Instance.layerData;
            for (int i = 0; i < Width; i++)
            {
                for (int j = 0; j < Height; j++)
                {
                    nodeData[i, j] = layer[i, j].GetGridNode();
                }
            }
            InitCost();
        }

        /// <summary>
        /// 处理墙壁等特殊的，可以使得周围8个地块代价增减的地块-祝福注释-这里可以优化到上面那个函数的循环里
        /// </summary>
        public void InitCost()
        {
            for (int i = 0; i < Width; i++)
            {
                for (int j = 0; j < Height; j++)
                {
                    if (nodeData[i, j].PassTypeId > 0)
                    {
                        MapPassType passType = FlowFieldSystem.Instance.passDict[nodeData[i, j].MaterialId];
                        if (passType.PassCostAdd != 0)//特殊地块
                        {
                            if (IsValid(i - 1, j - 1)) nodeData[i, j].pass_cost += passType.PassCostAdd;
                            if (IsValid(i, j - 1)) nodeData[i, j].pass_cost += passType.PassCostAdd;
                            if (IsValid(i + 1, j - 1)) nodeData[i, j].pass_cost += passType.PassCostAdd;
                            if (IsValid(i - 1, j)) nodeData[i, j].pass_cost += passType.PassCostAdd;
                            if (IsValid(i + 1, j)) nodeData[i, j].pass_cost += passType.PassCostAdd;
                            if (IsValid(i - 1, j + 1)) nodeData[i, j].pass_cost += passType.PassCostAdd;
                            if (IsValid(i, j + 1)) nodeData[i, j].pass_cost += passType.PassCostAdd;
                            if (IsValid(i + 1, j + 1)) nodeData[i, j].pass_cost += passType.PassCostAdd;
                        }
                    }
                }
            }
        }

        /// <summary>
        /// 生成流场
        /// </summary>
        public void Generate()
        {
            FlowFieldNode target = nodeData[targetPos.X, targetPos.Y];
            for (int x = 0; x < Width; x++)
            {
                for (int y = 0; y < Height; y++)
                {
                    FlowFieldNode node = nodeData[x, y];
                    if (!IsValid(x, y))
                    {
                        node.direction = Vector2.Zero;
                        continue;//这里去掉障碍物 上的矢量，不合适就加回来
                    }
                    List<FlowFieldNode> neighbourNodes = GetNeighbouringNodes(node);
                    float fCost = node.fCost;
                    FlowFieldNode temp = null;
                    for (int i = 0; i < neighbourNodes.Count; i++)
                    {
                        FlowFieldNode neighbourNode = neighbourNodes[i];
                        if (neighbourNode.fCost < fCost)
                        {
                            temp = neighbourNode;
                            fCost = neighbourNode.fCost;
                            node.direction = new Vector2(
                                neighbourNode.x - node.x, neighbourNode.y - node.y).Normalized();
                        }
                        else if (neighbourNode.fCost == fCost && temp != null)
                        {
                            if (CalculateCost(neighbourNode, target) < CalculateCost(temp, target))
                            {
                                temp = neighbourNode;
                                fCost = neighbourNode.fCost;
                                node.direction = new Vector2(
                                    neighbourNode.x - node.x, neighbourNode.y - node.y).Normalized();
                            }
                        }
                    }
                }
            }
        }



        /// <summary>
        /// 设置目标节点
        /// </summary>
        public void SetTarget()
        {
            for (int x = 0; x < Width; x++)
            {
                for (int y = 0; y < Height; y++)
                {
                    FlowFieldNode node = nodeData[x, y];
                    node.cost = node.isWalkable ? 10 : int.MaxValue;
                    node.fCost = int.MaxValue;
                }
            }
            FlowFieldNode target = nodeData[targetPos.X, targetPos.Y];
            target.cost = 0;
            target.fCost = 0;
            target.direction = Vector2.Zero;
            Queue<FlowFieldNode> queue = new Queue<FlowFieldNode>();
            queue.Enqueue(target);
            while (queue.Count > 0)
            {
                FlowFieldNode currentNode = queue.Dequeue();
                List<FlowFieldNode> neighbourNodes = GetNeighbouringNodes(currentNode);
                for (int i = 0; i < neighbourNodes.Count; i++)
                {
                    FlowFieldNode neighbourNode = neighbourNodes[i];
                    if (neighbourNode.cost == int.MaxValue) continue;
                    float scost = CalculateCost(neighbourNode, currentNode);
                    if (scost == int.MaxValue)
                    {
                        neighbourNode.cost = int.MaxValue;
                    }
                    else
                    {
                        neighbourNode.cost = scost * neighbourNode.pass_cost;
                    }
                    if (neighbourNode.cost + currentNode.fCost < neighbourNode.fCost)
                    {
                        neighbourNode.fCost = neighbourNode.cost + currentNode.fCost;
                        queue.Enqueue(neighbourNode);
                    }
                }
            }
        }




        /// <summary>
        /// 获取指定节点的邻节点
        /// </summary>
        /// <param name="node">要获取邻节点的节点</param>
        /// <returns>邻节点列表</returns>
        public List<FlowFieldNode> GetNeighbouringNodes(FlowFieldNode node)
        {
            List<FlowFieldNode> neighbours = new List<FlowFieldNode>();
            for (int i = -1; i <= 1; i++)
            {
                for (int j = -1; j <= 1; j++)
                {
                    if (i == 0 && j == 0) continue;
                    int x = node.x + i;
                    int y = node.y + j;

                    // 跳过越界或不可通行的节点
                    if (!IsValid(x, y)) continue;

                    // 斜向移动需额外检查相邻节点
                    if (i != 0 && j != 0)
                    {
                        bool horizontalValid = IsValid(node.x + i, node.y);
                        bool verticalValid = IsValid(node.x, node.y + j);
                        if (!horizontalValid || !verticalValid) continue;
                    }

                    neighbours.Add(nodeData[x, y]);
                }
            }
            return neighbours;
        }


        /// <summary>
        /// 获取指定节点的邻节点
        /// </summary>
        /// <param name="centerPos">要获取邻节点的节点</param>
        /// <returns>邻节点列表</returns>
        public List<FlowFieldNode> GetNeighbouringNodes(Vector2I centerPos)
        {
            List<FlowFieldNode> neighbours = new List<FlowFieldNode>();
            for (int i = -1; i <= 1; i++)
            {
                for (int j = -1; j <= 1; j++)
                {
                    if (i == 0 && j == 0) continue;
                    int x = centerPos.X + i;
                    int y = centerPos.Y + j;

                    // 跳过越界或不可通行的节点
                    if (!IsValid(x, y)) continue;

                    // 斜向移动需额外检查相邻节点
                    if (i != 0 && j != 0)
                    {
                        bool horizontalValid = IsValid(centerPos.X + i, centerPos.Y);
                        bool verticalValid = IsValid(centerPos.X, centerPos.Y + j);
                        if (!horizontalValid || !verticalValid) continue;
                    }

                    neighbours.Add(nodeData[x, y]);
                }
            }
            return neighbours;
        }


        /// <summary>
        /// 计算两个节点之间的代价>
        /// </summary>
        /// <param name="node1"></param>
        /// <param name="node2"></param>
        /// <returns></returns>
        public float CalculateCost(FlowFieldNode node1, FlowFieldNode node2)
        {
            int deltaX = Mathf.Abs(node1.x - node2.x);
            int deltaY = Mathf.Abs(node1.y - node2.y);

            // 处理斜向移动的中间节点检查
            if (deltaX != 0 && deltaY != 0)
            {
                // 计算移动方向
                int xDir = (node2.x > node1.x) ? 1 : -1;
                int yDir = (node2.y > node1.y) ? 1 : -1;

                // 检查横向和纵向相邻节点是否可通行
                bool horizontalValid = IsValid(node1.x + xDir, node1.y);
                bool verticalValid = IsValid(node1.x, node1.y + yDir);

                // 任一中间节点不可通行时，禁止斜向移动
                if (!horizontalValid || !verticalValid)
                {
                    return int.MaxValue;
                }
            }

            // 计算移动代价（保持不变）
            int delta = Mathf.Abs(deltaX - deltaY);
            return 1.414f * Mathf.Min(deltaX, deltaY) + 1 * delta;
        }

        /// <summary>
        /// 某个格子是否可以使用
        /// </summary>
        /// <param name="X">位置X</param>
        /// <param name="Y">位置Y</param>
        public bool IsValid(int X, int Y)
        {
            return X >= 0 && Y >= 0 && X < Width && Y < Height && nodeData[X, Y].isWalkable;
        }


        /// <summary>
        /// 某个格子是否可以使用
        /// </summary>
        /// <param name="pos">位置</param>
        public bool IsValid(Vector2I pos)
        {
            return pos.X >= 0 && pos.Y >= 0 && pos.X < Width && pos.Y < Height && nodeData[pos.X, pos.Y].isWalkable;
        }

        /// <summary>
        /// 检查给定位置是否能到达流场终点
        /// </summary>
        /// <param name="pos">要检查的位置</param>
        /// <returns>是否可达</returns>
        public bool IsPositionReachable(Vector2I pos)
        {
            // 检查位置是否超出边界
            if (pos.X < 0 || pos.X >= Width || pos.Y < 0 || pos.Y >= Height)
                return false;
            // 获取指定位置的节点
            FlowFieldNode node = nodeData[pos.X, pos.Y];
            // 如果节点的fCost不是最大值，则认为是可达的
            return node.fCost != int.MaxValue;
        }

        /// <summary>
        /// 获得对应格子的矢量
        /// </summary>
        /// <param name="x"></param>
        /// <param name="y"></param>
        /// <returns></returns>
        public Vector2 GetDirection(int x, int y)
        {
            return nodeData[x, y].direction;
        }

        /// <summary>
        /// 获得对应格子的矢量
        /// </summary>
        /// <param name="pos"></param>
        /// <returns></returns>
        public Vector2 GetDirection(Vector2I pos)
        {
            return nodeData[pos.X, pos.Y].direction;
        }
    }
}