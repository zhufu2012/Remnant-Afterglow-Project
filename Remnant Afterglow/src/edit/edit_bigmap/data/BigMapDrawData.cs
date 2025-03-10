using GameLog;
using Godot;
using Remnant_Afterglow;
using System;
using System.Collections.Generic;

namespace Remnant_Afterglow_EditMap
{
    /// <summary>
    /// 地图绘制数据，一个地图的数据
    /// </summary>
    public class BigMapDrawData
    {
        /// <summary>
        /// 地图名称
        /// </summary>
        public string mapName;
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
        /// <summary>
        /// 当前加载的mod列表，如果要编辑这个地图文件，尽量要求当前加载的动过地图的mod列表一样,版本等也一样，不同要警告！
        /// </summary>
        public Dictionary<string, ModAllInfo> loadModDict = new Dictionary<string, ModAllInfo>();

        public BigMapDrawData(string mapName, int Width, int Height)
        {
            this.mapName = mapName;
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
            loadModDict = ModLoadSystem.loadModDict;
        }

        /// <summary>
        /// 保存地图数据
        /// </summary>
        public bool SaveData(string path, string name)
        {
            try
            {
                FileUtils.WriteObjectSmartParam(path + name + PathConstant.GetPathUser(EditConstant.BigMap_FileSuffix), this);
                return true;
            }
            catch (Exception e)
            {
                Log.Error(e.StackTrace);
                return false;
            }
        }

        /// <summary>
        /// 根据地图文件路径，获取对应的地图数据-没查到返还null
        /// </summary>
        /// <returns></returns>
        public static MapDrawData GetMapDrawData(string mapPath, string name)
        {
            MapDrawData mapDrawData = FileUtils.ReadObjectSmart<MapDrawData>(mapPath, name);
            return mapDrawData;
        }



    }
}