using GameLog;
using Godot;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.IO;

namespace Remnant_Afterglow
{
    //模组列表信息-用于读取模组数据时或者显示用
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

    //模组加载管理器
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
        public static Dictionary<string, string> LoadModList = new Dictionary<string, string>();
        /// 加载错误字典，<模组错误数据>
        public static List<ModError> modErrorDict = new List<ModError>();

        /// <summary>
        /// 每个模组的模组信息mod.info
        /// </summary>
        public static List<ModInfo> load_mod_list = new List<ModInfo>();

        /// <summary>
        /// 每个模组的模组信息mod.info
        /// </summary>
        public static List<ModInfo> all_mod_list = new List<ModInfo>();

        public ModLoadSystem()
        {
            if (is_use_mod)//启用模组
            {
                ReadNowModList();//读取游戏当前mod_list.txt中包含的所有需要加载的mod
                ReadAllModList();//读取mod文件夹下所有文件夹的数据
            }
        }

        /// <summary>
        /// 读取mods文件夹下所有mod文件夹
        /// </summary>
        public void ReadAllModList()
        {
            List<string> filepathList = FolderUtils.GetDirectoriesInFolder(PathConstant.GetPathUser(PathConstant.MOD_LOAD_PATH_USER));
            foreach (string filepath in filepathList)
            {
                string path = filepath + "/" + "mod.info";
                ModInfo modinfo = ReadModInfo(path);
                if (modinfo != null)
                    all_mod_list.Add(modinfo);
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
                ModList file_data = JsonConvert.DeserializeObject<ModList>(jsonText);
                if (file_data.LoadModList.Count > 0)
                {
                    LoadModList = file_data.LoadModList;
                }
                foreach (var k in LoadModList)
                {
                    string infopath = PathConstant.GetPathUser(PathConstant.MOD_LOAD_PATH_USER) + k.Key + "/" + "mod.info";
                    ModInfo modinfo = ReadModInfo(infopath);
                    if (modinfo != null)
                        load_mod_list.Add(modinfo);
                }
            }
            else//不存在modlist文件，就创建一个,并写入基础数据
            {
                //Log.Print(PathConstant.MOD_LIST_PATH_USER);
                File.AppendAllText(PathConstant.GetPathUser(PathConstant.MOD_LIST_PATH_USER), "{\r\n\t\"mod_list\":{}\r\n}");
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
                string jsonText = File.ReadAllText(PathConstant.GetPathUser(PathConstant.MOD_LIST_PATH_USER));
                ModInfo modinfo = JsonConvert.DeserializeObject<ModInfo>(jsonText);
                return modinfo;
            }
            else
            {
                Log.Print("文件夹{" + infopath + "} 加载失败！ 没有文件mod.info");
                Log.Print("请在" + infopath + "文件夹下，创建文件mod.info,内容如下" +
"{\r\n\t\"Name\": \"模组名称\",\r\n\t\"DisplayName\": \"显示名称\",\r\n\t\"Author\":\"这里是作者名称\",\r\n\t\"Description\": \"模组描述，这里应当能设置字体大小，颜色等\",\r\n\t\"Version\": \"模组版本\",\r\n\t\"HasExcel\": true,\r\n\t\"HasCsharp\": true\r\n}");
                return null;
            }
        }

    }

}