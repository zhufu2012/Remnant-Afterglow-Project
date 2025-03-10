using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;
using GameLog;
using Godot;

namespace Remnant_Afterglow
{
    public static class FileUtils
    {
        /// <summary>
        /// 用户数据路径
        /// </summary>
        private static string _userDataPath = PathConstant.GetPathUser(PathConstant.SAVE_LOAD_PATH_USER);

        /// <summary>
        /// 保存数据的目录
        /// </summary>
        public static string SaveDataDirectory => _userDataPath;

        /// <summary>
        /// 确认给定的路径是否是一个目录。
        /// </summary>
        /// <param name="absolutePath">绝对路径</param>
        /// <returns>如果路径是一个目录则返回 true，否则返回 false。</returns>
        public static bool PathIsDirectory(string absolutePath)
        {
            FileAttributes attr = File.GetAttributes(absolutePath);
            if ((attr & FileAttributes.Directory) == FileAttributes.Directory)
                return true;
            else
                return false;
        }

        /// <summary>
        /// 复制文件到指定位置。
        /// </summary>
        /// <param name="source">源文件路径</param>
        /// <param name="dest">目标文件路径</param>
        /// <param name="overwrite">是否覆盖已有文件</param>
        /// <param name="forceCreateDir">是否强制创建目标文件夹</param>
        public static void CopyFile(string source, string dest, bool overwrite, bool forceCreateDir = false)
        {
            if (forceCreateDir)
            {
                var directoryInfo = new FileInfo(dest).Directory;
                if (directoryInfo != null)
                    FolderUtils.CreateDirectory(directoryInfo.FullName);
            }
            if (FileExists(source))
                File.Copy(source, dest, overwrite);
            else
                GD.PrintErr($"无法移动文件，文件{source}不存在!");
        }

        /// <summary>
        /// 打开文件。
        /// </summary>
        /// <param name="file">文件路径</param>
        public static void OpenFile(string file)
        {
            if (FileExists(file))
                Process.Start(file);
            else
                GD.PrintErr($"无法打开文件，文件{file}不存在！");
        }

        /// <summary>
        /// 设置文件的只读属性。
        /// </summary>
        /// <param name="file">文件路径</param>
        /// <param name="readOnly">是否设置为只读</param>
        public static void SetReadOnlyProperty(string file, bool readOnly)
        {
            if (FileExists(file))
            {
                FileInfo fileInfo = new FileInfo(file);
                fileInfo.IsReadOnly = readOnly;
            }
            else
                GD.PrintErr($"无法打开文件，文件{file}不存在！");
        }

        /// <summary>
        /// 将字节数组写入文件。
        /// </summary>
        /// <param name="path">文件路径</param>
        /// <param name="bytes">字节数组</param>
        public static void WriteAllText(string path, string str)
        {
            if (!FileExists(path))
                CreateFile(path);
            GD.Print($"写入文件:{path}");
            File.WriteAllText(path, str);
            GD.Print($"文件已写入:{path}");
        }

        /// <summary>
        /// 将对象序列化并写入文件。
        /// </summary>
        /// <param name="directoryPath">目录路径</param>
        /// <param name="data">要写入的对象</param>
        public static void WriteObjectSmart(string directoryPath, string simpleName, object data)
        {
            string str = SaveExtension.SerializeObject(data);
            string path;
            if (directoryPath.EndsWith("/"))
                path = directoryPath + simpleName;
            else
                path = directoryPath + "/" + simpleName;
            WriteAllText(path, str);
        }

        /// <summary>
        /// 将对象序列化并写入文件。
        /// </summary>
        /// <param name="directoryPath">目录路径</param>
        /// <param name="data">要写入的对象</param>
        public static void WriteObjectSmartParam(string directoryPath, object data)
        {
            string str = SaveExtension.SerializeObject(data);
            WriteAllText(directoryPath, str);
        }

