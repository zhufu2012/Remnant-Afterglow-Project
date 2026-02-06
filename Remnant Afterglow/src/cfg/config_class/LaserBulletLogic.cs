using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 LaserBulletLogic 用于 激光子弹逻辑表,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class LaserBulletLogic
    {
        #region 参数及初始化
        /// <summary>
        /// 激光Id
        /// </summary>
        public int LaserId { get; set; }
        /// <summary>
        /// 激光名称
        /// </summary>
        public string BulletName { get; set; }
        /// <summary>
        /// 激光每多少帧
        ///造成一次效果
        /// </summary>
        public int Frame { get; set; }
        /// <summary>
        /// 对护盾伤害
        /// </summary>
        public int ShieldHarm { get; set; }
        /// <summary>
        /// 对装甲伤害
        /// </summary>
        public int ArmourHarm { get; set; }
        /// <summary>
        /// 对结构伤害
        ///
        /// </summary>
        public int StructureHarm { get; set; }
        /// <summary>
        /// 穿透伤害
        ///直接对结构造成杀伤
        /// </summary>
        public int ElementHarm { get; set; }
        /// <summary>
        /// 击中添加buffId列表
        ///(buffId,添加层数)
        /// </summary>
        public List<List<int>> AddBuffList { get; set; }

        public LaserBulletLogic(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_LaserBulletLogic, id);//public const string Config_LaserBulletLogic = "cfg_LaserBulletLogic"; 
			LaserId = (int)dict["LaserId"];
			BulletName = (string)dict["BulletName"];
			Frame = (int)dict["Frame"];
			ShieldHarm = (int)dict["ShieldHarm"];
			ArmourHarm = (int)dict["ArmourHarm"];
			StructureHarm = (int)dict["StructureHarm"];
			ElementHarm = (int)dict["ElementHarm"];
			AddBuffList = (List<List<int>>)dict["AddBuffList"];
			InitData();
        }

        
        public LaserBulletLogic(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_LaserBulletLogic, cfg_id);//public const string Config_LaserBulletLogic = "cfg_LaserBulletLogic"; 
			LaserId = (int)dict["LaserId"];
			BulletName = (string)dict["BulletName"];
			Frame = (int)dict["Frame"];
			ShieldHarm = (int)dict["ShieldHarm"];
			ArmourHarm = (int)dict["ArmourHarm"];
			StructureHarm = (int)dict["StructureHarm"];
			ElementHarm = (int)dict["ElementHarm"];
			AddBuffList = (List<List<int>>)dict["AddBuffList"];
			InitData();
        }

        public LaserBulletLogic(Dictionary<string, object> dict)
        {
			LaserId = (int)dict["LaserId"];
			BulletName = (string)dict["BulletName"];
			Frame = (int)dict["Frame"];
			ShieldHarm = (int)dict["ShieldHarm"];
			ArmourHarm = (int)dict["ArmourHarm"];
			StructureHarm = (int)dict["StructureHarm"];
			ElementHarm = (int)dict["ElementHarm"];
			AddBuffList = (List<List<int>>)dict["AddBuffList"];
			InitData();
        }
        #endregion
    }
}
