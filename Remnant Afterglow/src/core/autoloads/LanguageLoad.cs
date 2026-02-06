using Godot;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
namespace Remnant_Afterglow
{
	/// <summary>
	/// 格式化字符串所需数据
	/// </summary>
	public class ForMatStr
	{
		/// <summary>
		/// KEY_INDEX
		/// </summary>
		public string key_index;
		/// <summary>
		/// 键名
		/// </summary>
		public string key;
		/// <summary>
		/// 配置表名
		/// </summary>
		public string cfg_name;
		/// <summary>
		/// 格式字符串
		/// </summary>
		public string format_str;
	}

	public class LanguageDict
	{
		public string file_name { get; set; }
		public string file_path { get; set; }
	}
	public class LanguageFiles
	{
		public List<LanguageDict> language_files { get; set; }
		public override string ToString()
		{
			string result = "Language Files:\n";
			foreach (var file in language_files)
			{
				result += "File Name: " + file.file_name + ", File Path: " + file.file_path + "\n";
			}
			return result;
		}
	}

	/// <summary>
	/// 语言加载器
	/// </summary>
	public partial class LanguageLoad : Node
	{
		/// <summary>
		/// 语言 -默认中文 不同版本 按照设置读取
		/// </summary>
		public string define_language = "zh_cn";
		/// <summary>
		/// 语言 -默认中文 不同版本 按照设置读取
		/// </summary>
		public int define_language_index = 2;

		/// <summary>
		/// 无文字 默认显示 ""表示显示 string_id 非""显示define_str
		/// </summary>
		public string define_str = "";

		/// <summary>
		/// 语言与序号关系
		/// </summary>
		private Dictionary<string, int> language_list = new Dictionary<string, int>()
			{
				{ "zh_cn", 2 },
				{ "en_us", 3 },
				{ "in_id", 4 },
				{ "th_th", 5 },
				{ "eu_ru", 6 },
				{ "eu_fr", 7 },
				{ "eu_ge", 8 },
				{ "eu_tr", 9 },
				{ "eu_sp", 10 },
				{ "eu_pt", 11 },
				{ "ko_kr", 12 },
				{ "zh_tw", 13 },
				{ "ja_jp", 14 },
				{ "time", 15 },
				{ "type", 16 }
			};

		/// <summary>
		/// 语言数据
		/// </summary>
		public List<LanguageDict> filedata;

		/// <summary>
		/// 语言数据
		/// </summary>
		public Dictionary<string, Dictionary<string, string>> language_data = new Dictionary<string, Dictionary<string, string>>();
		public static Dictionary<string, string> language_data2 = new Dictionary<string, string>();
		/// <summary>
		/// 初始化
		/// </summary>
		public override void _Ready()
		{
			//读取
			//先读取file_name.json文件 确定有哪些语言文件 以及相应的路径
			//还有读取各mod文件夹中的 mod语言文件，以及相应的路径
			//读取对应语言的文字，保存到内存
			//修改语言就重新加载这里
			string jsonText = File.ReadAllText("./data/language/file_name.json");
			LanguageFiles file_data = JsonConvert.DeserializeObject<LanguageFiles>(jsonText);
			filedata = file_data.language_files;
			define_language = "zh_tw";//根据设置，读取对应语言数据
			define_language_index = 2;//根据设置，读取对应语言数据
			for (int i = 0; i < filedata.Count; i++)
			{
				string jsonstr = File.ReadAllText(filedata[i].file_path);
				JObject jsonObject = JObject.Parse(jsonstr);
				Dictionary<string, string> file_language_data = new Dictionary<string, string>();
				foreach (var item in jsonObject)
				{
					string language_str = null;
					JObject data = (JObject)item.Value["languages"];
					foreach (var language in data)
					{
						string languageKey = language.Key;
						if (languageKey == define_language)
							language_str = language.Value.ToString();
					}
					if (language_str == null || language_str == "NaN")
					{
						if (define_str.Length == 0)
							language_str = item.Key;
						else
							language_str = define_str;
					}
					file_language_data[item.Key] = language_str;
				}
				language_data[filedata[i].file_name] = file_language_data;
				language_data2 = language_data2.Union(file_language_data).ToDictionary(x => x.Key, x => x.Value);
			}

			//Log.Print(GetText("KeyBase"));
		}

		/// <summary>
		/// 根据文字id 获取默认语言的文字
		/// </summary>
		/// <param name="string_id"></param>
		/// <returns></returns>
		public static string GetText(string string_id)
		{
			if (language_data2.ContainsKey(string_id))
			{
				return language_data2[string_id];
			}////注释//-这里可以处理下，没查到文字就返回默认文字，null文字
			return null;
		}

		/// <summary>
		/// 检查字符串中是否有格式字符串,有返回true
		/// </summary>
		/// <param name="str"></param>
		/// <returns></returns>
		public bool CheckStr(string str)
		{
			string pattern = @"\{\{\{(.+?)\}\}\}";
			MatchCollection matches = Regex.Matches(str, pattern);
			return matches.Count > 0;
		}

		/// <summary>
		/// 格式化字符串中是否有格式字符串,有返回true
		/// </summary>
		/// <param name="str"></param>
		public void ForMatStr(string str)
		{

		}
	}
}
