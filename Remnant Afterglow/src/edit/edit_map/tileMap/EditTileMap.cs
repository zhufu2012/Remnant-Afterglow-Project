using GameLog;
using Godot;
using Remnant_Afterglow;
using System.Collections.Generic;

namespace Remnant_Afterglow_EditMap
{
    /// <summary>
    /// EditorTileMap-初始化操作
    /// </summary>
    public partial class EditTileMap : TileMap
    {
        /// <summary>
        /// 地图各层数据
        /// </summary>
        public Dictionary<int, Cell[,]> layerData = new Dictionary<int, Cell[,]>();
        /// <summary>
        /// 图块资源
        /// </summary>
        public LoadTileSetConfig loadTileSetConfig;
        /// <summary>
        /// 
        /// </summary>
        public MapDrawData drawData;
        /// <summary>
        /// 初始化各数据
        /// </summary>
        /// <param name="drawData"></param>
        public void InitData(MapDrawData drawData)
        {
            this.drawData = drawData;
            layerData = drawData.layerData;
            loadTileSetConfig = new LoadTileSetConfig(1);
            TileSet = loadTileSetConfig.GetTileSet();
            foreach (var Layer in layerData)//添加到所有层列表和所有显示层列表
            {
                allLayerList.Add(Layer.Key);
                showLayerList.Add(Layer.Key);
            }
        }

        #region 图层操作
        /// <summary>
        /// 是否初始化完成图层
        /// </summary>
        private bool _initLayer = false;
        /// <summary>
        /// 当前选择绘制的图层
        /// </summary>
        public int CurrLayer = 0;
        /// <summary>
        /// 当前选择显示的图层
        /// </summary>
        public List<int> showLayerList = new List<int>();
        /// <summary>
        /// 拥有的所有图层
        /// </summary>
        public List<int> allLayerList = new List<int>();
        /// <summary>
        /// 设置选择绘制的layer
        /// </summary>
        /// <param name="layer"></param>
        public void SetCurrLayer(int layer)
        {
            CurrLayer = layer;
            LayerItem item = EditMapView.Instance.layerSelectPanel.GetNowLayerItem();
            //item.Modulate = EditConstant.MapLayerSelectPanel_NowLayerColor;
        }

        /// <summary>
        /// 刷新层数据
        /// </summary>
        private void FlushLayerData()
        {
            allLayerList.Clear();
            foreach (var Layer in layerData)//添加到所有层列表和所有显示层列表
            {
                allLayerList.Add(Layer.Key);
            }
        }

        /// <summary>
        /// 刷新层启用情况
        /// </summary>
        public void FlushLayerEnabled()
        {
            FlushLayerData();
            showLayerList = EditMapView.Instance.layerSelectPanel.GetSelectLayerList();
            foreach (int layer in allLayerList)
            {
                ClearLayer(layer);//清理然后重新绘制
                if (showLayerList.Contains(layer))
                {
                    Cell[,] map = layerData[layer];//本层的结构
                    for (int i = 0; i < map.GetLength(0); i++)
                    {
                        for (int j = 0; j < map.GetLength(1); j++)
                        {
                            SetCell(layer, new Vector2I(i, j), map[i, j].MapImageId, map[i, j].ImagePos);
                        }
                    }
                }
            }
        }
        /// <summary>
        /// 修改层显示情况
        /// </summary>
        public void FlushLayer(int showlayer, bool isKey)
        {
            FlushLayerData();
            showLayerList = EditMapView.Instance.layerSelectPanel.GetSelectLayerList();
            if (isKey)//要绘制
            {
                if (layerData.ContainsKey(showlayer))//有该层
                {
                    Cell[,] map = layerData[showlayer];//本层的结构
                    for (int i = 0; i < map.GetLength(0); i++)
                    {
                        for (int j = 0; j < map.GetLength(1); j++)
                        {
                            SetCell(showlayer, new Vector2I(i, j), map[i, j].MapImageId, map[i, j].ImagePos);
                        }
                    }
                }
            }
            else//要隐藏
            {
                ClearLayer(showlayer);//清理
            }
        }
        #endregion

        public override void _Ready()
        {
            InitDrawMap();
            InitLayer();//初始化图层显示
        }

        /// <summary>
        /// 初始化绘制地图
        /// </summary>
        public void InitDrawMap()
        {
            foreach (var Layer in EditMapView.Instance.nowMapData.NowShowLayer)//添加各层
            {
                AddLayer(Layer);
            }

            foreach (var Layer in layerData)
            {
                int layer = Layer.Key;//当前层
                Cell[,] map = Layer.Value;//本层的结构
                for (int i = 0; i < map.GetLength(0); i++)
                {
                    for (int j = 0; j < map.GetLength(1); j++)
                    {
                        //对应层，位置，图像集id,图像集上位置
                        SetCell(layer, new Vector2I(i, j), map[i, j].MapImageId, map[i, j].ImagePos);
                    }
                }
            }
        }

        /// <summary>
        /// 初始化层数据
        /// </summary>
        public void InitLayer()
        {
            if (_initLayer)
            {
                return;
            }
            _initLayer = true;
        }


        /// <summary>
        /// 位置是否正确
        /// </summary>
        /// <returns></returns>
        public bool IsPos(Vector2 pos)
        {
            if (pos.X < drawData.Width && pos.X >= 0 && pos.Y < drawData.Height && pos.Y >= 0)
            {
                return true;
            }
            return false;
        }
    }
}