        /// <summary>
        /// 将对象序列化并写入文件,紧密。
        /// </summary>
        /// <param name="directoryPath">目录路径</param>
        /// <param name="data">要写入的对象</param>
        public static void WriteObjectSmartParam2(string directoryPath, object data)
        {
            string str = SaveExtension.SerializeObject2(data);
            WriteAllText(directoryPath, str);
        }

        /// <summary>
        /// 从文件中反序列化并读取对象。
        /// </summary>
        /// <typeparam name="T">对象类型</typeparam>
        /// <param name="directoryPath">目录路径</param>
        /// <returns>反序列化的对象</returns>
        public static T ReadObjectSmartParam<T>(string directoryPath)
        {
            return (T)ReadObjectSmart<T>(typeof(T), directoryPath);
        }

        /// <summary>
        /// 从文件中反序列化并读取对象。
        /// </summary>
        /// <typeparam name="T">对象类型</typeparam>
        /// <param name="directoryPath">目录路径</param>
        /// <returns>反序列化的对象</returns>
        public static T ReadObjectSmart<T>(string directoryPath, string filename)
        {
            return (T)ReadObjectSmart<T>(typeof(T), directoryPath + "//" + filename);
        }

        /// <summary>
        /// 从文件中反序列化并读取对象。
        /// </summary>
        /// <typeparam name="T">对象类型</typeparam>
        /// <param name="type">对象类型</param>
        /// <param name="directoryPath">目录路径</param>
        /// <returns>反序列化的对象</returns>
        public static object ReadObjectSmart<T>(Type type, string directoryPath)
        {
            if (FileExists(directoryPath))
            {
                string jsonText = File.ReadAllText(directoryPath);
                string jsonText2 = SaveData.VersionConverter(jsonText);
                return SaveExtension.DeserializeObject<T>(jsonText2);
            }
            return null;
        }


        /// <summary>
        /// 从存档文件中反序列化并读取存档，其中还需要检查存档版本等
        /// </summary>
        /// <typeparam name="T">对象类型</typeparam>
        /// <param name="directoryPath">目录路径</param>
        /// <returns>反序列化的对象</returns>
        public static T ReadSaveData<T>(string directoryPath, string filename)
        {
            return (T)ReadSaveData<T>(typeof(T), directoryPath + filename);
        }

        /// <summary>
        /// 从存档文件中反序列化并读取存档，其中还需要检查存档版本等
        /// </summary>
        /// <typeparam name="T">对象类型</typeparam>
        /// <param name="type">对象类型</param>
        /// <param name="directoryPath">目录路径</param>
        /// <returns>反序列化的对象</returns>
        public static object ReadSaveData<T>(Type type, string directoryPath)
        {
            if (FileExists(directoryPath))
            {
                string jsonText = File.ReadAllText(directoryPath);
                string jsonText2 = SaveData.VersionConverter(jsonText);
                return SaveExtension.DeserializeObject<T>(jsonText2);
            }
            return null;
        }

        /// <summary>
        /// 读取文件中的所有字节。
        /// </summary>
        /// <param name="path">文件路径</param>
        /// <returns>文件中的字节数组</returns>
        public static string ReadAllTexts(string path)
        {
            if (FileExists(path))
                return File.ReadAllText(path);
            return "";
        }

        /// <summary>
        /// 将对象序列化并写入文件。
        /// </summary>
        /// <param name="path">文件路径</param>
        /// <param name="data">要写入的对象</param>
        public static void WriteObject(string path, object data)
        {
            string str = SaveExtension.SerializeObject(data);
            WriteAllText(path, str);
        }

        /// <summary>
        /// 创建文件（如果文件夹不存在则创建）。
        /// </summary>
        /// <param name="path">文件路径</param>
        public static void CreateFile(string path)
        {
            if (!Directory.Exists(Path.GetDirectoryName(path)))
                Directory.CreateDirectory(Path.GetDirectoryName(path));
            File.Create(path).Close();
        }

        /// <summary>
        /// 删除文件。
        /// </summary>
        /// <param name="path">文件路径</param>
        public static void DeleteFile(string path)
        {
            if (FileExists(path))
                File.Delete(path);
        }

