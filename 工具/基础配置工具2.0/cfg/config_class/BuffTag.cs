using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 BuffTag 用于 buff标签数据,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class BuffTag
    {
        #region 参数及初始化
        /// <summary>
        /// buff标签Id
        /// </summary>
        public int TagId { get; set; }
        /// <summary>
        /// 标签名称
        /// </summary>
        public string TagName { get; set; }
        /// <summary>
        /// 覆盖
        ///实体拥有存在该标签的buff时，
        ///再添加存在以下标签的其他buff，旧标签的所有buff都会被移除
        ///可以填自身
        ///这样表明有标签的buff只能存在一个
        ///举例：buff1和buff2 都有tag1
        ///tag1的覆盖id填写了tag2,那么当添加buff3(有tag2)时，buff1和buff2都移除
        /// </summary>
        public HashSet<int> ReplaceTagIdList { get; set; }
        /// <summary>
        /// 互斥
        ///实体拥有存在该标签的buff时，
        ///不能再添加存在以下标签的其他buff，
        ///可以禁止自身，表明只能加一次的buff（过期后可继续）
        ///（也可以设置为永久，用于实现免疫buff功能）
        ///举例，buff1有tag1，tag1互斥tag2
        ///那么有tag2的buff就加不上去
        /// </summary>
        public HashSet<int> BanTagIdList { get; set; }

        public BuffTag(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BuffTag, id);//public const string Config_BuffTag = "cfg_BuffTag"; 
			TagId = (int)dict["TagId"];
			TagName = (string)dict["TagName"];
			ReplaceTagIdList = (HashSet<int>)dict["ReplaceTagIdList"];
			BanTagIdList = (HashSet<int>)dict["BanTagIdList"];
			InitData();
        }

        
        public BuffTag(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BuffTag, cfg_id);//public const string Config_BuffTag = "cfg_BuffTag"; 
			TagId = (int)dict["TagId"];
			TagName = (string)dict["TagName"];
			ReplaceTagIdList = (HashSet<int>)dict["ReplaceTagIdList"];
			BanTagIdList = (HashSet<int>)dict["BanTagIdList"];
			InitData();
        }

        public BuffTag(Dictionary<string, object> dict)
        {
			TagId = (int)dict["TagId"];
			TagName = (string)dict["TagName"];
			ReplaceTagIdList = (HashSet<int>)dict["ReplaceTagIdList"];
			BanTagIdList = (HashSet<int>)dict["BanTagIdList"];
			InitData();
        }
        #endregion
    }
}
