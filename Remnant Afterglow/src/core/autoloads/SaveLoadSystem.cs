using GameLog;
using Godot;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
//
namespace Remnant_Afterglow
{
    /// <summary>
    /// 保存加载系统-单例模式
    /// </summary>
    public partial class SaveLoadSystem : Node
    {
        /// <summary>
        /// 游戏配置文件路径
        /// </summary>
        private static string cofig_path = PathConstant.GetPathUser(PathConstant.GAME_PARAM_PATH_USER);

        /// <summary>
        /// 存档文件夹基础路径  存档基础路径+存档名称 = 存档路径
        /// </summary>
        private static string directory_path = PathConstant.GetPathUser(PathConstant.SAVE_LOAD_PATH_USER);

        /// <summary>
        /// 存档界面数据加载字典
        /// </summary>
        public static Dictionary<string, SaveFile> SaveFileDict = new Dictionary<string, SaveFile>();

        /// <summary>
        /// 是否在存档内部
        /// </summary>
        public static bool IsSave = false;
        /// <summary>
        /// 保存存档后多少秒
        /// </summary>
        public static int NewSaveTime = 0;
        /// <summary>
        /// 当前使用的存档界面数据
        /// </summary>
        public static SaveFile NowSaveFile = new SaveFile();
        /// <summary>
        /// 当前使用的存档
        /// </summary>
        public static SaveData NowSaveData;

        public SaveLoadSystem()
        {
            LoadAllSaveFile();//加载所有存档界面数据
        }

        /// <summary>
        /// 设置当前存档
        /// </summary>
        public static void SetNowSave(SaveFile saveFile)
        {
            IsSave = true;
            NowSaveFile = saveFile;//设置当前选中存档
            NowSaveData = GetData<SaveData>(NowSaveFile.file_name);//读取存档数据
            if (NowSaveData == null)
            {
                Log.Error("存档读取错误！" + NowSaveFile.file_name);
            }
        }
        /// <summary>
        /// 清理当前存档
        /// </summary>
        public static void ClearNowSave()
        {
            IsSave = false;
            NowSaveFile = null;
            NowSaveData = null;
        }


        /// <summary>
        /// 加载所有存档界面数据
        /// </summary>
        public static void LoadAllSaveFile()
        {
            if (!Directory.Exists(directory_path))//没有对应存档文件夹
            {
                Directory.CreateDirectory(directory_path);//创建存档文件夹
            }
            // 读取存档文件夹中 的所有存档的文件夹下UI界面数据
            List<string> file_dir_list = FolderUtils.GetDirectoriesInFolder(directory_path);
            string ui_file_name = PathConstant.GetPathUser(PathConstant.SAVE_LOAD_VIEW_UI);
            foreach (string file_dir in file_dir_list)//文件夹路径，文件名称
            {
                // 使用自定义的文件读取方法
                SaveFile saveFile = FileUtils.ReadObjectSmart<SaveFile>(file_dir, ui_file_name);
                if (saveFile != null)
                {
                    // 将 SaveFile 添加到字典中
                    SaveFileDict[saveFile.file_name] = saveFile;
                }
            }
        }

        /// <summary>
        /// 重新加载存档文件
        /// </summary>
        public static void AfreshLoadAllSaveFile()
        {
            SaveFileDict.Clear();
            LoadAllSaveFile();
        }

        /// <summary>
        /// 创建一个存档
        /// </summary>
        public static SaveFile CreateSaveData(string save_name, int camp_id, int chapter_id, int diff_id)//祝福注释-创建存档
        {
            string save_path = directory_path + save_name;
            if (FolderUtils.DirectoryExists(save_path))
            {

                return null;//创建失败，已经存在该名称的存档
            }
            else
            {
                FolderUtils.CreateDirectory(save_path);//创建文件夹
                CampBase campbase = ConfigCache.GetCampBase(camp_id);
                SaveFile saveFile = new SaveFile(save_name, Common.GetS(), camp_id, chapter_id, diff_id);
                SaveData saveData = new SaveData();
                saveData.CreateInitData();
                SaveFile(save_name, PathConstant.GetPathUser(PathConstant.SAVE_LOAD_VIEW_UI), saveFile);//保存存档界面数据
                SaveData(save_name, saveData);//保存存档本身
                AfreshLoadAllSaveFile();
                return saveFile;//正常
            }

        }


        /// <summary>
        /// 删除所有存档
        /// </summary>
        public static void DeleteSavedData()
        {
            string[] files = Directory.GetFiles(directory_path);
            foreach (string file in files)
            {
                File.SetAttributes(file, FileAttributes.Normal);
                File.Delete(file);
            }
            Directory.Delete(directory_path, false);
        }
        /// <summary>
        /// 最新存档
        /// </summary>
        /// <returns></returns>
        public static SaveFile GetLatestSaveFile()
        {
            List<SaveFile> saveFiles = GetSaveFileList();
            if (saveFiles.Count >= 1)
                return saveFiles[0];
            else
                return null;
        }

        /// <summary>
        /// 获取存档列表数据
        /// </summary>
        public static List<SaveFile> GetSaveFileList()
        {
            List<SaveFile> saveFiles = new List<SaveFile>();
            foreach (var item in SaveFileDict)
            {
                saveFiles.Add(item.Value);
            }
            var sortedSaveFiles = saveFiles.OrderByDescending(sf => sf.Latest_Time).ToList();//降序排序，最新的在最前面
            return saveFiles;
        }

        /// <summary>
        /// 获取游戏配置数据config.json
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="filename"></param>
        /// <returns></returns>
        public static T GetParam<T>()
        {
            T data = FileUtils.ReadObjectSmartParam<T>(cofig_path);
            return data;
        }

        /// <summary>
        /// 保存到游戏配置数据
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="filename"></param>
        /// <param name="data"></param>
        public static void SaveParam<T>(T data)
        {
            FileUtils.WriteObjectSmartParam(cofig_path, data);
        }

        /// <summary>
        /// 获取对应存档数据
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="filename"></param>
        /// <returns></returns>
        public static T GetData<T>(string filename)
        {
            T data = FileUtils.ReadSaveData<T>(FileUtils.SaveDataDirectory, filename + "/" + filename + PathConstant.GetPathUser(PathConstant.SAVE_LOAD_FILE_SUFFIX));
            return data;
        }


        /// <summary>
        /// 保存数据到对应存档
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="filename"></param>
        /// <param name="data"></param>
        public static void SaveFile<T>(string path, string filename, T data)
        {
            FileUtils.WriteObjectSmart(FileUtils.SaveDataDirectory, path + "/" + filename, data);
        }

        /// <summary>
        /// 保存数据到对应存档
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="filename"></param>
        /// <param name="data"></param>
        public static void SaveData<T>(string filename, T data)
        {
            FileUtils.WriteObjectSmart(FileUtils.SaveDataDirectory, filename + "/" + filename + PathConstant.GetPathUser(PathConstant.SAVE_LOAD_FILE_SUFFIX), data);
        }
    }
}
