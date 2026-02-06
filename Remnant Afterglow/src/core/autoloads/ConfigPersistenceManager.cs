using Godot;
using System;
using System.Collections.Generic;
using System.Text.Json;
using System.Text.Json.Serialization;
using System.Text.Encodings.Web;
using System.Text.Unicode;

namespace Remnant_Afterglow
{
	/// <summary>
	/// 用户修改的配置数据
	/// </summary>
	public class ModifiedConfigData
	{
		[JsonInclude]
		public Dictionary<string, object> modifiedConfigs = new Dictionary<string, object>();

		public ModifiedConfigData()
		{
		}

		public ModifiedConfigData(Dictionary<string, object> data)
		{
			modifiedConfigs = data;
		}
	}

	/// <summary>
	/// 配置持久化管理器
	/// </summary>
	public partial class ConfigPersistenceManager : Node
	{
		private static string config_file_path = "res://data/ModifiedConfigs.json";
		private static Dictionary<string, object> modifiedConfigs = new Dictionary<string, object>();
		private static bool is_modified = false;
		private static double SaveInterval = 30.0; // 30秒保存一次
		private double SaveIntervalTime = 0;

		static JsonSerializerOptions jsonSerializerOptions = new JsonSerializerOptions()
		{
			WriteIndented = true,
			IncludeFields = true,
			ReferenceHandler = ReferenceHandler.IgnoreCycles,
			Encoder = JavaScriptEncoder.Create(UnicodeRanges.BasicLatin, UnicodeRanges.CjkUnifiedIdeographs, UnicodeRanges.CjkSymbolsandPunctuation)
		};

		static ConfigPersistenceManager()
		{
			LoadModifiedConfigs();
		}

		public override void _Ready()
		{
			// 添加到自动加载中
		}

		public override void _PhysicsProcess(double delta)
		{
			SaveIntervalTime += delta;
			if (SaveIntervalTime >= SaveInterval)
			{
				SaveModifiedConfigs();
				SaveIntervalTime = 0;
			}
		}

		public override void _ExitTree()
		{
			SaveModifiedConfigs(); // 退出时保存
		}

		// 加载修改过的配置
		private static void LoadModifiedConfigs()
		{
			if (FileAccess.FileExists(config_file_path))
			{
				try
				{
					using var file = FileAccess.Open(config_file_path, FileAccess.ModeFlags.Read);
					string jsonData = file.GetAsText();
					ModifiedConfigData data = JsonSerializer.Deserialize<ModifiedConfigData>(jsonData, jsonSerializerOptions);
					modifiedConfigs = data.modifiedConfigs;
				}
				catch (Exception e)
				{
					GD.PrintErr("加载修改配置时出错: ", e.Message);
					modifiedConfigs = new Dictionary<string, object>();
				}
			}
			else
			{
				modifiedConfigs = new Dictionary<string, object>();
				SaveModifiedConfigs(); // 创建空文件
			}
		}

		// 保存修改过的配置
		public static void SaveModifiedConfigs()
		{
			if (is_modified && modifiedConfigs.Count > 0)
			{
				try
				{
					string data = JsonSerializer.Serialize(new ModifiedConfigData(modifiedConfigs), jsonSerializerOptions);
					using var file = FileAccess.Open(config_file_path, FileAccess.ModeFlags.Write);
					file.StoreString(data);
					file.Close();
					is_modified = false;
				}
				catch (Exception e)
				{
					GD.PrintErr("保存修改配置时出错: ", e.Message);
				}
			}
		}

		// 设置修改过的配置值
		public static void SetModifiedConfigValue(string configId, object value)
		{
			modifiedConfigs[configId] = value;
			is_modified = true;
		}

		// 获取修改过的配置值
		public static object GetModifiedConfigValue(string configId)
		{
			if (modifiedConfigs.TryGetValue(configId, out object value))
			{
				return value;
			}
			return null;
		}

		// 检查配置是否被修改过
		public static bool IsConfigModified(string configId)
		{
			return modifiedConfigs.ContainsKey(configId);
		}

		// 获取所有修改过的配置
		public static Dictionary<string, object> GetAllModifiedConfigs()
		{
			return new Dictionary<string, object>(modifiedConfigs);
		}
	}
}
