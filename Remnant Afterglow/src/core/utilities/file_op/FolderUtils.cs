using System.Collections.Generic;
using System.Diagnostics;
using System.IO;

namespace Remnant_Afterglow
{
    //文件夹操作
    public static class FolderUtils
    {
        /// <summary>
        /// 使用文件资源管理器打开指定的目录。
        /// </summary>
        /// <param name="path">要打开的目录路径。</param>
        public static void OpenDirectory(string path)
        {
            Process.Start("explorer.exe", Path.GetFullPath(path));
        }

        /// <summary>
        /// 使用文件资源管理器打开指定的目录，并选择指定的文件。
        /// </summary>
        /// <param name="path">要选择的文件路径。</param>
        public static void OpenSelectDirectory(string path)
        {
            Process.Start("explorer.exe", "/select, \"" + path + "\"");
        }

        /// <summary>
        /// 删除指定的目录。
        /// </summary>
        /// <param name="path">要删除的目录路径。</param>
        /// <param name="recursive">是否递归删除子目录，默认为 false。</param>
        public static void DeleteDirectory(string path, bool recursive = false)
        {
            if (DirectoryExists(path))
                Directory.Delete(path, recursive);
        }

        /// <summary>
        /// 获取指定目录下的所有文件。
        /// </summary>
        /// <param name="path">要搜索的目录路径。</param>
        /// <param name="includeSubDirectories">是否包括子目录，默认为 false。</param>
        /// <param name="pattern">搜索模式，默认为 "*.*"，表示所有文件。</param>
        /// <returns>一个包含所有匹配文件路径的列表。</returns>
        public static List<string> GetFilesInFolder(string path, bool includeSubDirectories = false,
            string pattern = "*.*")
        {
            List<string> files = new List<string>();
            if (DirectoryExists(path))
            {
                SearchOption options =
                    (includeSubDirectories ? SearchOption.AllDirectories : SearchOption.TopDirectoryOnly);
                files.AddRange(Directory.GetFiles(path, pattern, options));
            }

            return files;
        }

        /// <summary>
        /// 获取指定目录下的所有子目录。
        /// </summary>
        /// <param name="path">要搜索的目录路径。</param>
        /// <param name="includeSubDirectories">是否包括子目录，默认为 false。</param>
        /// <returns>一个包含所有匹配子目录路径的列表。</returns>
        public static List<string> GetDirectoriesInFolder(string path, bool includeSubDirectories = false)
        {
            List<string> directories = new List<string>();
            if (Directory.Exists(path))
            {
                SearchOption options = (includeSubDirectories ? SearchOption.AllDirectories : SearchOption.TopDirectoryOnly);
                directories.AddRange(Directory.GetDirectories(path, "*", options));
            }

            return directories;
        }
        /// <summary>
        /// 判断给定的路径是否是一个目录。
        /// </summary>
        /// <param name="path">要判断的路径。</param>
        /// <returns>如果是目录返回 true，否则返回 false。</returns>
        public static bool IsFolder(string path)
        {
            FileAttributes attr = File.GetAttributes(path);
            return (attr & FileAttributes.Directory) == FileAttributes.Directory;
        }

        /// <summary>
        /// 删除指定目录下的所有文件。
        /// </summary>
        /// <param name="path">要清理的目录路径。</param>
        public static void DeleteDirectoryContent(string path)
        {
            if (DirectoryExists(path))
            {
                DirectoryInfo dir = new DirectoryInfo(path);

                foreach (FileInfo fi in dir.GetFiles())
                {
                    fi.IsReadOnly = false;
                    fi.Delete();
                }
            }
        }

        /// <summary>
        /// 检查指定的目录是否存在。
        /// </summary>
        /// <param name="path">要检查的目录路径。</param>
        /// <returns>如果目录存在返回 true，否则返回 false。</returns>
        public static bool DirectoryExists(string path)
        {
            return Directory.Exists(path);
        }

        /// <summary>
        /// 创建指定的目录。
        /// </summary>
        /// <param name="path">要创建的目录路径。</param>
        public static void CreateDirectory(string path)
        {
            Directory.CreateDirectory(path);
        }

        /// <summary>
        /// 获取指定路径的父目录名称。
        /// </summary>
        /// <param name="path">路径。</param>
        /// <returns>父目录名称。</returns>
        public static string GetDirectoryName(string path)
        {
            return Path.GetDirectoryName(path);
        }
    }
}