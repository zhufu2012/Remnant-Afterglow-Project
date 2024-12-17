using Godot;
using Remnant_Afterglow;

namespace Remnant_Afterglow_EditMap
{
    //地图编辑器
    public partial class EditMapView : Control
    {
        #region 控件
        //返回按钮,点击返回上一个页面
        public Button ReturnButton = new Button();
        //地图大小-横轴编辑框
        public LineEdit EditMapSizeX = new LineEdit();
        //地图大小-纵轴编辑框
        public LineEdit EditMapSizeY = new LineEdit();

        //地图图层列表
        public ItemList MapLayerItemList = new ItemList();
        //地图碰撞层列表
        public ItemList MapPhysicsLayerItemList = new ItemList();
        //地图材料列表
        public ItemList MapMaterialItemList = new ItemList();
        #endregion

        //地图当前大小
        public Vector2I MapSize = EditConstant.Define_MapSize;
        /// <summary>
        /// 图块资源
        /// </summary>
        public LoadTileSetConfig loadTileSetConfig;

        //当前的地图数据的路径
        public string nowPath;
        //当前使用的地图数据
        public MapDrawData nowMapData;


        /// <summary>
        /// 数据是否脏了, 也就是是否有修改
        /// </summary>
        public bool IsDirty { get; private set; }
        //鼠标坐标
        private Vector2 _mousePosition;
        //鼠标所在的cell坐标
        private Vector2I _mouseCellPosition;
        //上一帧鼠标所在的cell坐标
        private Vector2I _prevMouseCellPosition = new Vector2I(-99999, -99999);
        //单次绘制是否改变过tile数据
        private bool _changeFlag = false;
        //左键开始按下时鼠标所在的坐标
        private Vector2I _mouseStartCellPosition;
        //鼠标中建是否按下
        private bool _isMiddlePressed = false;
        private Vector2 _moveOffset;
        //左键是否按下
        private bool _isLeftPressed = false;
        //右键是否按下
        private bool _isRightPressed = false;
        //绘制填充区域
        private bool _drawFullRect = false;
        public override void _Ready()
        {
            InitMapCfg();
            InitView();
        }

        //初始化地图配置
        public void InitMapCfg()
        {
            loadTileSetConfig = new LoadTileSetConfig(1);
        }

        public void InitView()
        {
            ReturnButton = GetNode<Button>("Panel/ReturnView");
            ReturnButton.ButtonDown += ReturnView;
        }


        /// <summary>
        /// 返回上一个界面
        /// </summary>
        public void ReturnView()
        {
            SceneManager.ChangeSceneBackward(this);
        }
    }
}