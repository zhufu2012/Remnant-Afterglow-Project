using System;

namespace BulletMLLib.SharedProject;

public static class MathHelper
{
    /// <summary>表示数学常数e(2.71828175)。</summary>
    public const float E = 2.718282f;

    /// <summary>表示以10为底的e的对数(0.4342945)。</summary>
    public const float Log10E = 0.4342945f;

    /// <summary>表示以2为底的e的对数(1.442695)。</summary>
    public const float Log2E = 1.442695f;

    /// <summary>表示π的值(3.14159274)。</summary>
    public const float Pi = 3.141593f;

    /// <summary>
    /// 表示π除以二的值(1.57079637)。
    /// </summary>
    public const float PiOver2 = 1.570796f;

    /// <summary>
    /// 表示π除以四的值(0.7853982)。
    /// </summary>
    public const float PiOver4 = 0.7853982f;

    /// <summary>表示π乘以二的值(6.28318548)。</summary>
    public const float TwoPi = 6.283185f;

    /// <summary>
    /// 返回由给定三角形和两个归一化重心坐标定义的点在一个轴上的笛卡尔坐标。
    /// </summary>
    /// <param name="value1">定义三角形顶点1在某个轴上的坐标。</param>
    /// <param name="value2">定义三角形顶点2在同一轴上的坐标。</param>
    /// <param name="value3">定义三角形顶点3在同一轴上的坐标。</param>
    /// <param name="amount1">归一化重心坐标b2，等于顶点2的权重因子，顶点2的坐标由value2指定。</param>
    /// <param name="amount2">归一化重心坐标b3，等于顶点3的权重因子，顶点3的坐标由value3指定。</param>
    /// <returns>相对于正在使用的轴的指定点的笛卡尔坐标。</returns>
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
    /// 使用指定位置执行Catmull-Rom插值。
    /// </summary>
    /// <param name="value1">插值中的第一个位置。</param>
    /// <param name="value2">插值中的第二个位置。</param>
    /// <param name="value3">插值中的第三个位置。</param>
    /// <param name="value4">插值中的第四个位置。</param>
    /// <param name="amount">权重因子。</param>
    /// <returns>Catmull-Rom插值的结果位置。</returns>
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

    /// <summary>将值限制在指定范围内。</summary>
    /// <param name="value">要限制的值。</param>
    /// <param name="min">最小值。如果<c>value</c>小于<c>min</c>，将返回<c>min</c>。</param>
    /// <param name="max">最大值。如果<c>value</c>大于<c>max</c>，将返回<c>max</c>。</param>
    /// <returns>限制后的值。</returns>
    public static float Clamp(float value, float min, float max)
    {
        value = value > (double)max ? max : value;
        value = value < (double)min ? min : value;
        return value;
    }

    /// <summary>将值限制在指定范围内。</summary>
    /// <param name="value">要限制的值。</param>
    /// <param name="min">最小值。如果<c>value</c>小于<c>min</c>，将返回<c>min</c>。</param>
    /// <param name="max">最大值。如果<c>value</c>大于<c>max</c>，将返回<c>max</c>。</param>
    /// <returns>限制后的值。</returns>
    public static int Clamp(int value, int min, int max)
    {
        value = value > max ? max : value;
        value = value < min ? min : value;
        return value;
    }

    /// <summary>
    /// 计算两个值差的绝对值。
    /// </summary>
    /// <param name="value1">源值。</param>
    /// <param name="value2">源值。</param>
    /// <returns>两个值之间的距离。</returns>
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

    /// <summary>在两个值之间进行线性插值。</summary>
    /// <param name="value1">源值。</param>
    /// <param name="value2">目标值。</param>
    /// <param name="amount">介于0和1之间的值，表示value2的权重。</param>
    /// <returns>插值后的值。</returns>
    /// <remarks>此方法基于以下公式执行线性插值：
    /// <code>value1 + (value2 - value1) * amount</code>。
    /// 当amount为0时返回value1，当amount为1时返回value2。
    /// 有关在边缘情况下精度更高的低效版本，请参见<see cref="M:Microsoft.Xna.Framework.MathHelper.LerpPrecise(System.Single,System.Single,System.Single)" />。
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

    /// <summary>返回两个值中较大的一个。</summary>
    /// <param name="value1">值1</param>
    /// <param name="value2">值2</param>
    /// <returns>较大的值。</returns>
    public static float Max(float value1, float value2) =>
        value1 <= (double)value2 ? value2 : value1;

    /// <summary>返回两个值中较大的一个。</summary>
    /// <param name="value1">值1</param>
    /// <param name="value2">值2</param>
    /// <returns>较大的值。</returns>
    public static int Max(int value1, int value2) => value1 <= value2 ? value2 : value1;

    /// <summary>返回两个值中较小的一个。</summary>
    /// <param name="value1">值1</param>
    /// <param name="value2">值2</param>
    /// <returns>较小的值。</returns>
    public static float Min(float value1, float value2) =>
        value1 >= (double)value2 ? value2 : value1;

    /// <summary>返回两个值中较小的一个。</summary>
    /// <param name="value1">值1</param>
    /// <param name="value2">值2</param>
    /// <returns>较小的值。</returns>
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

    /// <summary>将弧度转换为角度。</summary>
    /// <param name="radians">以弧度表示的角度。</param>
    /// <returns>以度为单位的角度。</returns>
    /// <remarks>
    /// 此方法在内部使用双精度，
    /// 尽管它返回单个浮点数
    /// Factor = 180 / pi
    ///</remarks>
    public static float ToDegrees(float radians) => radians * 57.29578f;

    /// <summary>将角度转换为弧度。</summary>
    /// <param name="degrees">以度为单位的角度。</param>
    /// <returns>以弧度表示的角度。</returns>
    /// <remarks>
    /// 此方法在内部使用双精度，
    /// 尽管它返回单个浮点数
    /// Factor = pi / 180
    ///</remarks>
    public static float ToRadians(float degrees) => degrees * 0.01745329f;

    /// <summary>将给定的角度减小到π和-π之间的值。</summary>
    /// <param name="angle">要减小的角度，以弧度为单位。</param>
    /// <returns>以弧度表示的新角度。</returns>
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

    /// <summary>确定值是否为2的幂。</summary>
    /// <param name="value">一个值。</param>
    /// <returns>如果<c>value</c>是2的幂，则为<c>true</c>；否则为<c>false</c>。</returns>
    public static bool IsPowerOfTwo(int value) => value > 0 && (value & value - 1) == 0;
}
