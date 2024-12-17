namespace BulletMLLib.SharedProject
{
    /// <summary>
    /// 这是一个用于创建新子弹的模板。
    /// 这些对象存储在子弹对象中，并用于发射更多的子弹。
    /// 似乎每个子弹任务都有一个对应的 FireData 对象。
    /// 它们默认初始化为 0，并在任务执行时由任务设置。
    /// </summary>
    public class FireData
    {
        #region Members

        /// <summary>
        /// 使用此 FireData 对象发射的子弹的初始速度。
        /// </summary>
        public float srcSpeed = 0;

        /// <summary>
        /// 使用此 FireData 对象发射的子弹的初始方向。
        /// </summary>
        public float srcDir = 0;

        /// <summary>
        /// 我不太明白这个字段的作用... 如果为 false，子弹的初始速度将默认为 1？
        /// </summary>
        public bool speedInit = false;

        #endregion //Members
    }
}