        /// <summary>
        /// 检查文件是否存在。
        /// </summary>
        /// <param name="path">文件路径</param>
        /// <returns>如果文件存在则返回 true，否则返回 false。</returns>
        public static bool FileExists(string path)
        {
            return File.Exists(path);
        }

        /// <summary>
        /// 写入文本到文件。
        /// </summary>
        /// <param name="path">文件路径</param>
        /// <param name="text">要写入的文本</param>
        /// <param name="encoding">编码方式，默认为 UTF-8</param>
        public static void WriteToFile(string path, string text, Encoding encoding = null)
        {
            if (encoding == null)
                encoding = Encoding.UTF8;
            if (!FileExists(path))
                CreateFile(path);
            File.WriteAllText(path, text, encoding);
        }

        /// <summary>
        /// 追加文本到文件。
        /// </summary>
        /// <param name="path">文件路径</param>
        /// <param name="text">要追加的文本</param>
        /// <param name="encoding">编码方式，默认为 UTF-8</param>
        public static void AppendToFile(string path, string text, Encoding encoding = null)
        {
            if (encoding == null)
                encoding = Encoding.UTF8;
            if (FileExists(path))
                File.AppendAllText(path, text, encoding);
            else
                GD.PrintErr($"无法写入文件，文件{path}不存在");
        }

        /// <summary>
        /// 从文件中读取文本。
        /// </summary>
        /// <param name="path">文件路径</param>
        /// <param name="isCritical">是否为关键文件</param>
        /// <param name="showLog">是否显示日志</param>
        /// <returns>文件中的文本</returns>
        public static string ReadTextFromFile(string path, bool isCritical = true, bool showLog = false)
        {
            if (FileExists(path))
                return File.ReadAllText(path);
            else
            {
                if (showLog)
                {
                    if (isCritical)
                        GD.PrintErr($"无法读取文件，文件{path}不存在");
                    else
                        GD.Print($"无法读取文件，文件{path}不存在");
                }
                return "";
            }
        }

        /// <summary>
        /// 从文件中读取所有行。
        /// </summary>
        /// <param name="path">文件路径</param>
        /// <returns>文件中的所有行</returns>
        public static string[] ReadLinesFromText(string path)
        {
            if (FileExists(path))
                return File.ReadAllLines(path);
            else
            {
                GD.PrintErr($"无法读取文件，文件{path}不存在");
                return null;
            }
        }

        /// <summary>
        /// 获取文件大小。
        /// </summary>
        /// <param name="path">文件路径</param>
        /// <returns>格式化后的文件大小字符串</returns>
        public static string FileSize(string path)
        {
            string[] sizes = { "B", "KB", "MB", "GB", "TB" };
            double len = new FileInfo(path).Length;
            int order = 0;
            while (len >= 1024 && order < sizes.Length - 1)
            {
                order++;
                len = len / 1024;
            }
            return string.Format("{0:0.##} {1}", len, sizes[order]);
        }

        /// <summary>
        /// 获取文件名。
        /// </summary>
        /// <param name="path">文件路径</param>
        /// <returns>文件名</returns>
        public static string GetFileName(string path)
        {
            return Path.GetFileName(path);
        }

        /// <summary>
        /// 将字节数转换为千字节数。
        /// </summary>
        /// <param name="size">字节数</param>
        /// <returns>格式化后的大小字符串</returns>
        public static string ConvertByteToKiloByte(double size)
        {
            string[] suffix = { "B", "KB", "MB", "GB" };
            int index = 0;
            do
            {
                size /= 1024;
                index++;
            } while (size >= 1024);

            return string.Format("{0:0.00} {1}", size, suffix[index]);
        }

