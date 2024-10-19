using System.Collections.Generic;
using Godot;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 MoneyBase 用于 货币界面显示配置,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class MoneyBase
    {
        #region 参数及初始化
        /// <summary>        
        /// 货币id
        /// </summary>
        public int MoneyId { get; set; }
        /// <summary>        
        /// 货币类型
        ///1 大地图显示
        ///2 地图显示
        ///3 不可见
        /// </summary>
        public int MoneyType { get; set; }
        /// <summary>        
        /// 货币名称
        /// </summary>
        public string MoneyName { get; set; }
        /// <summary>        
        /// 货币描述
        /// </summary>
        public string MoneyDescribe { get; set; }
        /// <summary>        
        /// 基础值
        /// </summary>
        public float NowValue { get; set; }
        /// <summary>        
        /// 最大值
        /// </summary>
        public float Max { get; set; }
        /// <summary>        
        /// 最小值
        /// </summary>
        public float Min { get; set; }
        /// <summary>        
        /// 再生值
        /// </summary>
        public float Regen { get; set; }
        /// <summary>        
        /// 再生帧数
        /// </summary>
        public float RegenFps { get; set; }
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
			MoneyType = (int)dict["MoneyType"];
			MoneyName = (string)dict["MoneyName"];
			MoneyDescribe = (string)dict["MoneyDescribe"];
			NowValue = (float)dict["NowValue"];
			Max = (float)dict["Max"];
			Min = (float)dict["Min"];
			Regen = (float)dict["Regen"];
			RegenFps = (float)dict["RegenFps"];
			MoneyImg = (Texture2D)dict["MoneyImg"];
			MoneyImgShow = (Texture2D)dict["MoneyImgShow"];
			InitData();
        }

        
        public MoneyBase(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_MoneyBase, cfg_id);//public const string Config_MoneyBase = "cfg_MoneyBase"; 
			MoneyId = (int)dict["MoneyId"];
			MoneyType = (int)dict["MoneyType"];
			MoneyName = (string)dict["MoneyName"];
			MoneyDescribe = (string)dict["MoneyDescribe"];
			NowValue = (float)dict["NowValue"];
			Max = (float)dict["Max"];
			Min = (float)dict["Min"];
			Regen = (float)dict["Regen"];
			RegenFps = (float)dict["RegenFps"];
			MoneyImg = (Texture2D)dict["MoneyImg"];
			MoneyImgShow = (Texture2D)dict["MoneyImgShow"];
			InitData();
        }

        public MoneyBase(Dictionary<string, object> dict)
        {
			MoneyId = (int)dict["MoneyId"];
			MoneyType = (int)dict["MoneyType"];
			MoneyName = (string)dict["MoneyName"];
			MoneyDescribe = (string)dict["MoneyDescribe"];
			NowValue = (float)dict["NowValue"];
			Max = (float)dict["Max"];
			Min = (float)dict["Min"];
			Regen = (float)dict["Regen"];
			RegenFps = (float)dict["RegenFps"];
			MoneyImg = (Texture2D)dict["MoneyImg"];
			MoneyImgShow = (Texture2D)dict["MoneyImgShow"];
			InitData();
        }
        #endregion
    }
}
