using GameLog;
using Godot;
using System;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 地图生成器
    /// 性能优化方案
    /// 1.遍历时，先计算不需要处理的边框部分，这部分遍历时可以跳过，这明显会降低性能消耗
    /// </summary>
    public class MapGenerate
    {
        #region 参数及初始化
        /// <summary>
        /// 生成方式id
        /// </summary>
        public int GenerateMapId;
        /// <summary>
        /// 生成方式名称
        /// </summary>
        public string GenerateMapName;
        /// <summary>
        /// 生成地图的横轴长度
        /// </summary>
        public int Width;
        /// <summary>
        /// 生成地图的纵轴长度
        /// </summary>
        public int Height;
        /// <summary>
        /// 是否需要有边界墙壁
        /// </summary>
        public bool IsNeedWall;
        /// <summary>
        /// 墙壁厚度
        /// </summary>
        public int WallThickness;

        /// <summary>
        /// 默认材料
        /// </summary>
        public static MapMaterial DefaultMaterial;
        /// <summary>
        /// 墙壁材料
        /// </summary>
        public static MapMaterial WallMaterial;
        /// <summary>
        /// 通道材料
        /// </summary>
        public static MapMaterial PassMaterial;

        /// <summary>
        /// 生成密度是否反向判断
        /// </summary>
        public bool IsDensityContrary;
        /// <summary>
        /// 生成密度
        /// </summary>
        public int Density;

        public List<List<int>> WallParamList;

        /// <summary>
        /// 是否清除小尺寸墙壁
        /// </summary>
        public bool IsClearWall;
        /// <summary>
        /// 是否清除小尺寸空地
        /// </summary>
        public bool IsClearDefine;
        /// <summary>
        /// 墙壁区域最小尺寸小于这个尺寸就清除
        /// </summary>
        public int MinWallMeasure;

        /// <summary>
        /// 默认区域最小尺寸小于这个尺寸就清除
        /// </summary>
        public int MinDefineMeasure;

        /// <summary>
        /// 是否绘制通道
        /// </summary>
        public bool IsDrawPass;
        /// <summary>
        /// 生成的通道宽度
        /// </summary>
        public int PassWidth;

        /// <summary>
        /// 是否使用 噪声编辑器的数据
        /// </summary>
        public bool IsUseNoiseEdit;

        ///种子数据
        public MapSeedType Seed;
        /// <summary>
        /// 地图大型结构id列表
        /// </summary>
        public List<MapBigStructData> BigStructIdList = new List<MapBigStructData>();

        ///地板层的数据
        Cell[,] map;

        /// 其他装饰层的数据
        Dictionary<int, Cell[,]> mapLayer = new Dictionary<int, Cell[,]>();

        /// <summary>
        /// 区域数据
        /// </summary>
        public List<BaseRegion> roomList = new List<BaseRegion>();

        /// <summary>
        /// 大结构数据
        /// </summary>
        public List<MapBigStruct> BigStructList = new List<MapBigStruct>();
        /// <summary>
        /// 额外绘制数据
        /// </summary>
        public List<MapExtraDraw> ExtraDrawList = new List<MapExtraDraw>();
        /// <summary>
        /// 装饰层数据
        /// </summary>
        public List<MapAdornData> AdornDataList = new List<MapAdornData>();

        Bitmap mapFlags = new Bitmap();

        //常用格子数据
        Cell wallCell;
        Cell defaultCell;
        Cell passCell;

        public MapGenerate(int id)
        {
            GenerateMapId = id;
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_GenerateBottomMap, id);
            GenerateMapName = (string)dict["GenerateMapName"];
            Width = (int)dict["Width"];
            Height = (int)dict["Height"];
            IsNeedWall = (bool)dict["IsNeedWall"];
            WallThickness = IsNeedWall ? (int)dict["WallThickness"] : 0;//墙壁厚度
            WallMaterial = new MapMaterial((int)dict["WallMaterialId"]);//墙壁材料
            DefaultMaterial = new MapMaterial((int)dict["DefaultMaterialId"]);//空地材料
            PassMaterial = new MapMaterial((int)dict["PassMaterialId"]);//通道材料
            Seed = new MapSeedType((int)dict["SeedTypeId"]);
            IsDensityContrary = (bool)dict["IsDensityContrary"];
            Density = (int)dict["Density"];
            WallParamList = (List<List<int>>)dict["WallParamList"];//光滑参数列表
            IsClearWall = (bool)dict["IsClearWall"];
            IsClearDefine = (bool)dict["IsClearDefine"];
            MinWallMeasure = (int)dict["MinWallMeasure"];
            MinDefineMeasure = (int)dict["MinDefineMeasure"];
            PassWidth = (int)dict["PassWidth"];
            IsDrawPass = (bool)dict["IsDrawPass"];
            List<int> list = (List<int>)dict["BigStructIdList"];//大结构
            for (int i = 0; i < list.Count; i++)
                BigStructIdList.Add(new MapBigStructData(list[i]));
            List<int> list2 = (List<int>)dict["ExtraDrawIdList"];//额外绘制
            for (int i = 0; i < list2.Count; i++)
                ExtraDrawList.Add(new MapExtraDraw(list2[i], Width, Height));

            List<int> list3 = (List<int>)dict["AdornLayerIdList"];//装饰层
            for (int i = 0; i < list3.Count; i++)
                AdornDataList.Add(new MapAdornData(list3[i]));
            wallCell = WallMaterial.GetCell();
            defaultCell = DefaultMaterial.GetCell();
            passCell = PassMaterial.GetCell();
        }
        #endregion


        #region 生成地图
        /// <summary>
        /// 生成地图
		/// map默认为0层的数据
        /// </summary>
        /// <returns></returns>
        public Dictionary<int, Cell[,]> GenerateMap(FastNoiseLite noise, Vector2 Size)
        {
            map = new Cell[Width, Height];//初始化底层地块地图
            mapLayer.Clear();//装饰层清理
            roomList.Clear();//区域清理
            BigStructList.Clear();//当前生成结构清理
            if (IsUseNoiseEdit)//使用噪声编辑器的噪声数据
                RandomMap(noise, Size);//填充地块地图
            else
                RandomMap(Seed.noise.noise, new Vector2(Seed.noise.x, Seed.noise.y));//填充地块地图
            SmoothMap();//对地块地图进行光滑处理
            EliminateSmallHoleWall();//清除小洞，小墙，计算满足条件的区域

            if (IsDrawPass)
                ConnectAllRoomToMainroom();//连接各区域
                                           //GenerateDijkstraMap(new Vector2I(Width / 2, Height / 2));
            ExtraDraw();//额外绘制
            DrawBigStruct(BigStructIdList, false);//绘制大结构
            DrawAdornLayer();//绘制装饰层

            mapLayer[1] = map;
            return mapLayer;
        }

        /// <summary>
        /// 生成随机地图
        /// </summary>
        private void RandomMap(FastNoiseLite noise, Vector2 Size)
        {
            float ProX = Size.X / Width;
            float ProY = Size.Y / Height;
            if (Size.X == 0 && Size.Y == 0)
            {
                ProX = 1;
                ProY = 1;
            }
            for (int x = 0; x < Width; x++)
            {
                for (int y = 0; y < Height; y++)
                {
                    // 首先处理边界条件，直接生成墙壁
                    if (IsBorderTile(x, y))
                    {
                        map[x, y] = WallMaterial.GetCell(x, y);
                        continue; // 处理完边界后跳过剩余判断
                    }
                    float noise_value = (noise.GetNoise2D(x * ProX, y * ProY) + 1) * 500000.0f;
                    // 对于非边界区域，根据密度随机决定是否生成墙壁
                    map[x, y] = ((IsDensityContrary && (noise_value <= Density)) || (!IsDensityContrary && (noise_value > Density)))
                        ? WallMaterial.GetCell(x, y) : DefaultMaterial.GetCell(x, y);
                }
            }
        }

        /// <summary>
        /// 平滑地图
        /// </summary>
        private void SmoothMap()
        {
            Cell[,] temp = (Cell[,])map.Clone(); // 使用Clone快速复制现有地图
            foreach (List<int> WallParam in WallParamList)
            {
                for (int x = 0; x < Width; x++)
                {
                    for (int y = 0; y < Height; y++)
                    {
                        if (!IsBorderTile(x, y))
                        {
                            int wallTilesCount = GetSurroundCount(x, y, wallCell, WallParam[0]);
                            temp[x, y] = wallTilesCount < WallParam[1]
                                ? DefaultMaterial.GetCell(x, y)
                                : wallTilesCount > WallParam[1]
                                ? WallMaterial.GetCell(x, y)
                                 : map[x, y];
                        }
                    }
                }
            }
            map = temp;
        }
        #endregion

        #region 额外绘制地图
        /// <summary>
        /// 额外绘制地图
        /// </summary>
        public void ExtraDraw()
        {
            foreach (MapExtraDraw mapExtra in ExtraDrawList)
            {
                mapExtra.ExtraDraw(map);
            }
        }
        #endregion

        #region 生成地图大结构
        /// <summary>
        /// 绘制大结构
        /// </summary>
        public void DrawBigStruct(List<MapBigStructData> StructList, bool IsUseWall)
        {

            foreach (MapBigStructData structData in StructList)//遍历所有需要绘制的多图块结构
            {
                Cell[,] temp;
                int nowLayer = structData.Layer;
                if (nowLayer == MapLayer.FloorLayer1)//地板
                    temp = map;
                else
                {
                    if (mapLayer.ContainsKey(nowLayer))
                        temp = mapLayer[nowLayer];
                    else
                        temp = new Cell[Width, Height];
                }
                if (structData.GeneratBigType == 0)
                    RandDrawBigStruct(temp, structData, IsUseWall);//随机生成,遍历所有空的格子
                else if (structData.GeneratBigType == 1)
                    PosDrawBigStruct(nowLayer, temp, structData, IsUseWall);//固定生成

                if (nowLayer == MapLayer.FloorLayer1)//地板
                    map = temp;
                else
                    mapLayer[nowLayer] = temp;
            }
        }


        /// <summary>
        /// 随机绘制大结构
        /// </summary>
        /// <param name="temp"></param>
        /// <param name="structData"></param>
        /// <param name="IsUseWall">是否检查墙壁</param>
        public void RandDrawBigStruct(Cell[,] temp, MapBigStructData structData, bool IsUseWall)
        {
            Random random;
            if (structData.IsUserSeed)//使用固定种子
                random = new Random(structData.Seed);
            else
                random = new Random();
            for (int i = 0; i < Width; i++)
            {
                for (int j = 0; j < Height; j++)
                {
                    bool isWall = IsUseWall ? map[i, j] != wallCell : true;//是否检查地板的墙壁



                    if (isWall && !IsBorderTile(i, j) && structData.IsCreat(i, j, map, WallMaterial))//是否能创建
                    {
                        int ps = random.Next(0, 1000000);
                        if (ps <= structData.Probability)//当前位置是空地，并且
                        {
                            MapBigStruct bigStruct = new MapBigStruct(i, j, structData);
                            BigStructList.Add(bigStruct);
                            Cell[,] NowCel = bigStruct.NowCell;
                            for (int k = 0; k < bigStruct.SizeX; k++)
                            {
                                for (int l = 0; l < bigStruct.SizeY; l++)
                                {
                                    temp[k + i, l + j] = NowCel[k, l];
                                }
                            }
                        }
                    }
                }
            }

        }

        /// <summary>
        /// 固定位置生成大结构
        /// </summary>
        /// <param name="structData"></param>
        public void PosDrawBigStruct(int nowLayer, Cell[,] temp, MapBigStructData structData, bool IsUseWall)
        {
            List<Vector2I> PosList = structData.PosList;
            for (int i = 0; i < PosList.Count; i++)
            {
                Vector2I vpos = PosList[i];
                if (IsInBounds(vpos.X, vpos.Y))//检查是否在边界内，在边界内才绘制
                {
                    MapBigStruct bigStruct = new MapBigStruct(vpos.X, vpos.Y, structData);
                    Cell[,] NowCel = bigStruct.NowCell;
                    BigStructList.Add(bigStruct);
                    for (int k = 0; k < bigStruct.SizeX; k++)
                    {
                        for (int l = 0; l < bigStruct.SizeY; l++)
                        {
                            if (IsInBounds(vpos.X + k, vpos.Y + l))
                                temp[vpos.X + k, vpos.Y + l] = NowCel[k, l];
                        }
                    }
                }
            }
        }
        #endregion

        #region 绘制装饰层
        /// <summary>
        /// 绘制装饰层
        /// </summary>
        public void DrawAdornLayer()
        {
            foreach (MapAdornData adorn in AdornDataList)
            {
                int layer = adorn.Layer;//绘制层
                Cell[,] layer_map;
                foreach (var material in adorn.MaterialList)//各种需要生成的材料
                {
                    if (mapLayer.ContainsKey(layer))
                    {
                        layer_map = mapLayer[layer];
                    }
                    else
                    {
                        layer_map = new Cell[Width, Height];
                    }
                    for (int i = 0; i < Width; i++)
                    {
                        for (int j = 0; j < Height; j++)
                        {
                            if (map[i, j] == defaultCell)//是空地
                            {
                                float value = adorn.Seed.getNoiseValue(i, j);
                                if (value < material.Key)
                                {
                                    layer_map[i, j] = material.Value.GetCell(i, j);
                                }
                            }
                        }
                    }
                    mapLayer[layer] = layer_map;
                }
                DrawBigStruct(adorn.BigStructList, true);
            }
        }

        #endregion


        #region 区域操作
        /// <summary>
        /// 加工地图，清除小洞，小墙
        /// </summary>
        public void EliminateSmallHoleWall()
        {
            int currentIndex = 0;//当前索引
            int maxIndex = 0;//最大房间id,主房间
            int maxSize = 0;//最大房间的大小
            if (IsClearWall)
            {
                //获取墙区域
                List<List<Cell>> wallRegions = GetRegions(wallCell);
                foreach (List<Cell> wallRegion in wallRegions)
                {
                    if (wallRegion.Count < MinWallMeasure)//小于墙壁最小区域
                    {
                        foreach (Cell cell in wallRegion)
                        {
                            map[cell.x, cell.y] = DefaultMaterial.GetCell(cell.x, cell.y);
                        }
                    }
                }
            }


            //获取空地区域
            List<List<Cell>> roomRegions = GetRegions(defaultCell);
            foreach (List<Cell> roomRegion in roomRegions)
            {
                if (roomRegion.Count < MinDefineMeasure && IsClearDefine)//小于空地最小区域
                {
                    foreach (Cell cell in roomRegion)
                    {
                        int tile_x = cell.x;
                        int tile_y = cell.y;
                        map[tile_x, tile_y] = WallMaterial.GetCell(cell.x, cell.y);
                    }
                }
                else
                {
                    MapRegion sRoom = new MapRegion(roomRegion, map, Width);
                    roomList.Add(sRoom); //添加到幸存房间列表里
                    if (maxSize < roomRegion.Count)
                    {
                        maxSize = roomRegion.Count;
                        maxIndex = currentIndex;//找出最大房间的索引
                    }
                    currentIndex += 1;
                }
            }

            if (roomList.Count == 0)
            {
                Log.Print("没有区域！");
            }
            else
            {
                roomList[maxIndex].isMainRoom = true;
                roomList[maxIndex].isAccessibleFromMainRoom = true;
            }
        }

        /// <summary>
        /// 把所有房间都连接到主房间
        /// </summary>
        public void ConnectAllRoomToMainroom()
        {
            foreach (MapRegion room in roomList)
            {
                connectToClosestRoom(room);//遍历所有房间，确保这些房间至少和一个其他房间连接
            }
            int count = 0;

            foreach (MapRegion room in roomList)
            {
                if (room.isAccessibleFromMainRoom)
                {
                    count += 1;
                }
            }
            if (count != roomList.Count)
                ConnectAllRoomToMainroom();
        }

        /// <summary>
        /// 连接本房间与距离自己最近的一个与自己尚未连接的区域
        /// 可能找不到满足条件的待连接区域
        /// </summary>
        /// <param name="roomA"></param>
        public void connectToClosestRoom(MapRegion roomA)
        {
            int bestDistance = int.MaxValue;//最短距离
            Cell bestTileA = wallCell;//A区域连接点
            Cell bestTileB = wallCell;//B区域连接点
            MapRegion bestRoomB = null;
            foreach (MapRegion roomB in roomList)//遍历所有区域,查找最近连接
            {
                if (roomA == roomB || roomA.IsConnected(roomB))
                {
                    continue;
                }
                foreach (Cell tileA in roomA.edgeTiles)//遍历区域A的所有边
                {
                    foreach (Cell tileB in roomB.edgeTiles)//遍历区域B的所有边
                    {
                        var distanceBetweenRooms = (new Vector2(tileA.x, tileA.y) - new Vector2(tileB.x, tileB.y)).LengthSquared();
                        if (distanceBetweenRooms < bestDistance)
                        {
                            bestDistance = (int)distanceBetweenRooms;
                            bestTileA = tileA;
                            bestTileB = tileB;
                            bestRoomB = roomB;
                        }
                    }
                }
            }
            if (bestRoomB != null)
            {
                CreatePassage(roomA, bestRoomB, bestTileA, bestTileB);
            }
        }

        /// <summary>
        /// 创建两个房间的通道
        /// </summary>
        public void CreatePassage(MapRegion roomA, MapRegion roomB, Cell tileA, Cell tileB)
        {
            roomA.ConnectRooms(roomB, roomList);
            List<Cell> line = GetLine(tileA, tileB);
            foreach (Cell coord in line)
            {
                DrawCircle(coord, PassWidth);
            }
        }

        /// <summary>
        /// 绘制一个圆
        /// </summary>
        public void DrawCircle(Cell cell, int R)
        {
            for (int i = -R; i < R; i++)
            {
                for (int j = -R; j < R; j++)
                {
                    if (i * i + j * j <= R * R)
                    {
                        int drawX = cell.x + i;
                        int drawY = cell.y + j;
                        if (IsInBounds(drawX, drawY))
                        {
                            map[drawX, drawY] = PassMaterial.GetCell(drawX, drawY);
                        }
                    }
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
                x < WallThickness ||
                x >= Width - WallThickness ||
                y < WallThickness ||
                y >= Height - WallThickness;
        }

        /// <summary>
        /// 检查图块是否在边界内
        /// </summary>
        /// <param name="x"></param>
        /// <param name="y"></param>
        /// <returns></returns>
        private bool IsInBounds(int x, int y)
        {
            return x >= 0 && x < Width && y >= 0 && y < Height;
        }


        /// <summary>
        /// 获取图块相邻 同图块的数量
        /// </summary>
        /// <param name="x"></param>
        /// <param name="y"></param>
        /// <param name="radius"></param>
        /// <returns></returns>
        private int GetSurroundCount(int x, int y, Cell cell, int radius = 1)
        {
            int count = 0;
            for (int nY = y + radius; nY >= y - radius; nY--)
            {
                for (int nX = x + radius; nX >= x - radius; nX--)
                {
                    if (IsInBounds(nX, nY) && map[nX, nY] == cell)//图块在范围内，并且是要求的图块
                    {
                        if (nY == y && nX == x)
                        {
                            continue;
                        }
                        count += 1;
                    }
                }
            }
            return count;
        }

        /// <summary>
        /// 获取相邻图块
        /// </summary>
        /// <param name="cell"></param>
        /// <returns></returns>
        private List<Vector2I> GetNeighbours(Vector2I cell)
        {
            List<Vector2I> neighbours = new List<Vector2I>();
            neighbours.Add(new Vector2I(cell.X + 1, cell.Y));
            neighbours.Add(new Vector2I(cell.X - 1, cell.Y));
            neighbours.Add(new Vector2I(cell.X, cell.Y + 1));
            neighbours.Add(new Vector2I(cell.X, cell.Y - 1));
            return neighbours;
        }

        private void UpdateTilemapBasedOnDijkstraMap(int[,] dijkstraMap)
        {
            for (int x = 0; x < Width; x++)
            {
                for (int y = 0; y < Height; y++)
                {
                    if (dijkstraMap[x, y] == int.MaxValue && map[x, y] == defaultCell)
                    {
                        map[x, y] = WallMaterial.GetCell(x, y);
                    }
                }
            }
        }


        /// <summary>
        /// 获取对应材料所有区域
        /// </summary>
        /// <param name="tileType">材料类型</param>
        /// <returns></returns>
        public List<List<Cell>> GetRegions(Cell tileType)
        {
            List<List<Cell>> regions = new List<List<Cell>>();
            mapFlags = new Bitmap();
            mapFlags.Create(new Vector2I(Width, Height));
            for (int x = 0; x < Width; x++)
            {
                for (int y = 0; y < Height; y++)
                {
                    if (!IsBorderTile(x, y) && mapFlags.GetBit(x, y) == false && map[x, y] == tileType)
                    {
                        List<Cell> list = GetRegionTiles(x, y, tileType);
                        regions.Add(list);
                    }
                }
            }
            return regions;
        }

        public List<Cell> GetRegionTiles(int startX, int startY, Cell tileType)
        {
            List<Cell> tiles = new List<Cell>(64);
            Queue<Cell> queue1 = new Queue<Cell>();
            queue1.Enqueue(map[startX, startY]);
            int[] dx = { -1, 0, 1, 0, 0 }; // 上右下左中
            int[] dy = { 0, 1, 0, -1, 0 };
            while (queue1.Count > 0)
            {
                Cell tile = queue1.Dequeue();
                // 遍历上下左右中 五
                for (int i = 0; i < 5; i++)
                {
                    int newX = tile.x + dx[i];
                    int newY = tile.y + dy[i];
                    if (!IsBorderTile(newX, newY) && mapFlags.GetBit(newX, newY) == false && map[newX, newY] == tileType)
                    {
                        mapFlags.SetBit(newX, newY, true);
                        queue1.Enqueue(map[newX, newY]);
                        tiles.Add(map[newX, newY]);
                    }
                }
            }
            return tiles;
        }

        //构造直线
        public List<Cell> GetLine(Cell from, Cell to)
        {
            List<Cell> line = new List<Cell>();
            int from_x = from.x;
            int from_y = from.y;
            int to_x = to.x;
            int to_y = to.y;
            int dx = to_x - from_x;
            int dy = to_y - from_y;
            bool inverted = false;
            int step = Math.Sign(dx);
            int gradientStep = Math.Sign(dy);
            int longest = Math.Abs(dx);
            int shortest = Math.Abs(dy);
            if (longest < shortest)
            {
                inverted = true;
                longest = Math.Abs(dy);
                shortest = Math.Abs(dx);
                step = Math.Sign(dy);
                gradientStep = Math.Sign(dx);
            }

            int acc = 0;
            for (int i = 0; i < longest; i++)
            {
                line.Add(new Cell(from_x, from_y, defaultCell.index, defaultCell.PassTypeId, defaultCell.MapImageId, defaultCell.MapImageIndex));
                if (inverted)
                {
                    from_y += step;
                }
                else
                {
                    from_x += step;
                }

                acc += 2 * shortest; // 梯度每次增长为短边的长度
                if (acc >= longest)
                {
                    if (inverted)
                    {
                        from_x += gradientStep;
                    }
                    else
                    {
                        from_y += gradientStep;
                    }
                    acc -= 2 * longest;
                }
            }
            return line;
        }
        #endregion


        #region 暂时弃用方法
        /// <summary>
        /// 使用Dijkstras 处理地图,计算所有点到startPoint的最短长度，计算完成后，
        /// 如果还有点与startPoint的距离为int.MaxValue,说明这个点不可达，直接就变成墙 
        ///</summary>
        /// <param name="startPoint">起始点</param>
        public void GenerateDijkstraMap(Vector2I startPoint)
        {
            int[,] dijkstraMap = new int[Width, Height];
            for (int x = 0; x < Width; x++)
            {
                for (int y = 0; y < Height; y++)
                {
                    dijkstraMap[x, y] = int.MaxValue;
                }
            }
            dijkstraMap[startPoint.X, startPoint.Y] = 0;

            PriorityQueue<Vector2I, int> queue = new PriorityQueue<Vector2I, int>();
            queue.Enqueue(startPoint, 0);

            while (queue.Count > 0)
            {
                var current = queue.Dequeue();
                int currentDist = dijkstraMap[current.X, current.Y];
                List<Vector2I> neighbours = GetNeighbours(current);//这里可以性能优化，但这里用不到，就不写了

                foreach (var neighbour in neighbours)
                {
                    if (IsInBounds(neighbour.X, neighbour.Y) && map[neighbour.X, neighbour.Y] == defaultCell)
                    {//如果在边界范围内，并且是空地
                        int newDist = currentDist + 1;
                        if (newDist < dijkstraMap[neighbour.X, neighbour.Y])
                        {
                            dijkstraMap[neighbour.X, neighbour.Y] = newDist;
                            queue.Enqueue(neighbour, newDist);
                        }
                    }
                }
            }
            UpdateTilemapBasedOnDijkstraMap(dijkstraMap);
        }
        #endregion


    }
}