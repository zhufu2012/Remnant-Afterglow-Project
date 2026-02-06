using GameLog;
using Godot;
using ManagedAttributes;
using System;
using System.Collections.Generic;
using System.Text.Json;

namespace Remnant_Afterglow
{
    public class GlobalConfig
    {
        #region 参数及初始化
        /// <summary>
        /// 全局配置id
        /// </summary>
        public string Configid { get; set; }
        /// <summary>
        /// 全局配置名称
        /// </summary>
        public string ConfigName { get; set; }
        /// <summary>
        /// 设置-特殊参数中是否显示
        /// </summary>
        public bool ShopSetting { get; set; }
        /// <summary>
        /// 设置-特殊参数中是否可以修改
        /// </summary>
        public bool IsModif { get; set; }
        /// <summary>
        /// 全局配置值
        /// </summary>
        public object ConfigValue { get; set; }
        public GlobalConfig(string config_path, int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(config_path, id);
            Configid = (string)dict["ConfigId"];
            ConfigName = (string)dict["ConfigName"];
            ConfigValue = dict["ConfigValue"];
            if(dict.ContainsKey("ShopSetting"))
                ShopSetting = (bool)dict["ShopSetting"];
            if(dict.ContainsKey("IsModif"))
                IsModif = (bool)dict["IsModif"];
        }

