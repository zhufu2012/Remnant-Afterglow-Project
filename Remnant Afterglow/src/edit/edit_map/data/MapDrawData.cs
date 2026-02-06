using GameLog;
using Godot;
using Newtonsoft.Json;
using Remnant_Afterglow;
using System;
using System.Collections.Generic;

namespace Remnant_Afterglow_EditMap
{
    /// <summary>
    /// 格子数据压缩
    /// </summary>
    public class CellData
    {
        /// <summary>
        /// 材料序号 MaterialId
        /// </summary>
        public int p1;
        /// <summary>
        /// <x,y,层id>
        /// </summary>
        public List<List<int>> p6 = new List<List<int>>();
        public CellData(int p1)
        {
            this.p1 = p1;
        }
        public void AddList(List<int> v)
        {
            p6.Add(v);
        }
        public override bool Equals(object obj)
        {
            if (obj is CellData other)
            {
                return other.p1 == p1;
            }
            return false;
        }
    }

    /// <summary>
    /// 实体压缩数据
    /// </summary>
    public class EntityData
    {
        /// <summary>
        /// 实体id
        /// </summary>
        public int ob_id;
        /// <summary>
        /// 数据列表 Camp,PosX,PosY
        /// </summary>
        public List<List<int>> PosL = new List<List<int>>();
        public EntityData(int ob_id)
        {
            this.ob_id = ob_id;
        }
        public void AddEntity(int Camp, Vector2I Pos)
        {
            PosL.Add(new List<int>() { Camp, Pos.X, Pos.Y });
        }

        public void Remove(int index)
        {
            PosL.RemoveAt(index);
        }
    }
    /// <summary>
    /// 地图绘制数据，一个地图的数据
    /// </summary>
    public class MapDrawData
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
        /// 地图各层数据-解压
        /// </summary>
        [JsonIgnore]
        public Dictionary<int, Cell[,]> layerData = new Dictionary<int, Cell[,]>();

        /// <summary>
        /// 当前加载的mod列表，如果要编辑这个地图文件，尽量要求当前加载的动过地图的mod列表一样,版本等也一样，不同要警告！
        /// </summary>
        public Dictionary<string, ModAllInfo> loadModDict = new Dictionary<string, ModAllInfo>();
        /// <summary>
        /// <材料序号，格子压缩数据>
        /// </summary>
        public Dictionary<int, CellData> dataDict = new Dictionary<int, CellData>();

        /// <summary>
        /// <实体id, 实体数据>
        /// </summary>
        public Dictionary<int, EntityData> entityDict = new Dictionary<int, EntityData>();
        #region 编辑器数据

        /// <summary>
        /// 当前选中绘制的层
        /// </summary>
        public int NowLayer;
        /// <summary>
        /// 编辑器当前显示的层
        /// </summary>
        public List<int> NowShowLayer = new List<int>();

        #endregion
        public MapDrawData(string mapName, int Width, int Height)
        {
            this.mapName = mapName;
            this.Width = Width;
            this.Height = Height;
            List<MapImageLayer> list = ConfigCache.GetAllMapImageLayer();
            NowLayer = 1;
            foreach (var info in list)
            {
                NowShowLayer.Add(info.ImageLayerId);
            }
        }

