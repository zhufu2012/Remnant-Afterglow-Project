using GameLog;
using Godot;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 科技树网格
    /// </summary>
    public partial class ScienceTreeControl : Control
    {
        /// <summary>
        /// 科技树显示配置字典<科技id,科技显示配置>
        /// </summary>
        Dictionary<int, ScienceBase> ScienceBaseDict = new Dictionary<int, ScienceBase>();
        //节点网格
        List<List<TreeNode>> NodeList = new List<List<TreeNode>>();
        //节点字典<科技id,节点>
        Dictionary<int, TreeNode> TreeNodeDict = new Dictionary<int, TreeNode>();

        PackedScene treeNodeScene = null;

        /// <summary>
        /// 科技范围
        /// </summary>
        ScienceRange range;
        public ScienceTreeControl(ScienceRange range, List<ScienceBase> scienceBases)
        {
            this.range = range;
            int max_x = 0;
            int max_y = 0;
            foreach (ScienceBase item in scienceBases)
            {
                ScienceBaseDict[item.ScienceId] = item;
                if (item.Pos.X >= max_x)
                    max_x = item.Pos.X + 1;
                if (item.Pos.Y >= max_y)
                    max_y = item.Pos.Y + 1;
            }
            for (int i = 0; i < max_x; i++)
            {
                List<TreeNode> temp = new List<TreeNode>();
                for (int j = 0; j < max_y; j++)
                {
                    TreeNode treeNode = new TreeNode(new Vector2I(i, j));
                    temp.Add(treeNode);
                }
                NodeList.Add(temp);
            }


            foreach (ScienceBase item in scienceBases)
            {

                NodeList[item.Pos.X][item.Pos.Y] = new TreeNode(range, item, item.Pos, true);

            }

            foreach (ScienceBase item in scienceBases)
            {
                TreeNodeDict[item.ScienceId] = NodeList[item.Pos.X][item.Pos.Y];
            }
            foreach (ScienceBase item in scienceBases)
            {
                List<TreeNode> treeNodeList = new List<TreeNode>();
                for (int i = 0; i < item.ConnectList.Count; i++)
                {
                    treeNodeList.Add(TreeNodeDict[item.ConnectList[i]]);
                }
                NodeList[item.Pos.X][item.Pos.Y].Children = treeNodeList;
            }

        }

        public override void _Ready()
        {
            treeNodeScene = GD.Load<PackedScene>("res://src/core/ui/view/science_tree/ScienceTreeNode.tscn");
            InitView();
            DrawConnections();
        }

        /// <summary>
        /// 初始化设置节点位置
        /// </summary>
        public void InitView()
        {
            int nodeSizeX = range.NodeSize.X;//节点大小-横轴
            int nodeSizeY = range.NodeSize.Y;//节点大小-纵轴
            Vector2I offset = range.Offset;//节点统一位置偏移
            Vector2I interval = range.Interval;//节点间间隙
            // 遍历外层列表
            for (int i = 0; i < NodeList.Count; i++)
            {
                List<TreeNode> itemList = NodeList[i];
                // 遍历内层列表
                for (int j = 0; j < itemList.Count; j++)
                {
                    ScienceTreeNode item = (ScienceTreeNode)treeNodeScene.Instantiate();
                    if (itemList[j].isShow)
                    {
                        item.IniData(itemList[j]);
                        item.Position = GetPos(item.scienceBase.Pos);
                        AddChild(item);
                    }
                }
            }
        }

        /// <summary>
        /// 绘制节点之间的连线
        /// </summary>
        private void DrawConnections()
        {
            foreach (var nodeList in NodeList)
            {
                foreach (var node in nodeList)
                {
                    if (node.Children.Count > 0)
                    {
                        foreach (var child in node.Children)
                        {
                            Line2D line = new Line2D();
                            line.DefaultColor = Colors.White; // 设置线条颜色
                            line.Width = 2; // 设置线条宽度
                            line.Points = CalculateHVPathAvoidingNodes(node, child);
                            AddChild(line);
                        }
                    }
                }
            }
        }

        /// <summary>
        /// 将网格坐标转换为现实坐标
        /// </summary>
        /// <returns></returns>
        public Vector2I GetPos(Vector2I pos)
        {
            Vector2I vec = new Vector2I(pos.X * (range.NodeSize.X + range.Interval.X) - range.NodeSize.X, pos.Y * (range.NodeSize.Y + range.Interval.Y) - range.NodeSize.Y);
            return range.Offset + vec;
        }


        private Vector2[] CalculateHVPathAvoidingNodes(TreeNode startNode, TreeNode endNode)
        {
            // 计算节点中心点
            Vector2I startCenter = new Vector2I((int)(startNode.Position.X + range.NodeSize.X / 2), (int)(startNode.Position.Y + range.NodeSize.Y / 2));
            Vector2I endCenter = new Vector2I((int)(endNode.Position.X + range.NodeSize.X / 2), (int)(endNode.Position.Y + range.NodeSize.Y / 2));
            Vector2I startPos = startNode.Pos;
            Vector2I endPos = endNode.Pos;
            // 创建路径点列表
            List<Vector2I> pathPoints = new List<Vector2I>
            {
                new Vector2I(startPos.X, startPos.Y) // 添加起始点
            };
            // 如果不在同一行，则首先垂直移动
            if (startPos.Y != endPos.Y)
            {
                pathPoints.Add(new Vector2I(startPos.X, endPos.Y));
            }
            // 添加结束点
            pathPoints.Add(new Vector2I(endPos.X, endPos.Y));
            Vector2[] vector2s = new Vector2[pathPoints.Count];
            for (int i = 0; i < pathPoints.Count; i++)
            {
                Vector2I pos = GetPos(pathPoints[i]);
                vector2s[i] = pos + new Vector2I(range.NodeSize.X / 2, range.NodeSize.Y / 2);
            }
            return vector2s;
        }
    }
}
