using GameLog;
using Godot;
using System.Collections.Generic;
using static Remnant_Afterglow.TerrainPeering;

namespace Remnant_Afterglow
{
    public class TileSetTerrainInfo
    {
        public const byte TerrainLayerType = 1;
        public const byte MiddleLayerType = 2;
        public const byte FloorLayerType = 3;

        /// <summary>
        /// 自动平铺地形 (47块/13块) type = 1
        /// </summary>
        public Dictionary<uint, int[]> T;



        /// <summary>
        /// 将地形掩码中的坐标转换为索引。
        /// 也就是 图片坐标 转换 为 index索引
        /// </summary>
        /// <param name="bitCoords">地形坐标</param>
        /// <param name="type">地形类型</param>
        public static int TerrainCoordsToIndex(Vector2I bitCoords)
        {
            return bitCoords.Y * MapConstant.TerrainBit3x3.X + bitCoords.X;
        }



        /// <summary>
        /// 将地形掩码中的索引转换为Vector2I。
        /// 也就是 图片坐标 转换 为 index索引
        /// </summary>
        /// <param name="index">索引</param>
        public static Vector2I TerrainIndexToCoords(int index)
        {
            int y = (index - 1) / MapConstant.TerrainBit3x3.X;
            int x = index - y * MapConstant.TerrainBit3x3.X;
            return new Vector2I(x - 1, y);
        }

