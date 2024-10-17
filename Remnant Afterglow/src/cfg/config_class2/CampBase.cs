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
            foreach (int Id in AllyList)
            {
                AllyGroupNameList[BaseObjectType.BaseFloor].Add(MapGroup.GroupName_Floor + Id);
                AllyGroupNameList[BaseObjectType.BaseUnit].Add(MapGroup.GroupName_Unit + Id);
                AllyGroupNameList[BaseObjectType.BaseTower].Add(MapGroup.GroupName_Tower + Id);
                AllyGroupNameList[BaseObjectType.BaseBuild].Add(MapGroup.GroupName_Build + Id);
                AllyGroupNameList[BaseObjectType.BaseBullet].Add(MapGroup.GroupName_Bullet + Id);
            }
            foreach (int Id in NeutralList)
            {
                NeutralGroupNameList[BaseObjectType.BaseFloor].Add(MapGroup.GroupName_Floor + Id);
                NeutralGroupNameList[BaseObjectType.BaseUnit].Add(MapGroup.GroupName_Unit + Id);
                NeutralGroupNameList[BaseObjectType.BaseTower].Add(MapGroup.GroupName_Tower + Id);
                NeutralGroupNameList[BaseObjectType.BaseBuild].Add(MapGroup.GroupName_Build + Id);
                NeutralGroupNameList[BaseObjectType.BaseBullet].Add(MapGroup.GroupName_Bullet + Id);
            }
            foreach (int Id in HostileList)
            {
                HostileGroupNameList[BaseObjectType.BaseFloor].Add(MapGroup.GroupName_Floor + Id);
                HostileGroupNameList[BaseObjectType.BaseUnit].Add(MapGroup.GroupName_Unit + Id);
                HostileGroupNameList[BaseObjectType.BaseTower].Add(MapGroup.GroupName_Tower + Id);
                HostileGroupNameList[BaseObjectType.BaseBuild].Add(MapGroup.GroupName_Build + Id);
                HostileGroupNameList[BaseObjectType.BaseBullet].Add(MapGroup.GroupName_Bullet + Id);
            }
        }

        /// <summary>
        /// 获取盟友列表
        /// </summary>
        /// <returns></returns>
        public List<string> GetAllyList(BaseObjectType type)
        {
            return AllyGroupNameList[type];
        }

        /// <summary>
        /// 获取中立列表
        /// </summary>
        /// <returns></returns>
        public List<string> GetNeutralList(BaseObjectType type)
        {
            return NeutralGroupNameList[type];
        }


        /// <summary>
        /// 获取敌对列表
        /// </summary>
        /// <returns></returns>
        public List<string> GetHostileList(BaseObjectType type)
        {
            return HostileGroupNameList[type];
        }



    }
}
