using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 UnitGroupData 用于 单位组配置,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class UnitGroupData
    {
        #region 参数及初始化
        /// <summary>        
        /// 单位组ID
        /// </summary>
        public int GroupId { get; set; }
        /// <summary>        
        /// 单位组类型
        ///cfg_UnitGroupType_单位组类型id
        /// </summary>
        public int GroupType { get; set; }
        /// <summary>        
        /// 单位组名称
        /// </summary>
        public string Name { get; set; }
        /// <summary>        
        /// 单位组描述
        /// </summary>
        public string Describe { get; set; }
        /// <summary>        
        /// 单位组出场描述
        /// </summary>
        public string ShowDescribe { get; set; }
        /// <summary>        
        /// 单位组头领id
        ///cfg_UnitData_单位基础表id
        /// </summary>
        public int CaptainId { get; set; }
        /// <summary>        
        /// 单位组其他单位id列表
        /// </summary>
        public List<List<int>> TempLateList { get; set; }

        public UnitGroupData(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_UnitGroupData, id);//public const string Config_UnitGroupData = "cfg_UnitGroupData"; 
			GroupId = (int)dict["GroupId"];
			GroupType = (int)dict["GroupType"];
			Name = (string)dict["Name"];
			Describe = (string)dict["Describe"];
			ShowDescribe = (string)dict["ShowDescribe"];
			CaptainId = (int)dict["CaptainId"];
			TempLateList = (List<List<int>>)dict["TempLateList"];
			InitData();
        }

        
        public UnitGroupData(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_UnitGroupData, cfg_id);//public const string Config_UnitGroupData = "cfg_UnitGroupData"; 
			GroupId = (int)dict["GroupId"];
			GroupType = (int)dict["GroupType"];
			Name = (string)dict["Name"];
			Describe = (string)dict["Describe"];
			ShowDescribe = (string)dict["ShowDescribe"];
			CaptainId = (int)dict["CaptainId"];
			TempLateList = (List<List<int>>)dict["TempLateList"];
			InitData();
        }

        public UnitGroupData(Dictionary<string, object> dict)
        {
			GroupId = (int)dict["GroupId"];
			GroupType = (int)dict["GroupType"];
			Name = (string)dict["Name"];
			Describe = (string)dict["Describe"];
			ShowDescribe = (string)dict["ShowDescribe"];
			CaptainId = (int)dict["CaptainId"];
			TempLateList = (List<List<int>>)dict["TempLateList"];
			InitData();
        }
        #endregion
    }
}
