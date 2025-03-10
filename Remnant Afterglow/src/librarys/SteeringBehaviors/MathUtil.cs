using BulletMLLib.SharedProject;
using Godot;
using System;
using System.Collections.Generic;

namespace SteeringBehaviors
{
    // 提供各种数学辅助函数的静态类。
    public static class MathUtil
    {
        // 截断向量的长度，使其不超过指定的最大值。
        public static Vector2 Truncate(Vector2 vec, float max)
        {
            if (vec.Length() == 0) return vec; // 避免除以零
            var i = max / vec.Length();
            i = i < 1.0f ? i : 1.0f;

            return vec * i;
        }

        // 计算一个实体为了面向某个目标需要转动的角度，考虑当前角度和转动速度。
        public static float TurnToFace(Vector2 position, Vector2 faceThis, float currentAngle, float turnSpeed)
        {
            float x = faceThis.X - position.X;
            float y = faceThis.Y - position.Y;

            float desiredAngle = (float)Math.Atan2(y, x);

            float difference = MathHelper.WrapAngle(desiredAngle - currentAngle);//祝福注释

            difference = MathHelper.Clamp(difference, -turnSpeed, turnSpeed);//祝福注释

            return MathHelper.WrapAngle(currentAngle + difference);
        }

        // 扩展方法，返回给定向量的单位向量（归一化）。
        public static Vector2 Normalized(this Vector2 vec)
        {
            if (vec.Length() == 0) return vec; // 处理零向量的情况
            var v = vec;
            Normalized(vec);
            return v;
        }

        // 扩展方法，生成指定范围内的随机浮点数。
        public static float NextFloat(this System.Random rand, float minValue, float maxValue)
        {
            return (float)rand.NextDouble() * (maxValue - minValue) + minValue;
        }

        // 扩展方法，生成指定长度范围内的随机二维向量。
        public static Vector2 NextVector2(this System.Random rand, float minLength, float maxLength)
        {
            double theta = rand.NextDouble() * 2 * Math.PI;
            float length = rand.NextFloat(minLength, maxLength);
            return new Vector2(length * (float)Math.Cos(theta), length * (float)Math.Sin(theta));
        }

        // 计算两个向量之间的交叉乘积标量值，并将其与0xFFFF进行按位与操作，可能用于某些特定逻辑或优先级计算。
        public static int Preference(Vector2 goal, Vector2 hex)
        {
            return (0xFFFF & Math.Abs((int)CrossScalar(goal, hex)));
        }

        // 计算两个二维向量的交叉乘积标量值。
        public static float CrossScalar(Vector2 a, Vector2 b)
        {
            return (a.X * b.Y) - (a.Y * b.X);
        }

        // 获取从点a到点b之间所有整数坐标的点集合。
        public static IEnumerable<Vector2I> GetPointsOnLine(Vector2I a, Vector2I b) =>
            GetPointsOnLine(a.X, a.Y, b.X, b.Y);

        // 使用Bresenham算法实现获取从(x0, y0)到(x1, y1)之间所有整数坐标的点集合。
        public static IEnumerable<Vector2I> GetPointsOnLine(int x0, int y0, int x1, int y1)
        {
            bool steep = Math.Abs(y1 - y0) > Math.Abs(x1 - x0);
            if (steep)
            {
                Swap(ref x0, ref y0); // 交换x0和y0
                Swap(ref x1, ref y1); // 交换x1和y1
            }
            if (x0 > x1)
            {
                Swap(ref x0, ref x1); // 交换x0和x1
                Swap(ref y0, ref y1); // 交换y0和y1
            }
            int dx = x1 - x0;
            int dy = Math.Abs(y1 - y0);
            int error = dx / 2;
            int ystep = (y0 < y1) ? 1 : -1;
            int y = y0;
            for (int x = x0; x <= x1; x++)
            {
                yield return new Vector2I((steep ? y : x), (steep ? x : y));
                error -= dy;
                if (error < 0)
                {
                    y += ystep;
                    error += dx;
                }
            }
            yield break;
        }

        // 辅助方法，用于交换两个整数值。
        private static void Swap(ref int a, ref int b)
        {
            int temp = a;
            a = b;
            b = temp;
        }
    }
}