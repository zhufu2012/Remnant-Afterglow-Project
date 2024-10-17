/*兵种寻路思路，一个地图唯一的寻路系统。保存兵种建筑位置，是否移动等信息

1.所有在地图上的兵种都使用同一个寻路系统的每帧计算结果来设置，寻路系统是地图独有的，
要求在初始化时，将所有不可移动项设置好，记录为网格，网格可以有多层
第一层是陆军（建筑）寻路网格，第二层是空军寻路网格，
陆军寻路网格应该是一个一维结构体数组（以二维方式访问）
空军寻路网格应该是一个一维结构体数组（以二维方式访问）
是否能通行应当是可以修改的
每一帧兵种都按照判断是否移动，可移动再移动位置。

兵种刷新：
每个刷新点初始化时，检查范围内所有点，保存所有在范围内的点，然后之后刷新就在这些点中检查，一个单位占地为1个格子，刷怪时去掉这些单位占地和地块占地我，
保存两个列表，一个是总的可刷新点，一个是剩余可刷新点

兵种刷新时，都得先询问寻路系统，出生位置是否已经有（带碰撞的兵种，通常为陆军）或者建筑 ， 
将出生位置同步网格
*/
using GameLog;
using Godot;
using System;
using System.Collections.Generic;
namespace Remnant_Afterglow
{
    public class GridNode
    {
        /// <summary>
        /// 位置x
        /// </summary>
        public int x;
        /// <summary>
        /// 位置y
        /// </summary>
        public int y;
        /// <summary>
        /// cfg_MapPassType_地图可通过类型 的id
        /// </summary>
        public int PassTypeId;
        /// <summary>
        /// 基础代价，场景中可能会有多种地形，例如水泥地、沼泽地等等
        /// </summary>
        public int cost;
        /// <summary>
        /// 最终代价 fCost是指节点到目标节点的最终代价
        /// </summary>
        public int fCost;
        /// <summary>
        /// 矢量
        /// </summary>
        public Vector2 direction;
        /// <summary>
        /// 是否可以通行
        /// </summary>
        public bool isWalkable;
        /// <summary>
        /// 占据类型
        /// </summary>
        public BaseObjectType ObjectType;
        /// <summary>
        /// 默认是否可通行，仅计算地图,单位建筑等不影响该参数
        /// </summary>
        public bool DefineIsWalkable;

        public GridNode(int x, int y, int PassTypeId, int cost, bool isWalkable, BaseObjectType ObjectType)
        {
            this.x = x;
            this.y = y;
            this.isWalkable = isWalkable;
            this.DefineIsWalkable = isWalkable;
            cost = isWalkable ? 10 : int.MaxValue;
            fCost = int.MaxValue;
            this.ObjectType = ObjectType;
        }
    }

    //导航系统-暂时仅陆军使用
    public class NavigationSystem
    {
        //横
        public readonly int Width;
        //纵
        public readonly int Height;
        /// <summary>
        /// 键是x*y  key%x 是横轴x  key/y 是纵轴y
        /// </summary>
        Dictionary<int, GridNode> nodesDic = new Dictionary<int, GridNode>();

        Dictionary<int, List<Vector2I>> BrushPointDict = new Dictionary<int, List<Vector2I>>();

        /// <summary>
        /// 当前地图时间 单位秒
        /// </summary>
        public double nowTime = 0;
        /// <summary>
        /// 当前地图帧数 单位帧
        /// </summary>
        public double frameNumber = 0;
        /// <summary>
        /// 导航系统
        /// </summary>
        /// <param name="x"></param>
        /// <param name="y"></param>
        /// <param name="layer"></param>
        public NavigationSystem(int Width, int Height, Cell[,] layer, Dictionary<int, CopyBrushData> brushDataDict)
        {
            this.Width = Width;
            this.Height = Height;
            for (int i = 0; i < layer.GetLength(0); i++)
            {
                for (int j = 0; j < layer.GetLength(1); j++)
                {
                    int index = i + Width * j;
                    nodesDic[index] = layer[i, j].GetGridNode();
                }
            }
            foreach (var brush in brushDataDict)
            {
                List<Vector2I> list = brush.Value.GetBrushAllList();
                List<Vector2I> list2 = new List<Vector2I>();

                for (int i = 0; i < list.Count; i++)
                {
                    int index = list[i].X + Width * list[i].Y;
                    if (nodesDic[index].isWalkable)
                    {
                        list2.Add(list[i]);
                    }
                }
                Log.PrintList(list2);
                BrushPointDict[brush.Key] = list2;
            }
        }


