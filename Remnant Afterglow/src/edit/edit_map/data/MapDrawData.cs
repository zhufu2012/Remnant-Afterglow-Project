using Remnant_Afterglow;
using System.Collections.Generic;

namespace Remnant_Afterglow_EditMap
{
    
    public class UserMapImageData
    {
        //拥有的图层id列表
        public List<int> User_MapLayerIdList;
        //使用的资源块id列表
        public List<int> User_MapMassifIdList;
        //使用的地块材料id列表
        public List<int> User_MapMaterialIdList;

    }

    //地图绘制数据，一个地图的数据
    public class MapDrawData
    {
        //当前加载的mod列表，如果要编辑这个地图文件，尽量要求当前加载的动过地图的mod列表一样,版本等也一样，不同要警告！
        public List<ModInfo> loadModList = new List<ModInfo>();

        //地图使用资源数据
        public UserMapImageData UserMapData;

        //地图宽度
        public int Width = 0;
        //地图高度
        public int Height = 0;
        //地图各层数据
        public Dictionary<int, Cell[,]> layerData = new Dictionary<int, Cell[,]>();

        //保存地图数据
        public SaveMapData(Dictionary<int, Cell[,]> layerData)
        {
            this.layerData = layerData;
        }



    }
}