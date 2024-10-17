using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 BigMapBigCell 用于 大地图大结构,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class BigMapBigCell
    {
        #region 参数及初始化
        /// <summary>        
        /// 地图大型结构id
        /// </summary>
        public int BigStructId { get; set; }
        /// <summary>        
        /// 地图大型结构名称
        /// </summary>
        public string BigStructName { get; set; }
        /// <summary>        
        /// 绘制层
        /// </summary>
        public int Layer { get; set; }
        /// <summary>        
        /// 大小
        /// (X,Y)
        /// </summary>
        public List<int> Size { get; set; }
        /// <summary>        
        /// 大结构的材料结构
        ///（X,Y,生成地图材料id）列表
        /// </summary>
        public List<List<int>> StructList { get; set; }
        /// <summary>        
        /// 随机生成还是固定位置生成
        ///0表示随机生成
        ///（随机生成就根据每个格子生成概率检测，注意，生成是在墙壁之后生成，会检测是否有足够空地，没有足够空地不生成）
        ///1表示固定位置生成
        ///（固定生成就根据固定生成位置列表，这里不会管是否有墙壁，绝对强制生成，可以在边界生成（只生成一半也行））
        ///
        /// </summary>
        public int GeneratBigType { get; set; }
        /// <summary>        
        /// 是否使用固定种子
        ///
        /// </summary>
        public bool IsUserSeed { get; set; }
        /// <summary>        
        /// 固定种子
        /// </summary>
        public int Seed { get; set; }
        /// <summary>        
        /// 每个格子生成概率(百万分比)
        ///每个格子都会检测一次，
        ///满足概率就生成
        ///当某个格子已经生成了大结构，就不在生成
        /// </summary>
        public float Probability { get; set; }
        /// <summary>        
        /// 固定生成位置列表
        ///(X，Y)
        /// </summary>
        public List<List<int>> PosList { get; set; }

        public BigMapBigCell(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BigMapBigCell, id);//public const string Config_BigMapBigCell = "cfg_BigMapBigCell"; 
			BigStructId = (int)dict["BigStructId"];
			BigStructName = (string)dict["BigStructName"];
			Layer = (int)dict["Layer"];
			Size = (List<int>)dict["Size"];
			StructList = (List<List<int>>)dict["StructList"];
			GeneratBigType = (int)dict["GeneratBigType"];
			IsUserSeed = (bool)dict["IsUserSeed"];
			Seed = (int)dict["Seed"];
			Probability = (float)dict["Probability"];
			PosList = (List<List<int>>)dict["PosList"];
			InitData();
        }

        
        public BigMapBigCell(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BigMapBigCell, cfg_id);//public const string Config_BigMapBigCell = "cfg_BigMapBigCell"; 
			BigStructId = (int)dict["BigStructId"];
			BigStructName = (string)dict["BigStructName"];
			Layer = (int)dict["Layer"];
			Size = (List<int>)dict["Size"];
			StructList = (List<List<int>>)dict["StructList"];
			GeneratBigType = (int)dict["GeneratBigType"];
			IsUserSeed = (bool)dict["IsUserSeed"];
			Seed = (int)dict["Seed"];
			Probability = (float)dict["Probability"];
			PosList = (List<List<int>>)dict["PosList"];
			InitData();
        }

        public BigMapBigCell(Dictionary<string, object> dict)
        {
			BigStructId = (int)dict["BigStructId"];
			BigStructName = (string)dict["BigStructName"];
			Layer = (int)dict["Layer"];
			Size = (List<int>)dict["Size"];
			StructList = (List<List<int>>)dict["StructList"];
			GeneratBigType = (int)dict["GeneratBigType"];
			IsUserSeed = (bool)dict["IsUserSeed"];
			Seed = (int)dict["Seed"];
			Probability = (float)dict["Probability"];
			PosList = (List<List<int>>)dict["PosList"];
			InitData();
        }
        #endregion
    }
}
