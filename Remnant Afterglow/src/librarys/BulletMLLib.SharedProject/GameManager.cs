namespace BulletMLLib.SharedProject;

/// <summary>
/// 这个类管理BulletML库使用的一些游戏变量
/// </summary>
public static class GameManager
{
    //TODO: 移除这个类并将游戏难度移入子弹管理器

    //TODO: 子弹发射时应存储难度

    /// <summary>
    /// 获取游戏难度的回调方法。
    /// 您需要在游戏开始时设置此方法
    /// </summary>
    static public FloatDelegate GameDifficulty;
}
