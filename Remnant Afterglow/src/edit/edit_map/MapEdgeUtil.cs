using System.Linq;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    //对边缘连接处的9宫格处理
    public class MapEdgeUtil
    {
        //边缘连接数据<材料id,<边缘类型,类>>
        public Dictionary<int, Dictionary<int,MapEdge>> edgeDict = new Dictionary<int, Dictionary<int,MapEdge>>();
        int Width;
        int Height;

        public MapEdgeUtil(int Width,int Height)
        {
            this.Width = Width;
            this.Height = Height;
            List<MapEdge> edges = ConfigCache.GetAllMapEdge();
            edgeDict = edges.GroupBy(edge => edge.MaterialId)
                .ToDictionary(
                    group => group.Key,
                    group => group.ToDictionary(edge => edge.EdgeId, edge => edge)
                );
        }

        /*public void UpdateWalls()
        {
            for (int x = 0; x < Width; x++)
            {
                for (int y = 0; y < Height; y++)
                {
                    if (map[x, y] == WallMaterial.GetCell())
                    {
                        int mask = 0;

                        if (IsWall(x, y - 1)) mask |= 1; // 上
                        if (IsWall(x + 1, y)) mask |= 2; // 右
                        if (IsWall(x, y + 1)) mask |= 4; // 下
                        if (IsWall(x - 1, y)) mask |= 8; // 左

                        map[x, y] = GetWallTile(mask);
                    }
                }
            }
        }

        private bool IsWall(int x, int y)
        {
            return x >= 0 && x < Width && y >= 0 && y < Height && map[x, y] == WallMaterial.GetCell();
        }

        private Tile GetWallTile(int mask)
        {
            switch (mask)
            {
                case 0: return WallMaterial.GetTile("孤立墙");  // 0000
                case 1: return WallMaterial.GetTile("下端墙");  // 0001
                case 2: return WallMaterial.GetTile("左端墙");  // 0010
                case 3: return WallMaterial.GetTile("左下角");  // 0011
                case 4: return WallMaterial.GetTile("上端墙");  // 0100
                case 5: return WallMaterial.GetTile("上下端墙"); // 0101
                case 6: return WallMaterial.GetTile("左上角");  // 0110
                case 7: return WallMaterial.GetTile("左上角下端墙"); // 0111
                case 8: return WallMaterial.GetTile("右端墙");  // 1000
                case 9: return WallMaterial.GetTile("右下角");  // 1001
                case 10: return WallMaterial.GetTile("左右端墙"); // 1010
                case 11: return WallMaterial.GetTile("左右下端墙"); // 1011
                case 12: return WallMaterial.GetTile("右上角");  // 1100
                case 13: return WallMaterial.GetTile("右上角下端墙"); // 1101
                case 14: return WallMaterial.GetTile("左右上端墙"); // 1110
                case 15: return WallMaterial.GetTile("四端墙");  // 1111
                default: return WallMaterial.GetTile("孤立墙");  // 默认情况
            }
        }
        */
    }
}