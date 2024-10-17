using Godot;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 结构数据
    /// </summary>
    public class MapBigStructData
    {
        /// <summary>
        /// 大结构id
        /// </summary>
        public int BigStructId;
        /// <summary>
		/// 大结构名称
		/// </summary>
        public string BigStructName;
        /// <summary>
		/// 绘制层
		/// </summary>
		public int Layer;
        /// <summary>
        /// 生成类型
        /// 0 随机生成
        /// 1 固定生成
        /// </summary>
        public int GeneratBigType;

        /// <summary>
        /// 是否使用固定种子
        /// </summary>
        public bool IsUserSeed;
        /// <summary>
        /// 固定种子
        /// </summary>
        public int Seed;

        /// <summary>
        /// 生成可能性
        /// </summary>
        public float Probability;
        /// <summary>
		/// 结构列表
		/// </summary>
        public Cell[,] BigCell;

        /// <summary>
        /// 固定生成位置列表 (X，Y)
		/// </summary>
		public List<Vector2I> PosList = new List<Vector2I>();

        public int Size_X;
        public int Size_Y;
        public MapBigStructData(int id)
        {
            BigStructId = id;
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_GenerateBigStruct, id);
            BigStructName = (string)dict["BigStructName"];
            Layer = (int)dict["Layer"];
            GeneratBigType = (int)dict["GeneratBigType"];
            IsUserSeed = (bool)dict["IsUserSeed"];
            Seed = (int)dict["Seed"];

            Probability = (float)dict["Probability"];
            List<int> Size = (List<int>)dict["Size"];
            Size_X = Size[0];
            Size_Y = Size[1];
            List<List<int>> list = (List<List<int>>)dict["StructList"];
            BigCell = new Cell[Size_X, Size_Y];
            for (int i = 0; i < list.Count; i++)
            {
                BigCell[list[i][0], list[i][1]] = new MapMaterial(list[i][2]).GetCell(list[i][0], list[i][1]);
            }
            List<List<int>> pos = (List<List<int>>)dict["PosList"];
            for (int i = 0; i < pos.Count; i++)
            {
                PosList.Add(new Vector2I(pos[i][0], pos[i][1]));
            }
        }

        /// <summary>
        /// 检查这个位置是否能放下该结构 注释-注意，如果有比绘制大结构更早的添加除墙体空地之外部分的代码，这里需要处理
        /// </summary>
        /// <param name="cell_x"></param>
        /// <param name="cell_y"></param>
        /// <param name="map"></param>
        /// <param name="wallmaterial"></param>
        /// <returns></returns>
        public bool IsCreat(int cell_x, int cell_y, Cell[,] map, MapMaterial wallmaterial)
        {
            for (int i = 0; i < Size_X; i++)
            {
                for (int j = 0; j < Size_Y; j++)
                {
                    if (map[i + cell_x, j + cell_y] == wallmaterial.GetCell() && BigCell[i, j] != new Cell())//当前位置是墙壁 并且当前位置材料不是默认参数
                        return false;
                }
            }
            return true;
        }
    }



    /// <summary>
    /// 结构类
    /// </summary>
    public class MapBigStruct
    {
        //现实结构位置数据	
        public Cell[,] NowCell;
        //结构位置X  左上角第一个点的X
        public int X;
        //结构位置Y  左上角第一个点的Y
        public int Y;

        public int SizeX;
        public int SizeY;

        public MapBigStruct(int x, int y, MapBigStructData data)
        {
            X = x;
            Y = y;
            SizeX = data.Size_X;
            SizeY = data.Size_Y;
            NowCell = new Cell[SizeX, SizeY];
            for (int i = 0; i < SizeX; i++)
            {
                for (int j = 0; j < SizeY; j++)
                {
                    Cell cell = data.BigCell[i, j];
                    cell.x = cell.x + X;
                    cell.y = cell.y + Y;
                    NowCell[i, j] = cell;
                }
            }
        }

        /// <summary>
        /// 对应的位置x y，是否在这个大结构内部
		/// 可以通过大结构本身的位置和 大小，先计算对应位置是否在大结构范围内，
		/// 再判断是否对应位置有格子
        /// </summary>
        /// <returns></returns>
        public bool IsInside(int cell_x, int cell_y)
        {
            if (cell_x >= X && cell_x <= X + SizeX && cell_y >= Y && cell_y <= Y + SizeY)
            {
                int cellX = cell_x - X;
                int cellY = cell_y - Y;
                if (NowCell[cellX, cellY] != null)
                {
                    return true;
                }
                return false;
            }
            else
            {
                return false;
            }
        }

        /// <summary>
        /// 获取对应的位置x y的格子
        /// </summary>
        /// <returns></returns>
        public Cell GetCell(int cell_x, int cell_y)
        {
            if (cell_x >= X && cell_x <= X + SizeX && cell_y >= Y && cell_y <= Y + SizeY)
            {
                int cellX = cell_x - X;
                int cellY = cell_y - Y;
                return NowCell[cellX, cellY];
            }
            else
            {
                return new Cell();
            }
        }

    }

}
