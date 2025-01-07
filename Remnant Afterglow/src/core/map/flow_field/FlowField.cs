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
        /// <param name="targetPos"></param>
        public FlowField(Vector2I targetPos)
        {
            this.targetPos = targetPos;
            type = 0;
            Width = FlowFieldSystem.Instance.Width;
            Height = FlowFieldSystem.Instance.Height;
            InitNodeData();
        }

        /// <summary>
        /// 创建一个实体流场
        /// </summary>
        /// <param name="targetObject"></param>
        public FlowField(BaseObject targetObject)
        {
            targetPos = targetObject.mapPos;
            Width = FlowFieldSystem.Instance.Width;
            Height = FlowFieldSystem.Instance.Height;
            type = 1;
            InitNodeData();
        }

        /// <summary>
        /// 初始化流场数据
        /// </summary>
        public void InitNodeData()
        {
            Cell[,] layer = FlowFieldSystem.Instance.layer;
            nodeData = new FlowFieldNode[Width, Height];
            for (int i = 0; i < Width; i++)
            {
                for (int j = 0; j < Height; j++)
                {
                    nodeData[i, j] = layer[i, j].GetGridNode();
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
        /// <param name="target">目标位置</param>
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
                    neighbourNode.cost = CalculateCost(neighbourNode, currentNode) * neighbourNode.pass_cost;
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
                    if (x >= 0 && x < Width && y >= 0 && y < Height && nodeData[x, y].isWalkable)
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
        private float CalculateCost(FlowFieldNode node1, FlowFieldNode node2)
        {
            //取绝对值
            int deltaX = node1.x - node2.x;
            if (deltaX < 0) deltaX = -deltaX;
            int deltaY = node1.y - node2.y;
            if (deltaY < 0) deltaY = -deltaY;
            // 先判断是否是斜向移动，如果是斜向，检查中间节点是否可通行
            if (deltaX!= 0 && deltaY!= 0)
            {
                int intermediateX = node1.x < node2.x? node1.x + 1 : node1.x - 1;
                int intermediateY = node1.y < node2.y? node1.y + 1 : node1.y - 1;
                if (!IsValid(intermediateX, intermediateY))//这个格子能使用
                {
                    return int.MaxValue;
                }
            }
            int delta = deltaX - deltaY;
            if (delta < 0) delta = -delta;
            //每向上、下、左、右方向移动一个节点代价增加1
            //每斜向移动一个节点代价增加1.414（勾股定理，精确来说是近似1.414~）
            return 1.414f * (deltaX > deltaY ? deltaY : deltaX) + 1 * delta;
        }

        /// <summary>
        /// 某个格子是否可以使用
        /// </summary>
        /// <param name="pos"></param>
        /// <returns></returns>
        public bool IsValid(int X, int Y)
        {
            return X >= 0 && Y >= 0 && X < Width && Y < Height && nodeData[X, Y].cost != int.MaxValue;
        }

        public Vector2 GetDirection(int x, int y)
        {
            return nodeData[x, y].direction;
        }

        public Vector2 GetDirection(Vector2I pos)
        {
            return nodeData[pos.X, pos.Y].direction;
        }
    }
}