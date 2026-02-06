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
        /// 单位id及刷新概率
        ///(单位id,刷新概率)
        ///单个概率是与所有概率之和的比例
        /// </summary>
        public List<List<int>> UnitList { get; set; }
        /// <summary>
        /// 单位数量区间
        ///(最小刷新量，最大刷新量)
        /// </summary>
        public List<int> CountInterval { get; set; }
        /// <summary>
        /// 单位与单位之间刷新间隔（帧数）
        /// </summary>
        public int Interval { get; set; }

        public UnitGroupData(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_UnitGroupData, id);//public const string Config_UnitGroupData = "cfg_UnitGroupData"; 
			GroupId = (int)dict["GroupId"];
			Name = (string)dict["Name"];
			Describe = (string)dict["Describe"];
			ShowDescribe = (string)dict["ShowDescribe"];
			UnitList = (List<List<int>>)dict["UnitList"];
			CountInterval = (List<int>)dict["CountInterval"];
			Interval = (int)dict["Interval"];
			InitData();
        }

        
        public UnitGroupData(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_UnitGroupData, cfg_id);//public const string Config_UnitGroupData = "cfg_UnitGroupData"; 
			GroupId = (int)dict["GroupId"];
			Name = (string)dict["Name"];
			Describe = (string)dict["Describe"];
			ShowDescribe = (string)dict["ShowDescribe"];
			UnitList = (List<List<int>>)dict["UnitList"];
			CountInterval = (List<int>)dict["CountInterval"];
			Interval = (int)dict["Interval"];
			InitData();
        }

        public UnitGroupData(Dictionary<string, object> dict)
        {
			GroupId = (int)dict["GroupId"];
			Name = (string)dict["Name"];
			Describe = (string)dict["Describe"];
			ShowDescribe = (string)dict["ShowDescribe"];
			UnitList = (List<List<int>>)dict["UnitList"];
			CountInterval = (List<int>)dict["CountInterval"];
			Interval = (int)dict["Interval"];
			InitData();
        }
        #endregion
    }
}
