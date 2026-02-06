using Godot;

namespace Remnant_Afterglow
{
    public static class TerrainPeering
    {
        /// <summary>
        /// 无
        /// </summary>
        public const uint None = 0;
        /// <summary>
        /// 左上
        /// </summary>
        public const uint LeftTop = 0b1;
        /// <summary>
        /// 上
        /// </summary>
        public const uint Top = 0b10;
        /// <summary>
        /// 右上
        /// </summary>
        public const uint RightTop = 0b100;
        /// <summary>
        /// 左
        /// </summary>
        public const uint Left = 0b1000;
        /// <summary>
        /// 中心
        /// </summary>
        public const uint Center = 0b10000;
        /// <summary>
        /// 右
        /// </summary>
        public const uint Right = 0b100000;
        /// <summary>
        /// 左下
        /// </summary>
        public const uint LeftBottom = 0b1000000;
        /// <summary>
        /// 下
        /// </summary>
        public const uint Bottom = 0b10000000;
        /// <summary>
        /// 右下
        /// </summary>
        public const uint RightBottom = 0b100000000;


    }
}
