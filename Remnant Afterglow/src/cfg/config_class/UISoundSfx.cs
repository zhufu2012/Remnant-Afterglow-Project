using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 UISoundSfx 用于 UI音效配置,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class UISoundSfx
    {
        #region 参数及初始化
        /// <summary>
        /// UI组件分组名称
        /// </summary>
        public string UIName { get; set; }
        /// <summary>
        /// 音效文件名称
        /// </summary>
        public string SfxName { get; set; }
        /// <summary>
        /// 组件类型
        ///0 任何ui
        ///1 按钮 Button
        ///2 纹理按钮 TextureButton
        /// </summary>
        public int UIType { get; set; }
        /// <summary>
        /// UI组件的触发事件列表
        ///1 点击事件 
        ///仅对按钮类（Button TextureButton等）有效果
        ///2 组件获得焦点
        ///3 失去焦点
        ///4 鼠标进入组件
        ///5 鼠标离开控件 
        ///
        /// </summary>
        public List<int> EventIdList { get; set; }
        /// <summary>
        /// 音效文件路径
        ///.\assets\sound\下的路径
        /// </summary>
        public string SoundPath { get; set; }

        public UISoundSfx(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_UISoundSfx, id);//public const string Config_UISoundSfx = "cfg_UISoundSfx"; 
			UIName = (string)dict["UIName"];
			SfxName = (string)dict["SfxName"];
			UIType = (int)dict["UIType"];
			EventIdList = (List<int>)dict["EventIdList"];
			SoundPath = (string)dict["SoundPath"];
			InitData();
        }

        
        public UISoundSfx(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_UISoundSfx, cfg_id);//public const string Config_UISoundSfx = "cfg_UISoundSfx"; 
			UIName = (string)dict["UIName"];
			SfxName = (string)dict["SfxName"];
			UIType = (int)dict["UIType"];
			EventIdList = (List<int>)dict["EventIdList"];
			SoundPath = (string)dict["SoundPath"];
			InitData();
        }

        public UISoundSfx(Dictionary<string, object> dict)
        {
			UIName = (string)dict["UIName"];
			SfxName = (string)dict["SfxName"];
			UIType = (int)dict["UIType"];
			EventIdList = (List<int>)dict["EventIdList"];
			SoundPath = (string)dict["SoundPath"];
			InitData();
        }
        #endregion
    }
}
