using System;

namespace BulletMLLib.SharedProject;

public static class MathHelper
{
    /// <summary>Represents the mathematical constant e(2.71828175).</summary>
    public const float E = 2.718282f;

    /// <summary>Represents the log base ten of e(0.4342945).</summary>
    public const float Log10E = 0.4342945f;

    /// <summary>Represents the log base two of e(1.442695).</summary>
    public const float Log2E = 1.442695f;

    /// <summary>Represents the value of pi(3.14159274).</summary>
    public const float Pi = 3.141593f;

    /// <summary>
    /// Represents the value of pi divided by two(1.57079637).
    /// </summary>
    public const float PiOver2 = 1.570796f;

    /// <summary>
    /// Represents the value of pi divided by four(0.7853982).
    /// </summary>
    public const float PiOver4 = 0.7853982f;

    /// <summary>Represents the value of pi times two(6.28318548).</summary>
    public const float TwoPi = 6.283185f;

    /// <summary>
    /// Returns the Cartesian coordinate for one axis of a point that is defined by a given triangle and two normalized barycentric (areal) coordinates.
    /// </summary>
    /// <param name="value1">The coordinate on one axis of vertex 1 of the defining triangle.</param>
    /// <param name="value2">The coordinate on the same axis of vertex 2 of the defining triangle.</param>
    /// <param name="value3">The coordinate on the same axis of vertex 3 of the defining triangle.</param>
    /// <param name="amount1">The normalized barycentric (areal) coordinate b2, equal to the weighting factor for vertex 2, the coordinate of which is specified in value2.</param>
    /// <param name="amount2">The normalized barycentric (areal) coordinate b3, equal to the weighting factor for vertex 3, the coordinate of which is specified in value3.</param>
    /// <returns>Cartesian coordinate of the specified point with respect to the axis being used.</returns>
    public static float Barycentric(
        float value1,
        float value2,
        float value3,
        float amount1,
        float amount2
    )
    {
        return (float)(
            value1 + (value2 - (double)value1) * amount1 + (value3 - (double)value1) * amount2
        );
    }

    /// <summary>
    /// Performs a Catmull-Rom interpolation using the specified positions.
    /// </summary>
    /// <param name="value1">The first position in the interpolation.</param>
    /// <param name="value2">The second position in the interpolation.</param>
    /// <param name="value3">The third position in the interpolation.</param>
    /// <param name="value4">The fourth position in the interpolation.</param>
    /// <param name="amount">Weighting factor.</param>
    /// <returns>A position that is the result of the Catmull-Rom interpolation.</returns>
    public static float CatmullRom(
        float value1,
        float value2,
        float value3,
        float value4,
        float amount
    )
    {
        var num1 = amount * (double)amount;
        var num2 = num1 * amount;
        return (float)(
            0.5
            * (
                2.0 * value2
                + (value3 - (double)value1) * amount
                + (2.0 * value1 - 5.0 * value2 + 4.0 * value3 - value4) * num1
                + (3.0 * value2 - value1 - 3.0 * value3 + value4) * num2
            )
        );
    }

    /// <summary>Restricts a value to be within a specified range.</summary>
    /// <param name="value">The value to clamp.</param>
    /// <param name="min">The minimum value. If <c>value</c> is less than <c>min</c>, <c>min</c> will be returned.</param>
    /// <param name="max">The maximum value. If <c>value</c> is greater than <c>max</c>, <c>max</c> will be returned.</param>
    /// <returns>The clamped value.</returns>
    public static float Clamp(float value, float min, float max)
    {
        value = value > (double)max ? max : value;
        value = value < (double)min ? min : value;
        return value;
    }

    /// <summary>Restricts a value to be within a specified range.</summary>
    /// <param name="value">The value to clamp.</param>
    /// <param name="min">The minimum value. If <c>value</c> is less than <c>min</c>, <c>min</c> will be returned.</param>
    /// <param name="max">The maximum value. If <c>value</c> is greater than <c>max</c>, <c>max</c> will be returned.</param>
    /// <returns>The clamped value.</returns>
    public static int Clamp(int value, int min, int max)
    {
        value = value > max ? max : value;
        value = value < min ? min : value;
        return value;
    }

