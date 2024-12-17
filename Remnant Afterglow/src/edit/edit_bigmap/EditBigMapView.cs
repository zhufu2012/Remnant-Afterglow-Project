using Godot;
using Remnant_Afterglow;


namespace Remnant_Afterglow_EditMap
{
    /// <summary>
    /// 地图编辑器
    /// </summary>
    public partial class EditBigMapView : Control
    {
        //返回按钮,点击返回上一个页面
        public Button ReturnButton = new Button();
        //地图大小-横轴编辑框
        public LineEdit EditMapSizeX = new LineEdit();
        //地图大小-纵轴编辑框
        public LineEdit EditMapSizeY = new LineEdit();

        //地图大小
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

        public override void _Ready()
        {
            InitMapCfg();
            InitView();
        }

        //初始化地图配置
        public void InitMapCfg()
        {
            loadTileSetConfig = new LoadTileSetConfig(2);
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