        public GlobalConfig(Dictionary<string, object> dict)
        {
            Configid = (string)dict["ConfigId"];
            ConfigName = (string)dict["ConfigName"];
            ConfigValue = dict["ConfigValue"];
            if(dict.ContainsKey("ShopSetting"))
                ShopSetting = (bool)dict["ShopSetting"];
            if(dict.ContainsKey("IsModif"))
                IsModif = (bool)dict["IsModif"];
        }
        #endregion
    }
    /// <summary>
    /// 全局的配置缓存类，用于快速存储和检索配置信息
    /// 为了更好的性能
    /// </summary>
    public static partial class ConfigCache
    {
        public static void InitConfigCache()
        {
            LoadGlobalConfig();//全局默认配置缓存
            LoadOtherCache();//加载其他配置缓存
            LoadAllAttrData();//加载属性数据缓存
            //LoadAllAttrTemplate();//加载所有属性模板
            //LoadAllObjectAttr();//准备所有实体的属性数据
        }
        #region 全局默认配置缓存
        /// <summary>
        /// 全局默认配置缓存 <数据类型，>
        /// </summary>
        private static readonly Dictionary<string, GlobalConfig> GlobalDataCache = new Dictionary<string, GlobalConfig>();
        public static void LoadGlobalConfig()
        {
            Dictionary<string, Dictionary<string, object>> global_float_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_GlobalConfigFloat);
            Dictionary<string, Dictionary<string, object>> global_int_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_GlobalConfigInt);
            Dictionary<string, Dictionary<string, object>> global_list_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_GlobalConfigList);
            Dictionary<string, Dictionary<string, object>> global_str_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_GlobalConfigStr);
            Dictionary<string, Dictionary<string, object>> global_png_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_GlobalConfigPng);
            foreach (var val in global_float_dict)
            {
                GlobalDataCache[val.Key] = new GlobalConfig(val.Value);
            }
            foreach (var val in global_int_dict)
            {
                GlobalDataCache[val.Key] = new GlobalConfig(val.Value);
            }
            foreach (var val in global_list_dict)
            {
                GlobalDataCache[val.Key] = new GlobalConfig(val.Value);
            }
            foreach (var val in global_str_dict)
            {
                GlobalDataCache[val.Key] = new GlobalConfig(val.Value);
            }
            foreach (var val in global_png_dict)
            {
                GlobalDataCache[val.Key] = new GlobalConfig(val.Value);
            }
        }


        /// <summary>
        /// 优先使用修改过的配置值
        /// </summary>
        /// <param name="cfgId"></param>
        /// <returns></returns>
        public static int GetGlobal_Int(string cfgId)
        {
            // 检查是否有用户修改的值
            object modifiedValue = ConfigPersistenceManager.GetModifiedConfigValue(cfgId);
            if (modifiedValue != null)
            {
                if (modifiedValue is JsonElement jsonElement)
                {
                    return jsonElement.GetInt32();
                }
                return Convert.ToInt32(modifiedValue);
            }

            if (!GlobalDataCache.TryGetValue(cfgId, out GlobalConfig data))
            {
                return 0;
            }
            return (int)data.ConfigValue;
        }

        public static string GetGlobal_Str(string cfgId)
        {
            // 检查是否有用户修改的值
            object modifiedValue = ConfigPersistenceManager.GetModifiedConfigValue(cfgId);
            if (modifiedValue != null)
            {
                if (modifiedValue is JsonElement jsonElement)
                {
                    return jsonElement.GetString();
                }
                return modifiedValue.ToString();
            }

            if (!GlobalDataCache.TryGetValue(cfgId, out GlobalConfig data))
            {
                return "";
            }
            return (string)data.ConfigValue;
        }

        public static float GetGlobal_Float(string cfgId)
        {
            // 检查是否有用户修改的值
            object modifiedValue = ConfigPersistenceManager.GetModifiedConfigValue(cfgId);
            if (modifiedValue != null)
            {
                if (modifiedValue is JsonElement jsonElement)
                {
                    return jsonElement.GetSingle();
                }
                return Convert.ToSingle(modifiedValue);
            }

            if (!GlobalDataCache.TryGetValue(cfgId, out GlobalConfig data))
            {
                return 0;
            }
            return (float)data.ConfigValue;
        }

        public static List<int> GetGlobal_List(string cfgId)
        {
            if (!GlobalDataCache.TryGetValue(cfgId, out GlobalConfig data))
            {
                return null;
            }
            return (List<int>)data.ConfigValue;
        }

        public static Texture2D GetGlobal_Png(string cfgId)
        {
            if (!GlobalDataCache.TryGetValue(cfgId, out GlobalConfig data))
            {
                return null;
            }
            return (Texture2D)data.ConfigValue;
        }


        public static void UpdateGlobalConfigValue(string configId, object newValue)
        {
            if (GlobalDataCache.TryGetValue(configId, out GlobalConfig config))
            {
                // 更新内存中的值
                config.ConfigValue = newValue;

                // 保存到持久化存储
                ConfigPersistenceManager.SetModifiedConfigValue(configId, newValue);
            }
        }


        /// <summary>
        /// 获取需要显示的全局配置
        /// </summary>
        public static List<GlobalConfig> GetShopConfigs()
        {
            List<GlobalConfig> shopConfigs = new List<GlobalConfig>();
            foreach (var kvp in GlobalDataCache)
            {
                if (kvp.Value.ShopSetting)
                {
                    shopConfigs.Add(kvp.Value);
                }
            }
            return shopConfigs;
        }
        #endregion

        #region 实体属性配置

        /// <summary>
        /// 属性字典 <实体id,属性列表>
        /// </summary>
        private static readonly Dictionary<int, List<AttributeData>> AttrDict = new Dictionary<int, List<AttributeData>>();

        /// <summary>
        /// 加载所有实体属性数据
        /// </summary>
        private static void LoadAllAttrData()
        {
            List<AttributeData> list = GetAllAttributeData(); // 获取所有属性数据
            foreach (AttributeData attr in list)
            {
                if (AttrDict.ContainsKey(attr.ObjectId))
                {
                    AttrDict[attr.ObjectId].Add(attr); // 如果键存在，则直接添加
                }
                else
                {
                    AttrDict[attr.ObjectId] = new List<AttributeData> { attr }; // 如果键不存在，则初始化一个新的列表并添加
                }
            }
        }

        /// <summary>
        /// 属性模板字典 <模板id,属性列表>
        /// ManagAttrCon attributeContainer
        /// </summary>
        private static readonly Dictionary<int, ManagAttrCon> AttrConDict = new Dictionary<int, ManagAttrCon>();


        /// <summary>
        /// 属性模板字典 <实体id,属性列表>
        /// ManagAttrCon attributeContainer
        /// </summary>
        private static readonly Dictionary<int, ManagAttrCon> AttrConTemDict = new Dictionary<int, ManagAttrCon>();

        /// <summary>
        /// 加载所有属性模板 <模板id，模板属性容器>
        /// </summary>
        private static void LoadAllAttrTemplate()
        {
            List<AttributeTemplate> attributeTemplates = GetAllAttributeTemplate();
            foreach (AttributeTemplate attributeTemplate in attributeTemplates)
            {
                int ObjectId = attributeTemplate.ObjectId;
                List<AttributeData> attr_list = AttrDict[ObjectId];
                ManagAttrCon attributeContainer = new ManagAttrCon();
                foreach (var attr in attr_list)
                {
                    int AttributeId = attr.AttributeId;//属性id
                    AttributeData attrData = ConfigCache.GetAttributeData(ObjectId + "_" + AttributeId);
                    AttrData floatManaged = attrData.GetAttr();
                    floatManaged.IsTemplateAttr = true;
                    floatManaged.TemplateObjectId = ObjectId;
                    bool isCon = attributeContainer.Add(floatManaged);
                    if (!isCon)//添加不成功，说明存在重复属性
                        Log.Error($"错误属性模板在出现重复属性! 模板id:{attributeTemplate.TempLateId},重复属性id:{AttributeId}");
                }
                AttrConDict[attributeTemplate.TempLateId] = attributeContainer;
            }
        }
        /// <summary>
        /// 准备所有实体的属性容器
        /// </summary>
        private static void LoadAllObjectAttr()
        {
            List<BaseObjectData> baseObjects = GetAllBaseObjectData();
            foreach (var baseData in baseObjects)
            {
                ManagAttrCon attributeContainer = new ManagAttrCon();
                foreach (int TempLateId in baseData.TempLateList)//模板属性-合并多个模板的属性
                {
                    AttributeTemplate template = GetAttributeTemplate(TempLateId);
                    attributeContainer.Merge(GetTempAttrComtainer(TempLateId), template.IsCover);
                }
                List<AttributeData> attrList = GetAttrList(baseData.ObjectId);
                foreach (AttributeData attr in attrList)
                {
                    attributeContainer.Add(attr.GetAttr());
                }
                AttrConTemDict[baseData.ObjectId] = attributeContainer;
            }
        }

        /// <summary>
        /// 获取实体的属性列表
        /// </summary>
        /// <param name="ObjectId"></param>
        /// <returns></returns>
        public static List<AttributeData> GetAttrList(int ObjectId)
        {
            if (AttrDict.TryGetValue(ObjectId, out var attribute))
            {
                return attribute;
            }
            return new List<AttributeData>();
        }

        /// <summary>
        /// 获取某属性模板
        /// </summary>
        /// <param name="TempLateId"></param>
        /// <returns></returns>
        public static ManagAttrCon GetTempAttrComtainer(int TempLateId)
        {
            if (AttrConDict.TryGetValue(TempLateId, out var attribute))
            {
                return attribute;
            }
            return new ManagAttrCon();
        }

        /// <summary>
        /// 获取实体的属性容器
        /// </summary>
        /// <param name="ObjectId"></param>
        /// <returns></returns>
        public static ManagAttrCon GetObjectAttrComtainer(int ObjectId)
        {
            if (AttrConTemDict.TryGetValue(ObjectId, out var attribute))
            {
                return attribute;
            }
            return new ManagAttrCon();
        }
        #endregion


        #region 全局属性配置
        /// <summary>
        /// 全局属性属性模板字典 <模板id,属性列表>
        /// ManagAttrCon attributeContainer
        /// </summary>
        private static readonly Dictionary<int, ManagAttrCon> GloAttrTemDict = new Dictionary<int, ManagAttrCon>();
        

        #endregion

    }
}