    /// <summary>
    /// Calculates the absolute value of the difference of two values.
    /// </summary>
    /// <param name="value1">Source value.</param>
    /// <param name="value2">Source value.</param>
    /// <returns>Distance between the two values.</returns>
    public static float Distance(float value1, float value2) => Math.Abs(value1 - value2);

    /// <summary>
    /// 执行Hermite样条插值。
    /// </summary>
    /// <param name="value1">起始位置。</param>
    /// <param name="tangent1">起始点的切线（斜率）。</param>
    /// <param name="value2">结束位置。</param>
    /// <param name="tangent2">结束点的切线（斜率）。</param>
    /// <param name="amount">加权因子，范围通常在0到1之间。</param>
    /// <returns>Hermite样条插值的结果。</returns>
    private static float Hermite(
        float value1,
        float tangent1,
        float value2,
        float tangent2,
        float amount
    )
    {
        // 将输入参数转换为double类型以提高计算精度
        double num1 = value1;
        double num2 = value2;
        double num3 = tangent1;
        double num4 = tangent2;
        double num5 = amount;

        // 计算amount的平方和立方
        var num6 = num5 * num5 * num5;  // amount的三次方
        var num7 = num5 * num5;         // amount的平方

        // 根据Hermite插值公式计算结果
        return amount != 0.0
            ? Math.Abs(amount - 1.0) > float.Epsilon
                ? (float)(
                    (2.0 * num1 - 2.0 * num2 + num4 + num3) * num6
                    + (3.0 * num2 - 3.0 * num1 - 2.0 * num3 - num4) * num7
                    + num3 * num5
                    + num1
                )
                : value2  // 当amount接近1时，直接返回value2
            : value1;  // 当amount等于0时，直接返回value1
    }

    /// <summary>Linearly interpolates between two values.</summary>
    /// <param name="value1">Source value.</param>
    /// <param name="value2">Destination value.</param>
    /// <param name="amount">Value between 0 and 1 indicating the weight of value2.</param>
    /// <returns>Interpolated value.</returns>
    /// <remarks>This method performs the linear interpolation based on the following formula:
    /// <code>value1 + (value2 - value1) * amount</code>.
    /// Passing amount a value of 0 will cause value1 to be returned, a value of 1 will cause value2 to be returned.
    /// See <see cref="M:Microsoft.Xna.Framework.MathHelper.LerpPrecise(System.Single,System.Single,System.Single)" /> for a less efficient version with more precision around edge cases.
    /// </remarks>
    public static float Lerp(float value1, float value2, float amount) =>
        value1 + (value2 - value1) * amount;

    /// <summary>
    /// 在两个值之间进行线性插值。
    /// 本方法是一个比<see cref="M:Microsoft.Xna.Framework.MathHelper.Lerp(System.Single,System.Single,System.Single)"/>更不高效、但是更加精确的版本。
    /// 详情请参阅备注。
    /// </summary>
    /// <param name="value1">起始值。</param>
    /// <param name="value2">目标值。</param>
    /// <param name="amount">介于0到1之间的值，表示value2的权重。</param>
    /// <returns>插值得到的值。</returns>
    /// <remarks>
    /// 本方法基于以下公式执行线性插值：
    /// <code>((1 - amount) * value1) + (value2 * amount)</code>。
    /// 当amount为0时，返回value1；当amount为1时，返回value2。
    /// 与<see cref="M:Microsoft.Xna.Framework.MathHelper.Lerp(System.Single,System.Single,System.Single)"/>不同的是，本方法没有浮点数精度问题。
    /// 例如，如果value1和value2的量级差距很大（如value1=10000000000000000, value2=1），在插值范围边缘（即amount=1）时，
    /// <see cref="M:Microsoft.Xna.Framework.MathHelper.Lerp(System.Single,System.Single,System.Single)"/>会返回0（而实际上应该返回1）。
    /// 这种情况同样适用于value1=10^17, value2=10; value1=10^18, value2=10^2...等情形。
    /// 对于此问题的深入解释，请参考下列资料：
    /// 相关维基百科文章：https://en.wikipedia.org/wiki/Linear_interpolation#Programming_language_support
    /// 相关StackOverflow回答：http://stackoverflow.com/questions/4353525/floating-point-linear-interpolation#answer-23716956
    /// </remarks>
    public static float LerpPrecise(float value1, float value2, float amount) =>
        (float)((1.0 - amount) * value1 + value2 * (double)amount);

