using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 常规地图区域
    /// </summary>
    public class MapRegion : BaseRegion
    {
        /// <summary>
        /// 区域内所有坐标
        /// </summary>
        public List<Cell> tiles = new List<Cell>();
        public List<Cell> edgeTiles = new List<Cell>();

        /// <summary>
        /// 创建区域
        /// </summary>
        /// <param name="roomTiles">列表数据</param>
        /// <param name="map">地图数据</param>
        public MapRegion(List<Cell> roomTiles, Cell[,] map)
        {
            data_id = IdGenerator.Generate(IdConstant.ID_TYPE_REGION);
            tiles = roomTiles;
            UpdateEdgeTiles(map);
        }

        /// <summary>
        /// 更新区域边缘瓦片集
        /// </summary>
        /// <param name="map"></param>
        public void UpdateEdgeTiles(Cell[,] map)
        {
            edgeTiles.Clear();
            foreach (Cell tile in tiles)
            {
                for (int i = 0; i < 4; i++)
                {
                    int x = tile.x + MapConstant.Vector2_Dir[i].X;
                    int y = tile.y + MapConstant.Vector2_Dir[i].Y;
                    if (map[x, y] == MapGenerate.WallMaterial.GetCell() && !edgeTiles.Contains(tile))
                    {
                        edgeTiles.Add(tile);
                    }
                }
            }
        }

    }
}
