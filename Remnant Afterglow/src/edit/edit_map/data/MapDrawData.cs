using Godot;
using Remnant_Afterglow;
using System;
using System.Collections.Generic;

namespace Remnant_Afterglow_EditMap
{
    /// <summary>
    /// 地图绘制数据，一个地图的数据
    /// </summary>
    public class MapDrawData
    {
        /// <summary>
        /// 当前加载的mod列表，如果要编辑这个地图文件，尽量要求当前加载的动过地图的mod列表一样,版本等也一样，不同要警告！
        /// </summary>
        public List<ModInfo> loadModList = new List<ModInfo>();

        /// <summary>
        /// 当前加载的mod字典，如果要编辑这个地图文件，尽量要求当前加载的动过地图的mod列表一样,版本等也一样，不同要警告！
        /// </summary>
        public Dictionary<string, ModAllInfo> load_mod_list = new Dictionary<string, ModAllInfo>();

        /// <summary>
        /// 地图宽度
        /// </summary>
        public int Width = 0;
        /// <summary>
        /// 地图高度
        /// </summary>
        public int Height = 0;
        /// <summary>
        /// 地图各层数据
        /// </summary>
        public Dictionary<int, Cell[,]> layerData = new Dictionary<int, Cell[,]>();

        public MapDrawData(int Width,int Height)
        {
            this.Width = Width;
            this.Height = Height;
        }



        /// <summary>
        /// 设置地图数据
        /// </summary>
        /// <param name="layerData"></param>
        public void SetMapData(Dictionary<int, Cell[,]> layerData)
        {
            this.layerData = layerData;
            this.loadModList = ModLoadSystem.load_mod_list;
        }

        /// <summary>
        /// 保存地图数据
        /// </summary>
        public bool SaveData(string path,string name)
        {
            FileUtils.WriteObjectSmartParam(path + name + PathConstant.GetPathUser(EditConstant.Map_Path), this);
        }

        /// <summary>
        /// 根据地图文件路径，获取对应的地图数据-没查到返还null
        /// </summary>
        /// <returns></returns>
        public static MapDrawData GetMapDrawData(string mapPath,string name)
        {
            MapDrawData mapDrawData = FileUtils.ReadObjectSmart<SaveFile>(mapPath, name);
            return mapDrawData;
        }



    }
}