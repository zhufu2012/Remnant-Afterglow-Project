namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类2 MapBuildItem 用于 建造项数据,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class MapBuildItem
    {
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
        }

        /// <summary>
        /// 获取建筑数据
        /// </summary>
        /// <returns></returns>
        public BuildData GetBuildData()
        {
            return ConfigCache.GetBuildData(ObjectId);
        }
    }
}
