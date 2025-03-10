using Godot;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 大地图生成器
    /// </summary>
    public class BigMapGenerate
    {
        public BigMapBase cfgData;

        public BigMapGenerate(int id)
        {
            cfgData = new BigMapBase(id);
            WallMaterial = new BigMapMaterial(cfgData.WallMaterialId);
            DefaultMaterial = new BigMapMaterial(cfgData.DefaultNodeId);
            wallHex = WallMaterial.GetHex();
            defaultHex = DefaultMaterial.GetHex();
        }

        //地图参数，记住 q+r+s=0
        Hex[,] map;
        /// 其他装饰层的数据
        Dictionary<int, Hex[,]> mapLayer = new Dictionary<int, Hex[,]>();
        ///种子数据
        public MapSeedType Seed;

        //常用材料
        public BigMapMaterial WallMaterial;
        public BigMapMaterial DefaultMaterial;

        public Hex wallHex;//墙壁
        public Hex defaultHex;//空地

        #region 生成地图
        public Dictionary<int, Hex[,]> GenerateMap(Vector2 Size)
        {
            map = new Hex[cfgData.Width, cfgData.Height];//初始化底层地块地图
            mapLayer.Clear();//装饰层清理
            Seed = new MapSeedType(cfgData.SeedTypeId);
            RandomMap(Seed.noise.noise, new Vector2(Seed.noise.x, Seed.noise.y));//填充地块地图
            SmoothMap();
            CreatFixedtCell();

            mapLayer[1] = map;
            return mapLayer;
        }

        /// <summary>
        /// 生成随机地图
        /// </summary>
        private void RandomMap(FastNoiseLite noise, Vector2 Size)
        {
            float ProX = Size.X / cfgData.Width;
            float ProY = Size.Y / cfgData.Height;
            if (Size.X == 0 && Size.Y == 0)
            {
                ProX = 1;
                ProY = 1;
            }
            for (int x = 0; x < cfgData.Width; x++)
            {
                for (int y = 0; y < cfgData.Height; y++)
                {
                    // 首先处理边界条件，直接生成墙壁
                    if (IsBorderTile(x, y))
                    {
                        map[x, y] = WallMaterial.GetHex(x, y);
                        continue; // 处理完边界后跳过剩余判断
                    }
                    float noise_value = (noise.GetNoise2D(x * ProX, y * ProY) + 1) * 500000.0f;
                    // 对于非边界区域，根据密度随机决定是否生成墙壁
                    map[x, y] = ((cfgData.IsDensityContrary && (noise_value <= cfgData.Density)) || (!cfgData.IsDensityContrary && (noise_value > cfgData.Density)))
                        ? WallMaterial.GetHex(x, y) : DefaultMaterial.GetHex(x, y);
                }
            }
        }

        /// <summary>
        /// 平滑地图
        /// </summary>
        private void SmoothMap()
        {
            Hex[,] temp = (Hex[,])map.Clone(); // 使用Clone快速复制现有地图
            foreach (List<int> WallParam in cfgData.WallParamList)
            {
                for (int x = 0; x < cfgData.Width; x++)
                {
                    for (int y = 0; y < cfgData.Height; y++)
                    {
                        if (!IsBorderTile(x, y))
                        {
                            int wallTilesCount = GetSurroundCount(x, y, wallHex, WallParam[0]);
                            temp[x, y] = wallTilesCount < WallParam[1]
                                ? DefaultMaterial.GetHex(x, y)
                                : wallTilesCount > WallParam[1]
                                ? WallMaterial.GetHex(x, y)
                                 : map[x, y];
                        }
                    }
                }
            }
            map = temp;
        }


        /// <summary>
        /// 创建固定节点
        /// </summary>
        private void CreatFixedtCell()
        {
            for (int i = 0; i < cfgData.FixedtCellList.Count; i++)
            {
                List<int> FixedtCell = cfgData.FixedtCellList[i];
                BigMapMaterial bigMapMaterial = new BigMapMaterial(FixedtCell[0]);
                if (FixedtCell[1] == 1)
                {
                    map[FixedtCell[2], FixedtCell[3]] = bigMapMaterial.GetHex(FixedtCell[2], FixedtCell[3]);
                }
                else
                {
                    Hex[,] temp = mapLayer[FixedtCell[1]];
                    temp[FixedtCell[2], FixedtCell[3]] = bigMapMaterial.GetHex(FixedtCell[2], FixedtCell[3]);
                    mapLayer[FixedtCell[1]] = temp;
                }

            }
        }
        #endregion


        #region 工具函数
        /// <summary>
        /// 检查图块是否为边框图块
        /// </summary>
        /// <param name="x">x图块的x坐标</param>
        /// <param name="y">x图块的y坐标</param>
        /// <returns></returns>
        private bool IsBorderTile(int x, int y)
        {
            return
                x < cfgData.WallThickness ||
                x >= cfgData.Width - cfgData.WallThickness ||
                y < cfgData.WallThickness ||
                y >= cfgData.Height - cfgData.WallThickness;
        }

        /// <summary>
        /// 检查图块是否在边界内
        /// </summary>
        /// <param name="x"></param>
        /// <param name="y"></param>
        /// <returns></returns>
        private bool IsInBounds(int x, int y)
        {
            return x >= 0 && x < cfgData.Width && y >= 0 && y < cfgData.Height;
        }

        private bool IsInBounds(int q, int r, int s)
        {
            Vector2I pos = CubeToOffset(new Hex(q, r, s));
            return pos.X >= 0 && pos.X < cfgData.Width && pos.Y >= 0 && pos.Y < cfgData.Height;
        }

        /// <summary>
        /// 获取图块相邻 同图块的数量
        /// </summary>
        /// <param name="x"></param>
        /// <param name="y"></param>
        /// <param name="radius"></param>
        /// <returns></returns>
        private int GetSurroundCount(int x, int y, Hex cell, int radius = 1)
        {
            int count = 0;
            // 六个基本方向的增量
            int[,] directions = new int[6, 3]
            {
                { 1, -1, 0 }, // 右侧
                { 1, 0, -1 }, // 右下方
                { 0, 1, -1 }, // 左下方
                { -1, 1, 0 }, // 左侧
                { -1, 0, 1 }, // 左上方
                { 0, -1, 1 }  // 右上方
            };
            // 对于每一个方向，我们增加一个半径内的所有点
            for (int i = 0; i < 6; i++)
            {
                for (int j = 1; j <= radius; j++)
                {
                    int nx = x + directions[i, 0] * j;
                    int ny = y + directions[i, 1] * j;
                    int nz = -(nx + ny); // 因为 x + y + z = 0
                    if (IsInBounds(nx, ny, nz) && map[i, j] == cell)
                    {
                        count++;
                    }
                }
            }
            return count;
        }

        //转换为偏移坐标系
        public static Vector2I CubeToOffset(Hex hex)
        {
            int col = hex.q;
            int row = hex.r + (hex.q + (hex.q & 1)) / 2;
            return new Vector2I(col, row);
        }

        //偏移坐标系转换为立方体坐标系
        public static Hex OffsetToCube(Vector2I offset)
        {
            int q = offset.X;
            int r = offset.Y - (offset.X + (offset.X & 1)) / 2;
            int s = -q - r;
            return new Hex(q, r, s);
        }

        public static Hex OffsetToCube(int X, int Y)
        {
            int r = Y - (X + (X & 1)) / 2;
            int s = -X - r;
            return new Hex(X, r, s);
        }
        #endregion

    }
}