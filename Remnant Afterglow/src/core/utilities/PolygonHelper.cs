using System.Numerics;
using System.Collections.Generic;
using Godot;
using System;
using Vector2 = Godot.Vector2;
using GameLog;


namespace Remnant_Afterglow
{
    //多边形助手
    public class PolygonHelper
    {
        // 返回多边形内部的一个随机点
        public static Vector2I GetRandomPointInPolygon(List<Vector2I> polygonVertices)
        {
            // 计算多边形的边界框
            int minX = int.MaxValue;
            int maxX = int.MinValue;
            int minY = int.MaxValue;
            int maxY = int.MinValue;
            foreach (var vertex in polygonVertices)
            {
                if (vertex.X < minX) minX = vertex.X;
                if (vertex.X > maxX) maxX = vertex.X;
                if (vertex.Y < minY) minY = vertex.Y;
                if (vertex.Y > maxY) maxY = vertex.Y;
            }
            // 在边界框内生成随机点
            Random random = new Random();
            Vector2I point;
            do
            {
                point = new Vector2I(random.Next(minX, maxX), random.Next(minY, maxY));
            } while (!IsPointInPolygon(point, polygonVertices));
            return point;
        }

        // 返回多边形内部的所有整数坐标点集合
        public static List<Vector2I> GetPointListPolygon(List<Vector2I> polygonVertices)
        {
            List<Vector2I> list = new List<Vector2I>();
            // 计算多边形的边界框
            int minX = int.MaxValue;
            int maxX = int.MinValue;
            int minY = int.MaxValue;
            int maxY = int.MinValue;
            foreach (var vertex in polygonVertices)
            {
                if (vertex.X < minX) minX = vertex.X;
                if (vertex.X > maxX) maxX = vertex.X;
                if (vertex.Y < minY) minY = vertex.Y;
                if (vertex.Y > maxY) maxY = vertex.Y;
            }
            // 二维循环遍历所有坐标
            for (int x = minX; x <= maxX; x++)
            {
                for (int y = minY; y <= maxY; y++)
                {
                    Vector2I point = new Vector2I(x, y);
                    if(IsPointInPolygon(point, polygonVertices))//
                    {
                        list.Add(point);
                    }
                }
            }
            return list;
        }
        /// <summary>
        /// 检查点是否位于多边形内部
        /// </summary>
        /// <param name="point"></param>
        /// <param name="polygonVertices"></param>
        /// <returns></returns>
        public static bool IsPointInPolygon(Vector2I point, List<Vector2I> polygonVertices)
        {
            int intersections = 0;
            int n = polygonVertices.Count;
            for (int i = 0; i < n; i++)
            {
                Vector2I v1 = polygonVertices[i];
                Vector2I v2 = polygonVertices[(i + 1) % n];
                if (point.Y > Math.Min(v1.Y, v2.Y))
                {
                    if (point.Y <= Math.Max(v1.Y, v2.Y))
                    {
                        if (point.X <= Math.Max(v1.X, v2.X))
                        {
                            if (v1.Y != v2.Y)
                            {
                                double xints = (point.Y - v1.Y) * (v2.X - v1.X) / (v2.Y - v1.Y) + v1.X;
                                if (v1.X == v2.X || point.X <= xints)
                                {
                                    intersections++;
                                }
                            }
                        }
                    }
                }
            }
            return (intersections % 2 == 1);
        }


        // 生成指定范围内的随机浮点数
        private static float NextFloat(Random random, float min, float max)
        {
            return (float)random.NextDouble() * (max - min) + min;
        }
    }
}
