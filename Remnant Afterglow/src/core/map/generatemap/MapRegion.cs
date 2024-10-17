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

        public MapRegion(List<Cell> roomTiles, Cell[,] map, int Width)
        {
            data_id = IdGenerator.Generate(IdConstant.ID_TYPE_REGION);
            tiles = roomTiles;
            UpdateEdgeTiles(map, Width);
        }

        public void UpdateEdgeTiles(Cell[,] map, int Width)
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
