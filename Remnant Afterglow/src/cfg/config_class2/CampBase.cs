using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类2 CampBase 用于 阵营基础数据,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class CampBase
    {
        //盟友组名列表
        public Dictionary<BaseObjectType, List<string>> AllyGroupNameList = new Dictionary<BaseObjectType, List<string>>();
        //中立组名列表
        public Dictionary<BaseObjectType, List<string>> NeutralGroupNameList = new Dictionary<BaseObjectType, List<string>>();
        //敌对祖名列表
        public Dictionary<BaseObjectType, List<string>> HostileGroupNameList = new Dictionary<BaseObjectType, List<string>>();
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
            foreach (int Id in AllyList)//盟友组名列表
            {
                AllyGroupNameList[BaseObjectType.BaseFloor].Add(MapCamp.CampName_Floor + Id);
                AllyGroupNameList[BaseObjectType.BaseUnit].Add(MapCamp.CampName_Unit + Id);
                AllyGroupNameList[BaseObjectType.BaseTower].Add(MapCamp.CampName_Tower + Id);
                AllyGroupNameList[BaseObjectType.BaseBuild].Add(MapCamp.CampName_Build + Id);
                AllyGroupNameList[BaseObjectType.BaseBullet].Add(MapCamp.CampName_Bullet + Id);
                AllyGroupNameList[BaseObjectType.BaseWorker].Add(MapCamp.CampName_Worker + Id);
            }
            foreach (int Id in NeutralList)//中立
            {
                NeutralGroupNameList[BaseObjectType.BaseFloor].Add(MapCamp.CampName_Floor + Id);
                NeutralGroupNameList[BaseObjectType.BaseUnit].Add(MapCamp.CampName_Unit + Id);
                NeutralGroupNameList[BaseObjectType.BaseTower].Add(MapCamp.CampName_Tower + Id);
                NeutralGroupNameList[BaseObjectType.BaseBuild].Add(MapCamp.CampName_Build + Id);
                NeutralGroupNameList[BaseObjectType.BaseBullet].Add(MapCamp.CampName_Bullet + Id);
                NeutralGroupNameList[BaseObjectType.BaseWorker].Add(MapCamp.CampName_Worker + Id);
            }
            foreach (int Id in HostileList)//敌对
            {
                HostileGroupNameList[BaseObjectType.BaseFloor].Add(MapCamp.CampName_Floor + Id);
                HostileGroupNameList[BaseObjectType.BaseUnit].Add(MapCamp.CampName_Unit + Id);
                HostileGroupNameList[BaseObjectType.BaseTower].Add(MapCamp.CampName_Tower + Id);
                HostileGroupNameList[BaseObjectType.BaseBuild].Add(MapCamp.CampName_Build + Id);
                HostileGroupNameList[BaseObjectType.BaseBullet].Add(MapCamp.CampName_Bullet + Id);
                HostileGroupNameList[BaseObjectType.BaseWorker].Add(MapCamp.CampName_Worker + Id);
            }
        }

        /// <summary>
        /// 获取对应实体类型的盟友列表
        /// </summary>
        /// <returns></returns>
        public List<string> GetAllyList(BaseObjectType type)
        {
            return AllyGroupNameList[type];
        }

        /// <summary>
        /// 获取对应实体类型的中立列表
        /// </summary>
        /// <returns></returns>
        public List<string> GetNeutralList(BaseObjectType type)
        {
            return NeutralGroupNameList[type];
        }


        /// <summary>
        /// 获取敌对组列表
        /// </summary>
        /// <returns>一个包含对应类型的 所有敌对阵营的组名的列表</returns>
        public List<string> GetHostileList(BaseObjectType type)
        {
            return HostileGroupNameList[type];
        }



    }
}
