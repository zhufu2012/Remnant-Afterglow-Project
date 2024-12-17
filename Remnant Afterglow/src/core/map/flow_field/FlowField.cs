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
        public Dictionary<Vector2I, FlowFieldNode> nodeData = new Dictionary<Vector2I, FlowFieldNode>();
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
            this.targetPos = targetObject.mapPos;
            this.type = 1;
            InitNodeData();
        }

        /// <summary>
        /// 初始化流场数据
        /// </summary>
        public void InitNodeData()
        {
            Cell[,] layer = FlowFieldSystem.Instance.layer;
            for (int i = 0; i < layer.GetLength(0); i++)
            {
                for (int j = 0; j < layer.GetLength(1); j++)
                {
                    nodeData[new Vector2I(i, j)] = layer[i, j].GetGridNode();
                }
            }
        }

        /// <summary>
        /// 生成流场
        /// </summary>
        public void Generate()
        {
            FlowFieldNode target = nodeData[targetPos];
            foreach (var node in nodeData.Values)
            {
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
                            neighbourNode.x - node.x, neighbourNode.y - node.y);
                    }
                    else if (neighbourNode.fCost == fCost && temp != null)
                    {
                        if (CalculateCost(neighbourNode, target) < CalculateCost(temp, target))
                        {
                            temp = neighbourNode;
                            fCost = neighbourNode.fCost;
                            node.direction = new Vector2(
                                neighbourNode.x - node.x, neighbourNode.y - node.y);
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
            FlowFieldNode target = nodeData[targetPos];
            foreach (var node in nodeData.Values)
            {
                node.cost = node.isWalkable ? 10 : int.MaxValue;
                node.fCost = int.MaxValue;
            }
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
                    if (x >= 0 && x < this.Width && y >= 0 && y < this.Height)
                        neighbours.Add(nodeData[new Vector2I(x, y)]);
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
            int delta = deltaX - deltaY;
            if (delta < 0) delta = -delta;
            //每向上、下、左、右方向移动一个节点代价增加10
            //每斜向移动一个节点代价增加14（勾股定理，精确来说是近似14.14~）
            return 1.414f * (deltaX > deltaY ? deltaY : deltaX) + 1 * delta;
        }

    }
}