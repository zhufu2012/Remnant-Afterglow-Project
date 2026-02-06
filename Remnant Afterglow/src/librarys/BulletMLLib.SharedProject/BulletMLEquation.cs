using System;
using System.Diagnostics;
using Equationator;

namespace BulletMLLib.SharedProject;

/// <summary>
/// 这是在BulletML节点中使用的方程。
/// 这是设置所有方程语法的简单方法。
/// </summary>
public class BulletMLEquation : Equation
{
    /// <summary>
    /// 用于获取随机值的随机数生成器
    /// </summary>
    private static readonly Random g_Random = new(DateTime.Now.Millisecond);

    public BulletMLEquation()
    {
        //添加我们将用于bulletml语法的特定函数
        AddFunction("rand", RandomValue);
        AddFunction("rank", GameDifficulty);
    }

    /// <summary>
    /// 用作bulletml方程中的回调函数
    /// </summary>
    /// <returns>随机值。</returns>
    private double RandomValue()
    {
        //此值是"$rand"，返回一个随机数
        return g_Random.NextDouble();
    }

    /// <summary>
    /// 获取游戏难度值
    /// </summary>
    /// <returns>游戏难度值。</returns>
    private double GameDifficulty()
    {
        //这个数字是"$rank"，表示游戏难度。
        Debug.Assert(null != GameManager.GameDifficulty);
        return GameManager.GameDifficulty();
    }
}