        public void Update(double delta)
        {
            //时间及帧数计数
            nowTime += delta;
            frameNumber += 1;
        }


        /// <summary>
        /// 修改导航节点数据
        /// </summary>
        /// <param name="x"></param>
        /// <param name="y"></param>
        /// <param name="node"></param>
        public void UpdataGridNode(int x, int y, GridNode node)
        {
            int index = x + Width * y;
            nodesDic[index] = node;
        }

        /// <summary>
        /// 修改导航节点数据
        /// </summary>
        /// <param name="x"></param>
        /// <param name="y"></param>
        /// <param name="node"></param>
        public void UpdateGridNodeObject(int x, int y, BaseObjectType ObjectType)///祝福注释
        {
            int index = x + Width * y;
            nodesDic[index].ObjectType = ObjectType;
            switch (ObjectType)
            {
                case BaseObjectType.BaseUnit://如果是修改为单位占据，设置为不可通行
                    nodesDic[index].isWalkable = false;
                    break;
                case BaseObjectType.BaseFloor://如果是修改回地块占据，则设置为原默认通行
                    nodesDic[index].isWalkable = nodesDic[index].DefineIsWalkable;
                    break;
                default: break;
            }
        }

        /// <summary>
        /// 创建单位时，在对应刷新点中，寻找一个可以放置的位置
        /// </summary>
        /// <returns></returns>
        public Vector2I CreateUnitPos(int brush_id)
        {
            List<Vector2I> pos_list = BrushPointDict[brush_id];
            if (pos_list.Count > 0)
            {
                Random random = new Random();
                int id = random.Next(0, pos_list.Count - 1);
                Vector2I pos = pos_list[id];
                UpdateGridNodeObject(pos.X, pos.Y, BaseObjectType.BaseUnit);
                return pos;
            }
            else
            {
                return new Vector2I(-1, -1);
            }
        }




        /// <summary>
        /// 生成流场
        /// </summary>
        public void GenerateFlowField(int nx, int ny)
        {
            GridNode target = nodesDic[nx + Width * ny];
            foreach (var node in nodesDic.Values)
            {
                List<GridNode> neighbourNodes = GetNeighbouringNodes(node);
                int fCost = node.fCost;
                GridNode temp = null;
                for (int i = 0; i < neighbourNodes.Count; i++)
                {
                    GridNode neighbourNode = neighbourNodes[i];
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
        /// 生成流场
        /// </summary>
        public void GenerateFlowField(GridNode target)
        {
            foreach (var node in nodesDic.Values)
            {
                List<GridNode> neighbourNodes = GetNeighbouringNodes(node);
                int fCost = node.fCost;
                GridNode temp = null;
                for (int i = 0; i < neighbourNodes.Count; i++)
                {
                    GridNode neighbourNode = neighbourNodes[i];
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
        /// <param name="target"></param>
        public void SetTarget(GridNode target)
        {
            foreach (var node in nodesDic.Values)
            {
                node.cost = node.isWalkable ? 10 : int.MaxValue;
                node.fCost = int.MaxValue;
            }
            target.cost = 0;
            target.fCost = 0;
            target.direction = Vector2.Zero;
            Queue<GridNode> queue = new Queue<GridNode>();
            queue.Enqueue(target);
            while (queue.Count > 0)
            {
                GridNode currentNode = queue.Dequeue();
                List<GridNode> neighbourNodes = GetNeighbouringNodes(currentNode);
                for (int i = 0; i < neighbourNodes.Count; i++)
                {
                    GridNode neighbourNode = neighbourNodes[i];
                    if (neighbourNode.cost == int.MaxValue) continue;
                    neighbourNode.cost = CalculateCost(neighbourNode, currentNode);
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
        public List<GridNode> GetNeighbouringNodes(GridNode node)
        {
            List<GridNode> neighbours = new List<GridNode>();
            for (int i = -1; i <= 1; i++)
            {
                for (int j = -1; j <= 1; j++)
                {
                    if (i == 0 && j == 0) continue;
                    int x = node.x + i;
                    int y = node.y + j;
                    if (x >= 0 && x < this.Width && y >= 0 && y < this.Height)
                        neighbours.Add(nodesDic[y * this.Width + x]);
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
        private int CalculateCost(GridNode node1, GridNode node2)
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
            return 14 * (deltaX > deltaY ? deltaY : deltaX) + 10 * delta;
        }
    }
}