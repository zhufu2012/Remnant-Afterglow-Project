using GameLog;
using Godot;
using System.Collections.Generic;

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
		/// 全局配置值
		/// </summary>
		public object ConfigValue { get; set; }

		public GlobalConfig(string config_path, int id)
		{
			Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(config_path, id);
			Configid = (string)dict["Configid"];
			ConfigName = (string)dict["ConfigName"];
			ConfigValue = dict["ConfigValue"];
		}

		public GlobalConfig(Dictionary<string, object> dict)
		{
			Configid = (string)dict["Configid"];
			ConfigName = (string)dict["ConfigName"];
			ConfigValue = dict["ConfigValue"];
		}
		#endregion
	}
	//全局的配置缓存类，用于快速存储和检索配置信息
	//为了更好的性能
	public static partial class ConfigCache
	{
		static ConfigCache()
		{
			LoadGlobalConfig();//全局默认配置缓存
			LoadOtherCache();//加载其他配置缓存
			LoadAllAttributeData();//加载属性数据缓存
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

		public static int GetGlobal_Int(string cfgId)
		{
			if (!GlobalDataCache.TryGetValue(cfgId, out GlobalConfig data))
			{
				return 0;
			}
			return (int)data.ConfigValue;
		}
		public static string GetGlobal_Str(string cfgId)
		{
			if (!GlobalDataCache.TryGetValue(cfgId, out GlobalConfig data))
			{
				return "";
			}
			return (string)data.ConfigValue;
		}
		public static float GetGlobal_Float(string cfgId)
		{
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
		#endregion

		#region 实体属性配置
		/// <summary>
		/// 属性字典 <实体id,属性列表>
		/// </summary>
		private static readonly Dictionary<int, List<AttributeData>> AttrDict = new Dictionary<int, List<AttributeData>>();
        /// <summary>
        /// 加载所有实体属性数据
        /// </summary>
        private static void LoadAllAttributeData()
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



        public static List<AttributeData> GetAttrList(int ObjectId)
		{
			if(AttrDict.TryGetValue(ObjectId, out var attribute))
			{
				return attribute;
			}
			return new List<AttributeData>();
		}

        #endregion

    }
}
