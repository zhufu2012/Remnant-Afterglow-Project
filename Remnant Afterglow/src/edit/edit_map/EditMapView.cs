using Godot;
using Remnant_Afterglow;

namespace Remnant_Afterglow_EditMap
{
    /// <summary>
    /// 地图编辑器
    /// </summary>
    public partial class EditMapView : Control
    {
        #region 控件
        /// <summary>
        /// 返回按钮,点击返回上一个页面
        /// </summary>
        public Button ReturnButton = new Button();
        public TileMap tileMap = new TileMap();
        public TileSet tileSet = new TileSet();
        #endregion
        /// <summary>
        /// 地图当前大小
        /// </summary>
        public Vector2I MapSize = EditConstant.Define_MapSize;
        /// <summary>
        /// 图块资源
        /// </summary>
        public LoadTileSetConfig loadTileSetConfig;

        public int mapType = 1;
        /// <summary>
        /// 当前的地图数据的路径
        /// </summary>
        public string nowPath;
        /// <summary>
        /// 当前使用的地图数据
        /// </summary>
        public MapDrawData nowMapData;
        /// <summary>
        /// 地图各层数据
        /// </summary>
        public Dictionary<int, Cell[,]> layerData = new Dictionary<int, Cell[,]>();
        public override void _Ready()
        {
            mapType = (int)SceneManager.GetParam("MapType");
            nowMapData = (MapDrawData)SceneManager.GetParam("MapData");
            nowPath = (string)SceneManager.GetParam("MapDataPath");
            SceneManager.DataClear();//清空数据
            layerData = nowMapData.layerData;

            LoadMapConfig.InitData();


            InitMapCfg();
            InitView();
        }

        /// <summary>
        /// 初始化地图配置
        /// </summary>
        public void InitMapCfg()
        {
            loadTileSetConfig = new LoadTileSetConfig(1);
            tileMap = GetNode<TileMap>("TileMap");
            tileSet = loadTileSetConfig.GetTileSet();
            tileMap.TileSet = tileSet;
        }

        public void InitView()
        {
            ReturnButton = GetNode<Button>("Camera2D/CanvasLayer/ReturnButton");
            ReturnButton.ButtonDown += ReturnView;
        }


        /// <summary>
        /// 返回上一个界面
        /// </summary>
        public void ReturnView()
        {
            SceneManager.ChangeSceneBackward(this);
        }

        //保存当前地图
        public void SaveMap()
        {
            nowMapData.SaveMapData(layerData);
        }


        #region 暂时没用的变量
        /// <summary>
        /// 数据是否脏了, 也就是是否有修改
        /// </summary>
        public bool IsDirty { get; private set; }
        /// <summary>
        /// 鼠标坐标
        /// </summary>
        private Vector2 _mousePosition;
        /// <summary>
        /// 鼠标所在的cell坐标
        /// </summary>
        private Vector2I _mouseCellPosition;
        /// <summary>
        /// 上一帧鼠标所在的cell坐标
        /// </summary>
        private Vector2I _prevMouseCellPosition = new Vector2I(-99999, -99999);
        /// <summary>
        /// 单次绘制是否改变过tile数据
        /// </summary>
        private bool _changeFlag = false;
        /// <summary>
        /// 左键开始按下时鼠标所在的坐标
        /// </summary>
        private Vector2I _mouseStartCellPosition;
        /// <summary>
        /// 鼠标中建是否按下
        /// </summary>
        private bool _isMiddlePressed = false;
        private Vector2 _moveOffset;
        /// <summary>
        /// 左键是否按下
        /// </summary>
        private bool _isLeftPressed = false;
        /// <summary>
        /// 右键是否按下
        /// </summary>
        private bool _isRightPressed = false;
        /// <summary>
        /// 绘制填充区域
        /// </summary>
        private bool _drawFullRect = false;
        #endregion
    }
}