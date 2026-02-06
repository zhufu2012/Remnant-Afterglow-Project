using System.Collections.Generic;
using Godot;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 WorkerData 用于 无人机基础表,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class WorkerData
    {
        #region 参数及初始化
        /// <summary>
        /// 实体id
        /// </summary>
        public int ObjectId { get; set; }
        /// <summary>
        /// 无人机名称
        /// </summary>
        public string WorkerName { get; set; }
        /// <summary>
        /// 动画类型列表
        /// </summary>
        public List<int> AnimaTypeList { get; set; }
        /// <summary>
        /// 阴影图像
        /// </summary>
        public Texture2D ShadowSprite { get; set; }
        /// <summary>
        /// 阴影偏移
        /// </summary>
        public Vector2 ShadowOffset { get; set; }

        public WorkerData(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_WorkerData, id);//public const string Config_WorkerData = "cfg_WorkerData"; 
			ObjectId = (int)dict["ObjectId"];
			WorkerName = (string)dict["WorkerName"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			ShadowSprite = (Texture2D)dict["ShadowSprite"];
			ShadowOffset = (Vector2)dict["ShadowOffset"];
			InitData();
        }

        
        public WorkerData(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_WorkerData, cfg_id);//public const string Config_WorkerData = "cfg_WorkerData"; 
			ObjectId = (int)dict["ObjectId"];
			WorkerName = (string)dict["WorkerName"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			ShadowSprite = (Texture2D)dict["ShadowSprite"];
			ShadowOffset = (Vector2)dict["ShadowOffset"];
			InitData();
        }

        public WorkerData(Dictionary<string, object> dict)
        {
			ObjectId = (int)dict["ObjectId"];
			WorkerName = (string)dict["WorkerName"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			ShadowSprite = (Texture2D)dict["ShadowSprite"];
			ShadowOffset = (Vector2)dict["ShadowOffset"];
			InitData();
        }
        #endregion
    }
}
