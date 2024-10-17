
using Godot;
using System;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 额外绘制
    /// </summary>
	public partial class MapExtraDraw
    {
        public int Width;
        public int Height;

        public MapExtraDraw(int id, int Width, int Height)
        {
            MapDrawId = id;
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_MapExtraDraw, id);
            DrawType = (int)dict["DrawType"];
            Param1 = (float)dict["Param1"];
            Param2 = (float)dict["Param2"];
            Param3 = (Vector2)dict["Param3"];
            Param4 = (Vector2)dict["Param4"];
            ParamList = (List<List<float>>)dict["ParamList"];
            this.Width = Width;
            this.Height = Height;
        }

        /// <summary>
        /// 进行绘制
        /// </summary>
        /// <param name="map"></param>
        public void ExtraDraw(Cell[,] map)
        {
            switch (DrawType)
            {
                case 1://1 直线(参数3坐标 到 参数4坐标，参数1：绘制宽度)
                    List<Vector2I> line = LineDraw();
                    int PassWidth = (int)Param2;
                    MapMaterial mapMaterial = new MapMaterial((int)Param1);
                    foreach (Vector2I coord in line)//遍历每一个点
                    {
                        for (int i = -PassWidth; i < PassWidth; i++)
                        {
                            for (int j = -PassWidth; j < PassWidth; j++)
                            {
                                if (i * i + j * j <= PassWidth * PassWidth)
                                {
                                    int drawX = coord.X + i;
                                    int drawY = coord.Y + j;
                                    if (IsInBounds(Height, Width, drawX, drawY))
                                    {
                                        map[drawX, drawY] = mapMaterial.GetCell(drawX, drawY);
                                    }
                                }
                            }
                        }
                    }
                    break;
                default:
                    break;
            }
        }








        /// <summary>
        /// 检测是否在边界内
        /// </summary>
        /// <param name="rowCount">行数</param>
        /// <param name="colCount"></param>
        /// <param name="x"></param>
        /// <param name="y"></param>
        /// <returns></returns>
        public bool IsInBounds(int rowCount, int colCount, int x, int y)
        {
            return x >= 0 && x < colCount && y >= 0 && y < rowCount;
        }


        //直线(参数3坐标 到 参数4坐标，参数1：绘制宽度)
        public List<Vector2I> LineDraw()
        {
            int from_x = (int)Param3.X;
            int from_y = (int)Param3.Y;
            int to_x = (int)Param4.X;
            int to_y = (int)Param4.Y;
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
            List<Vector2I> line = new List<Vector2I>();
            for (int i = 0; i < longest; i++)
            {
                line.Add(new Vector2I(from_x, from_y));
                if (inverted)
                    from_y += step;
                else
                    from_x += step;
                acc += 2 * shortest; // 梯度每次增长为短边的长度
                if (acc >= longest)
                {
                    if (inverted)
                        from_x += gradientStep;
                    else
                        from_y += gradientStep;
                    acc -= 2 * longest;
                }
            }
            return line;
        }
    }
}