        /// <summary>
        /// 将地掩码值转换为索引值
        /// </summary>
        /// <param name="bit">地形掩码值</param>
        public static int TerrainBitToIndex(uint bit)
        {
            switch (bit)
            {
                case Center: return 6;
                case Center | RightBottom: return 6;
                case Center | Bottom: return 5;
                case Center | Bottom | RightBottom: return 5;
                case Center | LeftBottom: return 6;
                case Center | LeftBottom | RightBottom: return 6;
                case Center | Bottom | LeftBottom: return 5;
                case Center | Bottom | LeftBottom | RightBottom: return 5;
                case Center | Right: return 16;
                case Center | Right | RightBottom: return 16;
                case Center | Right | Bottom: return 7;
                case Center | Right | Bottom | RightBottom: return 1;
                case Center | Right | LeftBottom: return 16;
                case Center | Right | LeftBottom | RightBottom: return 16;
                case Center | Right | Bottom | LeftBottom: return 7;
                case Center | Right | Bottom | LeftBottom | RightBottom: return 1;
                case Center | Left: return 18;
                case Center | Left | RightBottom: return 18;
                case Center | Left | Bottom: return 10;
                case Center | Left | Bottom | RightBottom: return 10;
                case Center | Left | LeftBottom: return 18;
                case Center | Left | LeftBottom | RightBottom: return 18;
                case Center | Left | Bottom | LeftBottom: return 3;
                case Center | Left | Bottom | LeftBottom | RightBottom: return 3;
                case Center | Left | Right: return 30;
                case Center | Left | Right | RightBottom: return 30;
                case Center | Left | Right | Bottom: return 11;
                case Center | Left | Right | Bottom | RightBottom: return 9;
                case Center | Left | Right | LeftBottom: return 30;
                case Center | Left | Right | LeftBottom | RightBottom: return 30;
                case Center | Left | Right | Bottom | LeftBottom: return 8;
                case Center | Left | Right | Bottom | LeftBottom | RightBottom: return 2;
                case Center | RightTop: return 6;
                case Center | RightTop | RightBottom: return 6;
                case Center | RightTop | Bottom: return 5;
                case Center | RightTop | Bottom | RightBottom: return 5;
                case Center | RightTop | LeftBottom: return 6;
                case Center | RightTop | LeftBottom | RightBottom: return 6;
                case Center | RightTop | Bottom | LeftBottom: return 5;
                case Center | RightTop | Bottom | LeftBottom | RightBottom: return 5;
                case Center | RightTop | Right: return 16;
                case Center | RightTop | Right | RightBottom: return 16;
                case Center | RightTop | Right | Bottom: return 7;
                case Center | RightTop | Right | Bottom | RightBottom: return 1;
                case Center | RightTop | Right | LeftBottom: return 16;
                case Center | RightTop | Right | LeftBottom | RightBottom: return 16;
                case Center | RightTop | Right | Bottom | LeftBottom: return 7;
                case Center | RightTop | Right | Bottom | LeftBottom | RightBottom: return 1;
                case Center | RightTop | Left: return 18;
                case Center | RightTop | Left | RightBottom: return 18;
                case Center | RightTop | Left | Bottom: return 10;
                case Center | RightTop | Left | Bottom | RightBottom: return 10;
                case Center | RightTop | Left | LeftBottom: return 18;
                case Center | RightTop | Left | LeftBottom | RightBottom: return 18;
                case Center | RightTop | Left | Bottom | LeftBottom: return 3;
                case Center | RightTop | Left | Bottom | LeftBottom | RightBottom: return 3;
                case Center | RightTop | Left | Right: return 30;
                case Center | RightTop | Left | Right | RightBottom: return 30;
                case Center | RightTop | Left | Right | Bottom: return 11;
                case Center | RightTop | Left | Right | Bottom | RightBottom: return 9;
                case Center | RightTop | Left | Right | LeftBottom: return 30;
                case Center | RightTop | Left | Right | LeftBottom | RightBottom: return 30;
                case Center | RightTop | Left | Right | Bottom | LeftBottom: return 8;
                case Center | RightTop | Left | Right | Bottom | LeftBottom | RightBottom: return 2;
                case Center | Top: return 29;
                case Center | Top | RightBottom: return 29;
                case Center | Top | Bottom: return 28;
                case Center | Top | Bottom | RightBottom: return 28;
                case Center | Top | LeftBottom: return 29;
                case Center | Top | LeftBottom | RightBottom: return 29;
                case Center | Top | Bottom | LeftBottom: return 28;
                case Center | Top | Bottom | LeftBottom | RightBottom: return 28;
                case Center | Top | Right: return 43;
                case Center | Top | Right | RightBottom: return 43;
                case Center | Top | Right | Bottom: return 24;
                case Center | Top | Right | Bottom | RightBottom: return 31;
                case Center | Top | Right | LeftBottom: return 43;
                case Center | Top | Right | LeftBottom | RightBottom: return 43;
                case Center | Top | Right | Bottom | LeftBottom: return 24;
                case Center | Top | Right | Bottom | LeftBottom | RightBottom: return 31;
                case Center | Top | Left: return 46;
                case Center | Top | Left | RightBottom: return 46;
                case Center | Top | Left | Bottom: return 23;
                case Center | Top | Left | Bottom | RightBottom: return 23;
                case Center | Top | Left | LeftBottom: return 46;
                case Center | Top | Left | LeftBottom | RightBottom: return 46;
                case Center | Top | Left | Bottom | LeftBottom: return 34;
                case Center | Top | Left | Bottom | LeftBottom | RightBottom: return 34;
                case Center | Top | Left | Right: return 12;
                case Center | Top | Left | Right | RightBottom: return 12;
                case Center | Top | Left | Right | Bottom: return 17;
                case Center | Top | Left | Right | Bottom | RightBottom: return 35;
                case Center | Top | Left | Right | LeftBottom: return 12;
                case Center | Top | Left | Right | LeftBottom | RightBottom: return 12;
                case Center | Top | Left | Right | Bottom | LeftBottom: return 36;
                case Center | Top | Left | Right | Bottom | LeftBottom | RightBottom: return 38;
                case Center | Top | RightTop: return 29;
                case Center | Top | RightTop | RightBottom: return 29;
                case Center | Top | RightTop | Bottom: return 28;
                case Center | Top | RightTop | Bottom | RightBottom: return 28;
                case Center | Top | RightTop | LeftBottom: return 29;
                case Center | Top | RightTop | LeftBottom | RightBottom: return 29;
                case Center | Top | RightTop | Bottom | LeftBottom: return 28;
                case Center | Top | RightTop | Bottom | LeftBottom | RightBottom: return 28;
                case Center | Top | RightTop | Right: return 25;
                case Center | Top | RightTop | Right | RightBottom: return 25;
                case Center | Top | RightTop | Right | Bottom: return 19;
                case Center | Top | RightTop | Right | Bottom | RightBottom: return 13;
                case Center | Top | RightTop | Right | LeftBottom: return 25;
                case Center | Top | RightTop | Right | LeftBottom | RightBottom: return 25;
                case Center | Top | RightTop | Right | Bottom | LeftBottom: return 19;
                case Center | Top | RightTop | Right | Bottom | LeftBottom | RightBottom: return 13;
                case Center | Top | RightTop | Left: return 46;
                case Center | Top | RightTop | Left | RightBottom: return 46;
                case Center | Top | RightTop | Left | Bottom: return 23;
                case Center | Top | RightTop | Left | Bottom | RightBottom: return 23;
                case Center | Top | RightTop | Left | LeftBottom: return 46;
                case Center | Top | RightTop | Left | LeftBottom | RightBottom: return 46;
                case Center | Top | RightTop | Left | Bottom | LeftBottom: return 34;
                case Center | Top | RightTop | Left | Bottom | LeftBottom | RightBottom: return 34;
                case Center | Top | RightTop | Left | Right: return 45;
                case Center | Top | RightTop | Left | Right | RightBottom: return 45;
                case Center | Top | RightTop | Left | Right | Bottom: return 47;
                case Center | Top | RightTop | Left | Right | Bottom | RightBottom: return 39;
                case Center | Top | RightTop | Left | Right | LeftBottom: return 45;
                case Center | Top | RightTop | Left | Right | LeftBottom | RightBottom: return 45;
                case Center | Top | RightTop | Left | Right | Bottom | LeftBottom: return 42;
                case Center | Top | RightTop | Left | Right | Bottom | LeftBottom | RightBottom: return 33;
                case Center | LeftTop: return 6;
                case Center | LeftTop | RightBottom: return 6;
                case Center | LeftTop | Bottom: return 5;
                case Center | LeftTop | Bottom | RightBottom: return 5;
                case Center | LeftTop | LeftBottom: return 6;
                case Center | LeftTop | LeftBottom | RightBottom: return 6;
                case Center | LeftTop | Bottom | LeftBottom: return 5;
                case Center | LeftTop | Bottom | LeftBottom | RightBottom: return 5;
                case Center | LeftTop | Right: return 16;
                case Center | LeftTop | Right | RightBottom: return 16;
                case Center | LeftTop | Right | Bottom: return 7;
                case Center | LeftTop | Right | Bottom | RightBottom: return 1;
                case Center | LeftTop | Right | LeftBottom: return 16;
                case Center | LeftTop | Right | LeftBottom | RightBottom: return 16;
                case Center | LeftTop | Right | Bottom | LeftBottom: return 7;
                case Center | LeftTop | Right | Bottom | LeftBottom | RightBottom: return 1;
                case Center | LeftTop | Left: return 18;
                case Center | LeftTop | Left | RightBottom: return 18;
                case Center | LeftTop | Left | Bottom: return 10;
                case Center | LeftTop | Left | Bottom | RightBottom: return 10;
                case Center | LeftTop | Left | LeftBottom: return 18;
                case Center | LeftTop | Left | LeftBottom | RightBottom: return 18;
                case Center | LeftTop | Left | Bottom | LeftBottom: return 3;
                case Center | LeftTop | Left | Bottom | LeftBottom | RightBottom: return 3;
                case Center | LeftTop | Left | Right: return 30;
                case Center | LeftTop | Left | Right | RightBottom: return 30;
                case Center | LeftTop | Left | Right | Bottom: return 11;
                case Center | LeftTop | Left | Right | Bottom | RightBottom: return 9;
                case Center | LeftTop | Left | Right | LeftBottom: return 30;
                case Center | LeftTop | Left | Right | LeftBottom | RightBottom: return 30;
                case Center | LeftTop | Left | Right | Bottom | LeftBottom: return 8;
                case Center | LeftTop | Left | Right | Bottom | LeftBottom | RightBottom: return 2;
                case Center | LeftTop | RightTop: return 6;
                case Center | LeftTop | RightTop | RightBottom: return 6;
                case Center | LeftTop | RightTop | Bottom: return 5;
                case Center | LeftTop | RightTop | Bottom | RightBottom: return 5;
                case Center | LeftTop | RightTop | LeftBottom: return 6;
                case Center | LeftTop | RightTop | LeftBottom | RightBottom: return 6;
                case Center | LeftTop | RightTop | Bottom | LeftBottom: return 5;
                case Center | LeftTop | RightTop | Bottom | LeftBottom | RightBottom: return 5;
                case Center | LeftTop | RightTop | Right: return 16;
                case Center | LeftTop | RightTop | Right | RightBottom: return 16;
                case Center | LeftTop | RightTop | Right | Bottom: return 7;
                case Center | LeftTop | RightTop | Right | Bottom | RightBottom: return 1;
                case Center | LeftTop | RightTop | Right | LeftBottom: return 16;
                case Center | LeftTop | RightTop | Right | LeftBottom | RightBottom: return 16;
                case Center | LeftTop | RightTop | Right | Bottom | LeftBottom: return 7;
                case Center | LeftTop | RightTop | Right | Bottom | LeftBottom | RightBottom: return 1;
                case Center | LeftTop | RightTop | Left: return 18;
                case Center | LeftTop | RightTop | Left | RightBottom: return 18;
                case Center | LeftTop | RightTop | Left | Bottom: return 10;
                case Center | LeftTop | RightTop | Left | Bottom | RightBottom: return 10;
                case Center | LeftTop | RightTop | Left | LeftBottom: return 18;
                case Center | LeftTop | RightTop | Left | LeftBottom | RightBottom: return 18;
                case Center | LeftTop | RightTop | Left | Bottom | LeftBottom: return 3;
                case Center | LeftTop | RightTop | Left | Bottom | LeftBottom | RightBottom: return 3;
                case Center | LeftTop | RightTop | Left | Right: return 30;
                case Center | LeftTop | RightTop | Left | Right | RightBottom: return 30;
                case Center | LeftTop | RightTop | Left | Right | Bottom: return 11;
                case Center | LeftTop | RightTop | Left | Right | Bottom | RightBottom: return 9;
                case Center | LeftTop | RightTop | Left | Right | LeftBottom: return 30;
                case Center | LeftTop | RightTop | Left | Right | LeftBottom | RightBottom: return 30;
                case Center | LeftTop | RightTop | Left | Right | Bottom | LeftBottom: return 8;
                case Center | LeftTop | RightTop | Left | Right | Bottom | LeftBottom | RightBottom: return 2;
                case Center | LeftTop | Top: return 29;
                case Center | LeftTop | Top | RightBottom: return 29;
                case Center | LeftTop | Top | Bottom: return 28;
                case Center | LeftTop | Top | Bottom | RightBottom: return 28;
                case Center | LeftTop | Top | LeftBottom: return 29;
                case Center | LeftTop | Top | LeftBottom | RightBottom: return 29;
                case Center | LeftTop | Top | Bottom | LeftBottom: return 28;
                case Center | LeftTop | Top | Bottom | LeftBottom | RightBottom: return 28;
                case Center | LeftTop | Top | Right: return 43;
                case Center | LeftTop | Top | Right | RightBottom: return 43;
                case Center | LeftTop | Top | Right | Bottom: return 24;
                case Center | LeftTop | Top | Right | Bottom | RightBottom: return 31;
                case Center | LeftTop | Top | Right | LeftBottom: return 43;
                case Center | LeftTop | Top | Right | LeftBottom | RightBottom: return 43;
                case Center | LeftTop | Top | Right | Bottom | LeftBottom: return 24;
                case Center | LeftTop | Top | Right | Bottom | LeftBottom | RightBottom: return 31;
                case Center | LeftTop | Top | Left: return 27;
                case Center | LeftTop | Top | Left | RightBottom: return 27;
                case Center | LeftTop | Top | Left | Bottom: return 22;
                case Center | LeftTop | Top | Left | Bottom | RightBottom: return 22;
                case Center | LeftTop | Top | Left | LeftBottom: return 27;
                case Center | LeftTop | Top | Left | LeftBottom | RightBottom: return 27;
                case Center | LeftTop | Top | Left | Bottom | LeftBottom: return 15;
                case Center | LeftTop | Top | Left | Bottom | LeftBottom | RightBottom: return 15;
                case Center | LeftTop | Top | Left | Right: return 44;
                case Center | LeftTop | Top | Left | Right | RightBottom: return 44;
                case Center | LeftTop | Top | Left | Right | Bottom: return 48;
                case Center | LeftTop | Top | Left | Right | Bottom | RightBottom: return 41;
                case Center | LeftTop | Top | Left | Right | LeftBottom: return 44;
                case Center | LeftTop | Top | Left | Right | LeftBottom | RightBottom: return 44;
                case Center | LeftTop | Top | Left | Right | Bottom | LeftBottom: return 40;
                case Center | LeftTop | Top | Left | Right | Bottom | LeftBottom | RightBottom: return 32;
                case Center | LeftTop | Top | RightTop: return 29;
                case Center | LeftTop | Top | RightTop | RightBottom: return 29;
                case Center | LeftTop | Top | RightTop | Bottom: return 28;
                case Center | LeftTop | Top | RightTop | Bottom | RightBottom: return 28;
                case Center | LeftTop | Top | RightTop | LeftBottom: return 29;
                case Center | LeftTop | Top | RightTop | LeftBottom | RightBottom: return 29;
                case Center | LeftTop | Top | RightTop | Bottom | LeftBottom: return 28;
                case Center | LeftTop | Top | RightTop | Bottom | LeftBottom | RightBottom: return 28;
                case Center | LeftTop | Top | RightTop | Right: return 25;
                case Center | LeftTop | Top | RightTop | Right | RightBottom: return 25;
                case Center | LeftTop | Top | RightTop | Right | Bottom: return 19;
                case Center | LeftTop | Top | RightTop | Right | Bottom | RightBottom: return 13;
                case Center | LeftTop | Top | RightTop | Right | LeftBottom: return 25;
                case Center | LeftTop | Top | RightTop | Right | LeftBottom | RightBottom: return 25;
                case Center | LeftTop | Top | RightTop | Right | Bottom | LeftBottom: return 19;
                case Center | LeftTop | Top | RightTop | Right | Bottom | LeftBottom | RightBottom: return 13;
                case Center | LeftTop | Top | RightTop | Left: return 27;
                case Center | LeftTop | Top | RightTop | Left | RightBottom: return 27;
                case Center | LeftTop | Top | RightTop | Left | Bottom: return 22;
                case Center | LeftTop | Top | RightTop | Left | Bottom | RightBottom: return 22;
                case Center | LeftTop | Top | RightTop | Left | LeftBottom: return 27;
                case Center | LeftTop | Top | RightTop | Left | LeftBottom | RightBottom: return 27;
                case Center | LeftTop | Top | RightTop | Left | Bottom | LeftBottom: return 15;
                case Center | LeftTop | Top | RightTop | Left | Bottom | LeftBottom | RightBottom: return 15;
                case Center | LeftTop | Top | RightTop | Left | Right: return 26;
                case Center | LeftTop | Top | RightTop | Left | Right | RightBottom: return 26;
                case Center | LeftTop | Top | RightTop | Left | Right | Bottom: return 37;
                case Center | LeftTop | Top | RightTop | Left | Right | Bottom | RightBottom: return 21;
                case Center | LeftTop | Top | RightTop | Left | Right | LeftBottom: return 26;
                case Center | LeftTop | Top | RightTop | Left | Right | LeftBottom | RightBottom: return 26;
                case Center | LeftTop | Top | RightTop | Left | Right | Bottom | LeftBottom: return 20;
                case Center | LeftTop | Top | RightTop | Left | Right | LeftBottom | Bottom | RightBottom: return 14;
                default:
                    return -1;
            }
        }


