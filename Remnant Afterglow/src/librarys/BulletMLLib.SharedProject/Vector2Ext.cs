using System;
using Godot;

namespace BulletMLLib.SharedProject;

public static class Vector2Ext
{
    /// <summary>
    /// 将字符串转换为Vector2对象
    /// </summary>
    /// <param name="strVector">格式为"x y"的字符串</param>
    /// <returns>对应的Vector2对象</returns>
    public static Vector2 ToVector2(this string strVector)
    {
        var zero = Vector2.Zero;
        if (string.IsNullOrEmpty(strVector))
            return zero;
        var strArray = strVector.Split(' ');
        if (strArray.Length >= 2)
            zero.Y = Convert.ToSingle(strArray[1]);
        if (strArray.Length >= 1)
            zero.X = Convert.ToSingle(strArray[0]);
        return zero;
    }

    /// <summary>
    /// 将Vector2对象转换为字符串
    /// </summary>
    /// <param name="myVector">要转换的Vector2对象</param>
    /// <returns>格式为"x y"的字符串</returns>
    public static string StringFromVector(this Vector2 myVector) =>
        $"{myVector.X} {myVector.Y}";

    /// <summary>
    /// 计算向量的垂直向量（将向量逆时针旋转90度）
    /// </summary>
    /// <param name="myVector">原向量</param>
    /// <returns>垂直向量</returns>
    public static Vector2 Perp(this Vector2 myVector) => new(-myVector.Y, myVector.X);

    /// <summary>
    /// 计算两个向量的符号（用于判断向量的相对方向）
    /// </summary>
    /// <param name="myVector">第一个向量</param>
    /// <param name="v2">第二个向量</param>
    /// <returns>如果第一个向量在第二个向量的逆时针方向返回-1，否则返回1</returns>
    public static int Sign(this Vector2 myVector, Vector2 v2) =>
        myVector.Y * (double)v2.X > myVector.X * (double)v2.Y ? -1 : 1;

    /// <summary>
    /// 将向量长度截断到指定最大长度
    /// </summary>
    /// <param name="myVector">要截断的向量</param>
    /// <param name="maxLength">最大长度</param>
    /// <returns>截断后的向量</returns>
    public static Vector2 Truncate(this Vector2 myVector, float maxLength)
    {
        if (myVector.LengthSquared() > maxLength * (double)maxLength)
        {
            myVector.Normalized();
            myVector *= maxLength;
        }
        return myVector;
    }

    /// <summary>
    /// 计算向量的角度（弧度）
    /// </summary>
    /// <param name="vector">要计算角度的向量</param>
    /// <returns>向量的角度（弧度）</returns>
    public static float Angle(this Vector2 vector) => (float)Math.Atan2(vector.Y, vector.X);

    /// <summary>
    /// 计算两个向量之间的夹角
    /// </summary>
    /// <param name="a">第一个向量</param>
    /// <param name="b">第二个向量</param>
    /// <returns>两个向量之间的夹角（弧度）</returns>
    public static float AngleBetweenVectors(this Vector2 a, Vector2 b) => b.Angle() - a.Angle();

    /// <summary>
    /// 将角度（弧度）转换为单位向量
    /// </summary>
    /// <param name="angle">角度（弧度）</param>
    /// <returns>对应的单位向量</returns>
    public static Vector2 ToVector2(this float angle) =>
        new((float)Math.Cos(angle), (float)Math.Sin(angle));

    /// <summary>
    /// 将角度（弧度）转换为单位向量
    /// </summary>
    /// <param name="angle">角度（弧度）</param>
    /// <returns>对应的单位向量</returns>
    public static Vector2 ToVector2(this double angle) =>
        new((float)Math.Cos(angle), (float)Math.Sin(angle));

    /// <summary>
    /// 检查向量是否包含NaN值
    /// </summary>
    /// <param name="vect">要检查的向量</param>
    /// <returns>如果不包含NaN值返回true，否则返回false</returns>
    public static bool IsNaN(this Vector2 vect) => !float.IsNaN(vect.X) && !float.IsNaN(vect.Y);

    /// <summary>
    /// 返回向量的单位向量
    /// </summary>
    /// <param name="myVector">要标准化的向量</param>
    /// <returns>单位向量</returns>
    public static Vector2 Normalized(this Vector2 myVector)
    {
        var num = myVector.Length();
        return new(myVector.X / num, myVector.Y / num);
    }
}
