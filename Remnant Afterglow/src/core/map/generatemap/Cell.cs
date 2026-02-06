
using GameLog;
using Godot;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 地图格子
    /// </summary>
    public struct Cell
    {
        public int x;
        public int y;
        /// <summary>
        /// 材料序号 MaterialId
        /// </summary>
        public int index;
        /// <summary>
        /// 可通过类型
        /// </summary>
        public int PassTypeId;
        /// <summary>
        /// 图像集序号，MapImageSet中CfgDataList的序号
        /// </summary>
        public int MapImageId;
        /// <summary>
        /// 图集内序号
        /// </summary>
        public int MapImageIndex;
        /// <summary>
        /// 瓦片在图集中的位置
        /// </summary>
        public Vector2I ImagePos;
        public Cell()
        {
            index = 0;
        }

        public Cell(int x, int y, int index, int PassTypeId, int MapImageId, int MapImageIndex)
        {
            this.x = x;
            this.y = y;
            this.index = index;
            this.PassTypeId = PassTypeId;
            this.MapImageId = MapImageId;
            this.MapImageIndex = MapImageIndex;
            ImagePos = LoadTileSetConfig.GetImageIndex_TO_Vector2(MapImageId, MapImageIndex);
        }

        public Cell(int x, int y, int index, int PassTypeId, int MapImageId, int MapImageIndex,Vector2I ImagePos)
        {
            this.x = x;
            this.y = y;
            this.index = index;
            this.PassTypeId = PassTypeId;
            this.MapImageId = MapImageId;
            this.MapImageIndex = MapImageIndex;
            this.ImagePos = ImagePos;
        }

        /// <summary>
        /// 相同的材料数据，让绘制的图等不同
        /// </summary>
        /// <param name="MapImageId">图集id</param>
        /// <param name="MapImageIndex">图内序号</param>
        public void SetImagePos(int MapImageId,int MapImageIndex)
        {
            this.MapImageId = MapImageId;
            this.MapImageIndex = MapImageIndex;
            ImagePos = LoadTileSetConfig.GetImageIndex_TO_Vector2(MapImageId, MapImageIndex);
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
        public FlowFieldNode GetGridNode()
        {
            MapPassType passType = ConfigCache.GetMapPassType(PassTypeId);
            return new FlowFieldNode(x, y, index, PassTypeId, passType.PassCost, passType.IsPass);
        }

        /// <summary>
        /// 获取地图材料
        /// </summary>
        /// <returns></returns>
        public MapFixedMaterial GetMapFixedMaterial()
        {
            return ConfigCache.GetMapFixedMaterial(index);
        }

        public override string ToString()
        {
            return "X:" + x + "  Y:" + y + "  index:" + index + "  PassTypeId:" + PassTypeId;
        }

        public override bool Equals(object obj)
        {
            if (obj is Cell other)
            {
                 return other.x == x && other.y == y && other.index == index;
            }
            return false;
        }

        public bool TerrainEquals(object obj)
        {
            if (obj is Cell other)
            {
                return other.index == index;
            }
            return false;
        }
    }
}