        public uint IndexToTerrainBit(int index)
        {
            switch (index)
            {
                case 0: return Center | Bottom;
                case 1: return Center | Right | Bottom;
                case 2: return Left | Center | Right | Bottom;
                case 3: return Left | Center | Bottom;
                case 4: return LeftTop | Top | Left | Center | Right | Bottom;
                case 5: return Left | Center | Right | Bottom | RightBottom;
                case 6: return Left | Center | Right | LeftBottom | Bottom;
                case 7: return Top | RightTop | Left | Center | Right | Bottom;
                case 8: return Center | Right | Bottom | RightBottom;
                case 9: return Top | Left | Center | Right | LeftBottom | Bottom | RightBottom;
                case 10: return Left | Center | Right | LeftBottom | Bottom | RightBottom;
                case 11: return Left | Center | LeftBottom | Bottom;
                case 12: return Top | Center | Bottom;
                case 13: return Top | Center | Right | Bottom;
                case 14: return Top | Left | Center | Right | Bottom;
                case 15: return Top | Left | Center | Bottom;
                case 16: return Top | Center | Right | Bottom | RightBottom;
                case 17: return Top | RightTop | Left | Center | Right | LeftBottom | Bottom | RightBottom;
                case 18: return LeftTop | Top | Left | Center | Right | LeftBottom | Bottom | RightBottom;
                case 19: return Top | Left | Center | LeftBottom | Bottom;
                case 20: return Top | RightTop | Center | Right | Bottom | RightBottom;
                case 21: return Top | RightTop | Left | Center | Right | LeftBottom | Bottom;
                case 22: return LeftTop | Top | Left | Center;
                case 23: return LeftTop | Top | Left | Center | Right | LeftBottom | Bottom;
                case 24: return Top | Center;
                case 25: return Top | Center | Right;
                case 26: return Top | Left | Center | Right;
                case 27: return Top | Left | Center;
                case 28: return Top | RightTop | Center | Right | Bottom;
                case 29: return LeftTop | Top | RightTop | Left | Center | Right | Bottom | RightBottom;
                case 30: return LeftTop | Top | RightTop | Left | Center | Right | LeftBottom | Bottom;
                case 31: return LeftTop | Top | Left | Center | Bottom;
                case 32: return Top | RightTop | Left | Center | Right | Bottom | RightBottom;
                case 33: return LeftTop | Top | RightTop | Left | Center | Right | LeftBottom | Bottom | RightBottom;
                case 34: return LeftTop | Top | Left | Center | Right | Bottom | RightBottom;
                case 35: return LeftTop | Top | Left | Center | LeftBottom | Bottom;
                case 36: return Center;
                case 37: return Center | Right;
                case 38: return Left | Center | Right;
                case 39: return Left | Center;
                case 40: return Top | Left | Center | Right | LeftBottom | Bottom;
                case 41: return Top | RightTop | Left | Center | Right;
                case 42: return LeftTop | Top | Left | Center | Right;
                case 43: return Top | Left | Center | Right | Bottom | RightBottom;
                case 44: return Top | RightTop | Center | Right;
                case 45: return LeftTop | Top | RightTop | Left | Center | Right;
                case 46: return LeftTop | Top | RightTop | Left | Center | Right | Bottom;
                default: return None;
            }
        }
    }
}