    /// <summary >返回两个值中较大的一个。</摘要>
    /// <param name="value1 " >值1</param >
    /// <param name="value2 " >值2</param >
    ///<返回>较大的值。</returns >
    public static float Max(float value1, float value2) =>
        value1 <= (double)value2 ? value2 : value1;

    /// <summary >返回两个值中较大的一个。</摘要>
    /// <param name="value1 " >值1</param >
    /// <param name="value2 " >值2</param >
    ///<返回>较大的值。</returns >
    public static int Max(int value1, int value2) => value1 <= value2 ? value2 : value1;

    /// <summary >返回两个值中较小的一个。</摘要>
    /// <param name="value1 " >值1</param >
    /// <param name="value2 " >值2</param >
    ///<返回>较小的值。</returns >
    public static float Min(float value1, float value2) =>
        value1 >= (double)value2 ? value2 : value1;

    /// <summary >返回两个值中较小的一个。</摘要>
    /// <param name="value1 " >值1</param >
    /// <param name="value2 " >值2</param >
    ///<返回>较小的值。</returns >
    public static int Min(int value1, int value2) => value1 >= value2 ? value2 : value1;

    /// <summary>
    /// 使用三次方程在两个值之间进行插值。
    /// </summary>
    /// <param name="value1">源值1。</param>
    /// <param name="value2">源值2。</param>
    /// <param name="amount">权重值，用来控制插值的程度。</param>
    /// <returns>插值后的结果。</returns>
    public static float SmoothStep(float value1, float value2, float amount)
    {
        // 将amount限制在0.0f到1.0f之间
        var amount1 = Clamp(amount, 0.0f, 1f);

        // 使用Hermite插值函数计算最终的插值结果
        return Hermite(value1, 0.0f, value2, 0.0f, amount1);
    }

    /// <summary >将弧度转换为角度。</摘要>
    /// <param name="radians " >以弧度表示的角度。</param >
    /// <returns >以度为单位的角度。</returns >
    ///<备注>
    ///此方法在内部使用双精度，
    ///尽管它返回单个浮点数
    /// Factor = 180 / pi
    ///</备注>
    public static float ToDegrees(float radians) => radians * 57.29578f;

    /// <summary >将角度转换为弧度。</摘要>
    /// <param name="degrees " >以度为单位的角度。</param >
    /// <returns >以弧度表示的角度。</returns >
    ///<备注>
    ///此方法在内部使用双精度，
    ///尽管它返回单个浮点数
    /// Factor = pi / 180
    ///</备注>
    public static float ToRadians(float degrees) => degrees * 0.01745329f;

    /// <summary >将给定的角度减小到π和-π之间的值。</摘要>
    /// <param name="angle " >要减小的角度，以弧度为单位。</param >
    /// <returns >以弧度表示的新角度。</returns >
    public static float WrapAngle(float angle)
    {
        const float PI = 3.1415926535897932f;
        const float TWO_PI = 2 * PI;
        // 对360度(2π)取模运算
        angle %= TWO_PI;
        // 如果角度小于-PI，则加上2π调整到[-PI, PI]范围内
        if (angle <= -PI)
        {
            angle += TWO_PI;
        }
        // 如果角度大于PI，则减去2π调整到[-PI, PI]范围内
        else if (angle > PI)
        {
            angle -= TWO_PI;
        }
        return angle;
    }

    /// <summary>Determines if value is powered by two.</summary>
    /// <param name="value">A value.</param>
    /// <returns><c>true</c> if <c>value</c> is powered by two; otherwise <c>false</c>.</returns>
    public static bool IsPowerOfTwo(int value) => value > 0 && (value & value - 1) == 0;
}