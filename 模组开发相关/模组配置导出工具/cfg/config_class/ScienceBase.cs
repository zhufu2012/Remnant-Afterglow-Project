using System.Collections.Generic;
using Godot;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 ScienceBase 用于 科技基础显示配置,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class ScienceBase
    {
        #region 参数及初始化
        /// <summary>        
        /// 科技id
        /// </summary>
        public int ScienceId { get; set; }
        /// <summary>        
        /// 科技显示文字
        /// </summary>
        public string ScienceName { get; set; }
        /// <summary>        
        /// 科技描述
        /// </summary>
        public string ScienceDes { get; set; }
        /// <summary>        
        /// 科技所属范围
        ///cfg_ScienceType_科技类型配置id
        ///
        /// </summary>
        public int ScienceRangeId { get; set; }
        /// <summary>        
        /// 科技所在位置
        ///(科技树网格中哪一列,哪一行)
        ///行列数必须大于等于1
        ///且同范围内最好不相同，相同后面会覆盖前面
        /// </summary>
        public Vector2I Pos { get; set; }
        /// <summary>        
        /// 线条连接哪些科技（尾部)
        ///cfg_ScienceBase_科技基础显示配置id列表
        /// </summary>
        public List<int> ConnectList { get; set; }
        /// <summary>        
        /// 科技标识图片
        /// </summary>
        public Texture2D SciencePng { get; set; }

        public ScienceBase(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_ScienceBase, id);//public const string Config_ScienceBase = "cfg_ScienceBase"; 
			ScienceId = (int)dict["ScienceId"];
			ScienceName = (string)dict["ScienceName"];
			ScienceDes = (string)dict["ScienceDes"];
			ScienceRangeId = (int)dict["ScienceRangeId"];
			Pos = (Vector2I)dict["Pos"];
			ConnectList = (List<int>)dict["ConnectList"];
			SciencePng = (Texture2D)dict["SciencePng"];
			InitData();
        }

        
        public ScienceBase(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_ScienceBase, cfg_id);//public const string Config_ScienceBase = "cfg_ScienceBase"; 
			ScienceId = (int)dict["ScienceId"];
			ScienceName = (string)dict["ScienceName"];
			ScienceDes = (string)dict["ScienceDes"];
			ScienceRangeId = (int)dict["ScienceRangeId"];
			Pos = (Vector2I)dict["Pos"];
			ConnectList = (List<int>)dict["ConnectList"];
			SciencePng = (Texture2D)dict["SciencePng"];
			InitData();
        }

        public ScienceBase(Dictionary<string, object> dict)
        {
			ScienceId = (int)dict["ScienceId"];
			ScienceName = (string)dict["ScienceName"];
			ScienceDes = (string)dict["ScienceDes"];
			ScienceRangeId = (int)dict["ScienceRangeId"];
			Pos = (Vector2I)dict["Pos"];
			ConnectList = (List<int>)dict["ConnectList"];
			SciencePng = (Texture2D)dict["SciencePng"];
			InitData();
        }
        #endregion
    }
}