        /// <summary>
        /// 获取文件夹中的所有文件内容。
        /// </summary>
        /// <param name="folder">文件夹路径</param>
        /// <returns>包含文件名和字节数组的字典</returns>
        public static Dictionary<string, byte[]> GetFolderContents(string folder)
        {
            Dictionary<string, byte[]> result = new Dictionary<string, byte[]>();
            DirectoryInfo info = new DirectoryInfo(folder);
            if (!info.Exists)
                Directory.CreateDirectory(folder);
            FileInfo[] fileInfos = info.GetFiles();
            foreach (FileInfo fileInfo in fileInfos)
            {
                if (fileInfo.Exists)
                {
                    byte[] bytes = File.ReadAllBytes(folder + "/" + fileInfo.Name);
                    result.Add(fileInfo.Name, bytes);
                }
            }

            return result;
        }

        /// <summary>
        /// 检查文件是否存在（区分大小写）。
        /// </summary>
        /// <param name="filepath">文件路径</param>
        /// <returns>如果文件存在则返回 true，否则返回 false。</returns>
        public static bool FileExistCaseSensitive(string filepath)
        {
            string physicalPath = GetWindowsPhysicalPath(filepath);
            if (physicalPath == null) return false;
            if (filepath != physicalPath) return false;
            else return true;
        }

        [DllImport("kernel32.dll", SetLastError = true, CharSet = CharSet.Auto)]
        static extern uint GetLongPathName(string ShortPath, StringBuilder sb, int buffer);

        [DllImport("kernel32.dll")]
        static extern uint GetShortPathName(string longpath, StringBuilder sb, int buffer);

        /// <summary>
        /// 获取 Windows 物理路径（处理路径的大小写和符号问题）。
        /// </summary>
        /// <param name="path">原始路径</param>
        /// <returns>物理路径或 null 如果失败</returns>
        private static string GetWindowsPhysicalPath(string path)
        {
            StringBuilder builder = new StringBuilder(255);
            GetShortPathName(path, builder, builder.Capacity);
            path = builder.ToString();
            uint result = GetLongPathName(path, builder, builder.Capacity);
            if (result > 0 && result < builder.Capacity)
                return builder.ToString(0, (int)result);
            if (result > 0)
            {
                builder = new StringBuilder((int)result);
                result = GetLongPathName(path, builder, builder.Capacity);
                return builder.ToString(0, (int)result);
            }
            return null;
        }

        /// <summary>
        /// 递归地搜索文件夹中的所有文件。
        /// </summary>
        /// <param name="sDir">起始目录</param>
        /// <param name="searchPattern">搜索模式，默认为 "*.*"，即查找所有文件</param>
        /// <returns>找到的文件路径列表</returns>
        public static List<string> RecursiveDirSearch(string sDir, string searchPattern = "*.*")
        {
            List<string> filesList = new List<string>();
            try
            {
                foreach (string d in Directory.GetDirectories(sDir))
                {
                    foreach (string f in Directory.GetFiles(d, searchPattern))
                    {
                        filesList.Add(f);
                    }
                    filesList.AddRange(RecursiveDirSearch(d, searchPattern));
                }
            }
            catch (Exception)
            {
                // 忽略异常
            }
            return filesList;
        }

        /// <summary>
        /// 提取给定路径中的文件夹名称。
        /// </summary>
        /// <param name="path">完整的文件路径。</param>
        /// <returns>文件夹名称。</returns>
        public static string ExtractFolderNameFromPath(string path)
        {
            // 获取路径的最后一级目录
            string directoryName = System.IO.Path.GetDirectoryName(path);
            if (directoryName == null)
            {
                throw new ArgumentException("路径无效或无法确定目录名称。", nameof(path));
            }

            // 获取文件夹名称
            string folderName = System.IO.Path.GetFileName(directoryName);
            return folderName;
        }

        /// <summary>
        /// 获取路径中/之后的字符串
        /// </summary>
        /// <param name="path"></param>
        /// <returns></returns>
        public static string ExtractModName(string path)
        {
            // 从路径中提取最后一个部分
            int lastSlashIndex = path.LastIndexOf('/');
            if (lastSlashIndex != -1)
            {
                return path.Substring(lastSlashIndex + 1);
            }
            else
            {
                // 如果路径中没有斜杠，直接返回整个字符串
                return path;
            }
        }

    }
}