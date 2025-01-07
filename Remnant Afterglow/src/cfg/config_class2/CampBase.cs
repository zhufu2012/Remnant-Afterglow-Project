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
        /// 获取对应实体类型的盟友列表
        /// </summary>
        /// <returns></returns>
        public List<int> GetAllyList()
        {
            return AllyList;
        }

        /// <summary>
        /// 获取对应实体类型的中立列表
        /// </summary>
        /// <returns></returns>
        public List<int> GetNeutralList()
        {
            return NeutralList;
        }


        /// <summary>
        /// 获取敌对组列表
        /// </summary>
        /// <returns>一个包含对应类型的 所有敌对阵营的组名的列表</returns>
        public List<int> GetHostileList()
        {
            return HostileList;
        }



    }
}