        /// <summary>
        /// 数据解压
        /// </summary>
        public void Decompression()
        {
            layerData.Clear();
            foreach (var info in dataDict)
            {
                CellData celldata = info.Value;
                int p1 = celldata.p1;//材料配置
                MapFixedMaterial mat = ConfigCache.GetMapFixedMaterial(p1);
                int p2 = mat.PassTypeId;//可通过类型
                int p3 = mat.ImageSetId;//图像集序号，MapImageSet中CfgDataList的序号
                int index = mat.ImageSetIndex;//所在图集序号
                Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_MapImageSet, mat.ImageSetId);
                if (dict != null)
                {
                    int max_index = (int)dict["ImageSetMaxId"];//
                    Vector2I Pos = new Vector2I(-1, -1);//瓦片在图集中的位置
                    if (max_index >= index)//在最大可使用序列内
                    {
                        Vector2I size = (Vector2I)dict["MapImageSize"];
                        int y = (index - 1) / size.X;
                        Pos = new Vector2I(index - y * size.X - 1, y);
                    }
                    else
                    {
                        int setId = (int)dict["MapImageSetId"];
                        Log.Error("材料id:" + p1 + "的使用序列，超出图集" + setId + " 的最大使用序列,请检查材料数据是否正确！");
                        continue;
                    }
                    foreach (List<int> item in celldata.p6)
                    {
                        if (layerData.ContainsKey(item[2]))//存在对应层数据
                        {
                            layerData[item[2]][item[0], item[1]] = new Cell(item[0], item[1], p1, p2, p3, index, Pos);
                        }
                        else//不存在就先创建
                        {
                            layerData[item[2]] = new Cell[Width, Height];
                            layerData[item[2]][item[0], item[1]] = new Cell(item[0], item[1], p1, p2, p3, index, Pos);
                        }
                    }
                }
            }
        }

        /// <summary>
        /// 数据压缩
        /// </summary>
        public void Compress()
        {
            dataDict.Clear();
            foreach (var layerInfo in layerData)
            {
                int layer = layerInfo.Key;
                Cell[,] cells = layerInfo.Value;
                for (int i = 0; i < cells.GetLength(0); i++)
                {
                    for (int j = 0; j < cells.GetLength(1); j++)
                    {
                        if (cells[i, j].index != 0)
                        {
                            Cell cell = cells[i, j];
                            if (!dataDict.ContainsKey(cell.index))
                            {
                                dataDict[cell.index] = new CellData(cell.index);
                            }
                            dataDict[cell.index].AddList(new List<int> { i, j, layer });
                        }
                    }
                }
            }
        }

        /// <summary>
        /// 设置地图数据
        /// </summary>
        /// <param name="layerData"></param>
        public void SetMapData(Dictionary<int, Cell[,]> layerData, Dictionary<int, EntityData> entityDict)
        {
            this.layerData = layerData;
            this.entityDict = entityDict;
            loadModDict = ModLoadSystem.loadModDict;
        }

        /// <summary>
        /// 更新地图数据
        /// </summary>
        public void UpdateMapData(int Layer)
        {
            NowLayer = Layer;
        }

        /// <summary>
        /// 保存地图数据
        /// </summary>
        public bool SaveData(string path, string name)
        {
            try
            {
                Compress();//数据压缩
                FileUtils.WriteObjectSmartParam(path + name, this);
                return true;
            }
            catch (Exception e)
            {
                Log.Error(e.StackTrace);
                return false;
            }
        }

        /// <summary>
        /// 获取该地图文件中共有多少种材料，该函数用于简化边缘连接和阴影连接的计算量
        /// </summary>
        /// <returns>包含所有不同材料ID的列表</returns>
        public List<int> GetMaterialIdList()
        {
            HashSet<int> materialIds = new HashSet<int>();
            foreach (var layer in layerData.Values)
            {
                for (int y = 0; y < Height; y++)
                {
                    for (int x = 0; x < Width; x++)
                    {
                        // 假设 Cell 结构体有一个名为 index 的 int 字段来表示材料类型
                        if (!materialIds.Contains(layer[y, x].index)) // 确保单元格不为空
                        {
                            materialIds.Add(layer[y, x].index);
                        }
                    }
                }
            }
            // 将 HashSet 转换为 List 并返回
            return new List<int>(materialIds);
        }

        /// <summary>
        /// 根据地图文件路径，获取对应的地图数据-没查到返还null
        /// </summary>
        /// <returns></returns>
        public static MapDrawData GetMapDrawData(string mapPath, string name)
        {
            MapDrawData mapDrawData = FileUtils.ReadObjectSmart<MapDrawData>(mapPath, name);
            mapDrawData.Decompression();//地图文件解压
            return mapDrawData;
        }
    }
}