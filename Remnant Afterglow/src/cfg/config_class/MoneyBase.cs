using System.Collections.Generic;
using Godot;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 MoneyBase 用于 货币配置,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class MoneyBase
    {
        #region 参数及初始化
        /// <summary>        
        /// 货币id
        /// </summary>
        public int MoneyId { get; set; }
        /// <summary>        
        /// 货币名称
        /// </summary>
        public string MoneyName { get; set; }
        /// <summary>        
        /// 货币类型
        ///1 大地图显示
        ///2 作战地图显示
        /// </summary>
        public int MoneyType { get; set; }
        /// <summary>        
        /// 货币类型 1 存档创建时初始值
        ///货币类型 2 作战地图开始时默认初始值+所在地图给定初始值
        /// </summary>
        public int NowValue { get; set; }
        /// <summary>        
        /// 最大值
        /// </summary>
        public int Max { get; set; }
        /// <summary>        
        /// 货币图片
        /// </summary>
        public Texture2D MoneyImg { get; set; }
        /// <summary>        
        /// 货币图片界面显示
        /// </summary>
        public Texture2D MoneyImgShow { get; set; }

        public MoneyBase(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_MoneyBase, id);//public const string Config_MoneyBase = "cfg_MoneyBase"; 
			MoneyId = (int)dict["MoneyId"];
			MoneyName = (string)dict["MoneyName"];
			MoneyType = (int)dict["MoneyType"];
			NowValue = (int)dict["NowValue"];
			Max = (int)dict["Max"];
			MoneyImg = (Texture2D)dict["MoneyImg"];
			MoneyImgShow = (Texture2D)dict["MoneyImgShow"];
			InitData();
        }

        
        public MoneyBase(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_MoneyBase, cfg_id);//public const string Config_MoneyBase = "cfg_MoneyBase"; 
			MoneyId = (int)dict["MoneyId"];
			MoneyName = (string)dict["MoneyName"];
			MoneyType = (int)dict["MoneyType"];
			NowValue = (int)dict["NowValue"];
			Max = (int)dict["Max"];
			MoneyImg = (Texture2D)dict["MoneyImg"];
			MoneyImgShow = (Texture2D)dict["MoneyImgShow"];
			InitData();
        }

        public MoneyBase(Dictionary<string, object> dict)
        {
			MoneyId = (int)dict["MoneyId"];
			MoneyName = (string)dict["MoneyName"];
			MoneyType = (int)dict["MoneyType"];
			NowValue = (int)dict["NowValue"];
			Max = (int)dict["Max"];
			MoneyImg = (Texture2D)dict["MoneyImg"];
			MoneyImgShow = (Texture2D)dict["MoneyImgShow"];
			InitData();
        }
        #endregion
    }
}
