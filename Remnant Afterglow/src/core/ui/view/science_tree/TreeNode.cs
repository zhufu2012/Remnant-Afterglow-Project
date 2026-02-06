using GameLog;
using Godot;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 网格节点-祝福注释节点还得改成场景加载然后代码生存
    /// </summary>
    public partial class TreeNode : Control
    {
        /// <summary>
        /// 科技范围
        /// </summary>
        public ScienceRange range;
        /// <summary>
        /// 科技显示配置
        /// </summary>
        public ScienceBase scienceBase;
        /// <summary>
        /// 子节点列表
        /// </summary>
        public List<TreeNode> Children = new List<TreeNode>();
        /// <summary>
        /// 是否显示为科技节点
        /// </summary>
        public bool isShow = false;

        /// <summary>
        /// 节点位置
        /// </summary>
        public Vector2I Pos;

        public TreeNode(Vector2I Pos)
        {
            this.Pos = Pos;
        }
        public TreeNode(ScienceRange range, ScienceBase scienceBase, Vector2I Pos, bool isShow)
        {
            this.range = range;
            this.scienceBase = scienceBase;
            this.Pos = Pos;
            this.isShow = isShow;
        }

    }
}