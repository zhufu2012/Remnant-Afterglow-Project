using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类2 CampBase 用于 阵营基础数据,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class CampBase
    {
        /// <summary>
        /// 初始化数据-构造函数后运行
        /// </summary>
        public void InitData()
        {
        }

        /// <summary>
        /// 初始化数据-构造函数后运行-这里设置阵营组名称
        /// </summary>        
        public void InitData2()
        {
        }

        /// <summary>
        /// 炮塔，建筑获取阵营的敌对阵营的层级
        /// </summary>
        public static uint GetCampLayer()
        {
            switch (SaveLoadSystem.NowSaveData.Camp)
            {
                case 1:
                    return Common.CalculateMaskSum([2, 3, 4]);
                case 2:
                    return Common.CalculateMaskSum([1, 3, 4]);
                case 3:
                    return Common.CalculateMaskSum([1, 2, 4]);
                case 4:
                    return Common.CalculateMaskSum([1, 2, 3]);
                default:
                    return Common.CalculateMaskSum([1, 2, 3, 4]);
            }

        }

        /// <summary>
        /// 单位获取阵营的敌对阵营的层级
        /// </summary>
        /// <param name="camp"></param>
        /// <returns></returns>
        public static uint GetCampLayer(int camp)
        {
            switch (camp)
            {
                case 1:
                    return Common.CalculateMaskSum([2, 3, 4]);
                case 2:
                    return Common.CalculateMaskSum([1, 3, 4]);
                case 3:
                    return Common.CalculateMaskSum([1, 2, 4]);
                case 4:
                    return Common.CalculateMaskSum([1, 2, 3]);
                default:
                    return Common.CalculateMaskSum([1, 2, 3, 4]);
            }

        }

    }
}
