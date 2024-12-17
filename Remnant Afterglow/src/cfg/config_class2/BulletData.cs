namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类2 BulletData 用于 子弹基础数据表,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class BulletData
    {
        /// <summary>
        /// 场景路径
        /// </summary>
        public string ScenePath;
        /// <summary>
        /// 创建配置时，初始化数据-构造函数中运行
        /// </summary>
        public void InitData()
        {
             
        }

        /// <summary>
        /// 创建缓存时，初始化数据-构造函数后运行
        /// </summary>        
        public void InitData2()
        {
            BulletScene bulletScene = ConfigCache.GetBulletScene(SceneType);
            ScenePath = bulletScene.ScenePath;
        }
    }
}
