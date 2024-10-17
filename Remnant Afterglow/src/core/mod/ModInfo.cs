    //模组信息
    public class ModInfo
    {
        //模组名称
        public string Name { get; set; }
        //模组的内部名称，需要唯一，不能有空格，必须匹配文件夹名称
        public string DisplayName { get; set; }
        //作者
        public string Author { get; set; }
        //模组的图标
        public string? Icon { get; set; }
        //模组介绍
        public string Description { get; set; }
        //可选的URL来指定可以找到关于这个mod的信息的网站，例如Github链接到 mod的项目
        public Uri? InfoUrl { get; set; }
        //模组版本
        public string Version { get; set; }

        //最小游戏版本-如果当前游戏版本小于该版本，mod将拒绝加载
        public string MinGameVersion { get; set; }
        //最大游戏版本-如果当前游戏版本大于该版本，mod将拒绝加载
        public string MaxGameVersion { get; set; }

        //是否有excel表格配置拓展
        public bool HasExcel { get; set; }
        //是否有Pck加载文件
        public bool HasPck { get; set; }
        //指定启用mod时要加载的. pck文件的相对路径(从mod根文件夹)
        public string? PckToLoad { get; set; }
        //是否有c#代码补丁或拓展
        public bool HasCsharp { get; set; }
        //c#的DLL文件路径
        public string? AssemblyModClass { get; set; }
        //图片名称列表
        public string[] ImgList { get; set; }
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