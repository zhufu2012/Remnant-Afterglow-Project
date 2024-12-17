
using Godot;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 流场节点
    /// </summary>
    public class FlowFieldNode
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
        /// cfg_MapMaterial_生成地图用材料 的id
        /// </summary>
        public int MaterialId;
        /// <summary>
        /// cfg_MapPassType_地图可通过类型 的id
        /// </summary>
        public int PassTypeId;
        /// <summary>
        /// 基础代价
        /// </summary>
        public float cost;
        /// <summary>
        /// 通行代价，场景中可能会有多种地形，例如水泥地、沼泽地等等,不可通行默认最大值
        /// </summary>
        public int pass_cost;
        /// <summary>
        /// 最终代价 fCost是指节点到目标节点的最终代价
        /// </summary>
        public float fCost;
        /// <summary>
        /// 流速向量-非真实矢量-真实单位矢量按照单位所处的上下左右四个节点的矢量 按权重计算
        /// </summary>
        public Vector2 direction;
        /// <summary>
        /// 是否可以通行
        /// </summary>
        public bool isWalkable;
        /// <summary>
        /// 其上占据的实体-默认为地板
        /// </summary>
        public BaseObjectType objectType = BaseObjectType.BaseFloor;
        public FlowFieldNode(int x, int y,int MaterialId, int PassTypeId, int cost, bool isWalkable)
        {
            this.x = x;
            this.y = y;
            this.MaterialId = MaterialId;
            this.PassTypeId = PassTypeId;
            this.isWalkable = isWalkable;
            this.cost = isWalkable ? cost : int.MaxValue;
            this.pass_cost = cost;
            fCost = int.MaxValue;
        }

        

    }
}