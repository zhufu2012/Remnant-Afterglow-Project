
using Godot;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 实体动画 处理
    /// </summary>
    public partial class BaseObject : Area2D, IPoolItem
    {
        /// <summary>
        /// 设置节点整体颜色
        /// </summary>
        public void SetNodeColor(Color color)
        {
            Modulate = color;
        }

    }
}
