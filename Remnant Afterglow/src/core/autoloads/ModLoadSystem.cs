using GameLog;
using Godot;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.IO;

namespace Remnant_Afterglow
{
	//模组加载列表信息-用于读取模组数据时或者显示用
	public class ModList
	{
		//文件名称-模组名称
		public Dictionary<string, string> LoadModList { get; set; }
	}

	//模组加载错误类，用于记录模组加载时的错误数据
	public class ModError
	{
		//模组路径
		public string ModPath;
		//模组名称
		public string ModName;
		//错误id列表
		public List<int> ErrorList = new List<int>();
		public ModError(string ModPath, string ModName)
		{
			this.ModPath = ModPath;
			this.ModName = ModName;
		}

	}

	/// <summary>
	/// 模组加载管理器
	/// </summary>
	public partial class ModLoadSystem : Node
	{
		/// <summary>
		/// 是否已启用mod，mod_list.txt中无数据则未启用mod,如果没有mod_list文件，也是不启用
		/// </summary>
		public static bool is_use_mod = true;

		/// <summary>
		/// 所有mod列表,<文件夹名称，模组名称>
		/// </summary>
		public static Dictionary<string, string> AllModList = new Dictionary<string, string>();
		/// <summary>
		/// 当前加载的mod列表,<文件夹名称，模组名称>
		/// </summary>
		public static ModList modList;
		/// 加载错误字典，<模组错误数据>
		public static List<ModError> modErrorDict = new List<ModError>();

		/// <summary>
		/// 需要加载的模组的模组信息mod.info-mod_list.json这个文件
		/// </summary>
		public static Dictionary<string, ModAllInfo> loadModDict = new Dictionary<string, ModAllInfo>();

		/// <summary>
		/// 所有模组的模组信息mod.info
		/// </summary>
		public static Dictionary<string, ModAllInfo> all_mod_list = new Dictionary<string, ModAllInfo>();





		public ModLoadSystem()
		{
			string modsPath = PathConstant.GetPathUser(PathConstant.MOD_LOAD_PATH_USER);
			Directory.CreateDirectory(modsPath);//确保mod文件始终存在
			if (is_use_mod)//启用模组
			{
				ReadAllModList();//读取mod文件夹下所有文件夹中的数据
				ReadNowModList();//读取游戏当前mod_list.txt中包含的所有需要加载的mod
				ReadModDll();
			}
		}

		/// <summary>
		/// 读取mods文件夹下所有mod文件夹
		/// </summary>
		public void ReadAllModList()
		{
			List<string> filepathList = FolderUtils.GetDirectoriesInFolder(PathConstant.GetPathUser(PathConstant.MOD_LOAD_PATH_USER));//所有mod路径
			foreach (string filepath in filepathList)
			{
				string path = filepath + "/" + "mod.info";
				ModInfo modinfo = ReadModInfo(path);
				ModAllInfo modAllInfo = new ModAllInfo(modinfo, FileUtils.ExtractModName(filepath));
				if (modinfo != null)
					all_mod_list[filepath] = modAllInfo;//祝福注释-确定路径
			}
		}

		/// <summary>
		/// 读取游戏当前mod_list.txt的数据
		/// </summary>
		public void ReadNowModList()
		{
			if (File.Exists(PathConstant.GetPathUser(PathConstant.MOD_LIST_PATH_USER)))//检查是否存在mod_list
			{
				string jsonText = File.ReadAllText(PathConstant.GetPathUser(PathConstant.MOD_LIST_PATH_USER));
				modList = JsonConvert.DeserializeObject<ModList>(jsonText);//读取mod加载列表
				foreach (var k in modList.LoadModList)
				{
					string infopath = PathConstant.GetPathUser(PathConstant.MOD_LOAD_PATH_USER) + k.Key + "/" + "mod.info";
					ModInfo modinfo = ReadModInfo(infopath);
					ModAllInfo modAllInfo = new ModAllInfo(modinfo, k.Key);
					if (modinfo != null)
						loadModDict[k.Key] = modAllInfo;
				}
			}
			else//不存在modlist文件，就创建一个,并写入基础数据
			{
				//Log.Print(PathConstant.MOD_LIST_PATH_USER);
				File.AppendAllText(PathConstant.GetPathUser(PathConstant.MOD_LIST_PATH_USER), "{\r\n\t\"mod_list\":{}\r\n}");
			}
		}

		/// <summary>
		/// 读取需要加载的dll文件和pck文件
		/// </summary>
		public void ReadModDll()
		{

			foreach (var info in loadModDict)
			{
				ModAllInfo modInfo = info.Value;
				if (modInfo.modInfo.HasPck)//有无pck文件
				{
					foreach (string pck_str in modInfo.modInfo.PckList)//祝福注释-加载mod数据 pck
					{
						string infopath = PathConstant.GetPathUser(PathConstant.MOD_LOAD_PATH_USER) + info.Key + PathConstant.GetPathUser(PathConstant.MOD_LIST_Dll_USER) + pck_str;

					}
				}
				if (modInfo.modInfo.HasCsharp)//有无c#
				{
					foreach (string dll_str in modInfo.modInfo.DllList)//祝福注释-加载mod数据  c#
					{
						string infopath = PathConstant.GetPathUser(PathConstant.MOD_LOAD_PATH_USER) + info.Key + PathConstant.GetPathUser(PathConstant.MOD_LIST_Dll_USER) + dll_str;

					}
				}
			}
		}

		/// <summary>
		/// 读取单个modinfo文件
		/// </summary>
		/// <param name="infopath"></param>
		/// <returns></returns>
		public ModInfo ReadModInfo(string infopath)
		{
			if (File.Exists(infopath))//存在对于mod.info
			{
				string jsonText = File.ReadAllText(infopath);
				ModInfo modinfo = JsonConvert.DeserializeObject<ModInfo>(jsonText);
				return modinfo;
			}
			else
			{
				Log.Error("文件夹{" + infopath + "} 加载失败！ 没有文件mod.info");
				return null;
			}
		}

	}

}
