
using GameLog;

namespace Remnant_Afterglow
{
    public struct Cell
    {
        public int x;
        public int y;
        public int index;//材料序号
        public int PassTypeId;//可通过类型
        public int MapImageId;//图像集序号，MapImageSet中CfgDataList的序号
        public int MapImageIndex;//图集内序号
        public Cell(int x, int y, int index, int PassTypeId, int MapImageId, int MapImageIndex)
        {
            this.x = x;
            this.y = y;
            this.index = index;
            this.PassTypeId = PassTypeId;
            this.MapImageId = MapImageId;
            this.MapImageIndex = MapImageIndex;
        }

        public static bool operator ==(Cell c1, Cell c2)
        {
            return c1.index == c2.index;
        }

        public static bool operator !=(Cell c1, Cell c2)
        {
            return !(c1 == c2);
        }

        /// <summary>
        /// 根据地图格子直接创建导航格子数据
        /// </summary>
        /// <returns>GridNode</returns>
        public GridNode GetGridNode()
        {
            MapPassType passType = ConfigCache.GetMapPassType(PassTypeId);
            return new GridNode(x, y, PassTypeId, passType.PassCost, passType.IsPass, BaseObjectType.BaseFloor);
        }

        public override string ToString()
        {
            return "X:" + x + "  Y:" + y + "  index:" + index + "  PassTypeId:" + PassTypeId;
        }

        public override bool Equals(object obj)
        {
            Cell other = (Cell)obj;
            return other.x == x && other.y == y && other.index == index;
        }
    }
}
