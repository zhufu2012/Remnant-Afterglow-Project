//模组信息
using System;

namespace Remnant_Afterglow
{
    public class ModInfo
    {
        /// <summary>
        /// 
        /// </summary>
        public string Name { get; set; }
        /// <summary>
        /// 模组的内部名称，需要唯一，不能有空格，必须匹配文件夹名称
        /// </summary>
        public string DisplayName { get; set; }
        /// <summary>
        /// 作者
        /// </summary>
        public string Author { get; set; }
        /// <summary>
        /// 模组的图标
        /// </summary>
        public string? Icon { get; set; }
        /// <summary>
        /// 模组介绍
        /// </summary>
        public string Description { get; set; }
        /// <summary>
        /// 可选的URL来指定可以找到关于这个mod的信息的网站，例如Github链接到 mod的项目
        /// </summary>
        public Uri? InfoUrl { get; set; }
        /// <summary>
        /// 模组版本
        /// </summary>
        public string Version { get; set; }

        /// <summary>
        /// 最小游戏版本-如果当前游戏版本小于该版本，mod将拒绝加载
        /// </summary>
        public string MinGameVersion { get; set; }
        /// <summary>
        /// 最大游戏版本-如果当前游戏版本大于该版本，mod将拒绝加载
        /// </summary>
        public string MaxGameVersion { get; set; }

        /// <summary>
        /// 是否有excel表格配置拓展
        /// </summary>
        public bool HasExcel { get; set; }
        /// <summary>
        /// 是否有Pck加载文件-有才会加载之后的PckList
        /// </summary>
        public bool HasPck { get; set; }
        /// <summary>
        /// 指定启用mod时要加载的. pck文件的相对路径列表(从mod根文件夹)
        /// </summary>
        public string[] PckList = new string[0];
        /// <summary>
        /// 是否有c#代码补丁或拓展，有才会加载之后的DllList
        /// </summary>
        public bool HasCsharp { get; set; }
        /// <summary>
        /// 指定启用mod时要加载的. Dll文件的相对路径(从mod根文件夹)
        /// </summary>
        public string[] DllList = new string[0];
        /// <summary>
        /// 依赖列表，需要对应依赖都启动
        /// </summary>
        public string[] DependenciesList { get; init; } = Array.Empty<string>();
        /// <summary>
        /// 图片名称列表
        /// </summary>
        public string[] ImgList = new string[0];
        /// <summary>
        ///   是否要求重启 ，如果是真，表示mod要求游戏重启才能完成加载
        /// </summary>
        public bool RequiresRestart { get; set; }
        public override string ToString()
        {
            return "ModInfo{" +
                $", Name='{Name}'" +
                $", DisplayName='{DisplayName}'" +
                $", Author='{Author}'" +
                $", Description='{Description}'" +
                $", version='{Version}'" +
                $", MinGameVersion='{MinGameVersion}'" +
                $", HasExcel={HasExcel}" +
                $", HasCsharp={HasCsharp}" +
                $", RequiresRestart={RequiresRestart}" +
                '}';
        }
    }
}