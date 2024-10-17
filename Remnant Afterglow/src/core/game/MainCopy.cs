using GameLog;
using Godot;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    public partial class MainCopy : Node2D
    {
        /// <summary>
        /// 副本关卡数据
        /// </summary>
        private ChapterCopyBase copyData;

        #region 各节点及初始化
        /// <summary>
        /// 绘制用列表
        /// </summary>
        private Node2D DrawNode;
        /// <summary>
        /// 单位列表
        /// </summary>
        private Node2D UnitNode;
        /// <summary>
        /// 防御塔列表
        /// </summary>
        private Node2D TowerNode;
        /// <summary>
        /// 建筑列表
        /// </summary>
        private Node2D BuildNode;

        /// <summary>
        /// 相机
        /// </summary>
        public GameCamera gameCamera;
        public MainCopy()
        {
            //GlobalData.PutParam("ChapterId", 1);//章节
            //GlobalData.PutParam("CopyId", 1);//关卡
        }
        #endregion

        #region 地图生成
        /// <summary>
        /// 地图绘制节点
        /// </summary>
        public MapDraw map_draw;
        /// <summary>
        /// 地图各层数据
        /// </summary>
        public Dictionary<int, Cell[,]> layer_dict = new Dictionary<int, Cell[,]>();
        #endregion

        #region 关卡各系统
        /// <summary>
        /// 怪物刷新系统
        /// </summary>
        public BrushSystem brushSystem;

        /// <summary>
        /// 导航系统
        /// </summary>
        public NavigationSystem navSystem;



        #endregion


        /// <summary>
        /// 游戏总时间
        /// </summary>
        public double nowTime = 0;

        public int ChapterId;//副本id
        public int CopyId;//关卡id
        //拖动的塔
	    private TowerBase heldTower { get; set; }
	    //选中的塔
	    private TowerBase selectedTower { get; set; }

        public override void _Ready()
        {
            InitData();
            InitMapCfg();
            InitBrushPoint();//初始化绘制刷新点
            InitNavigation();
        }

        #region 初始化数据
        /// <summary>
        /// 初始化地图数据
        /// </summary>
        public void InitData()
        {
            ChapterId = (int)GlobalData.GetParam("ChapterId");
            CopyId = (int)GlobalData.GetParam("CopyId");
            GlobalData.Clear();
            copyData = new ChapterCopyBase(ChapterId, CopyId);
            brushSystem = new BrushSystem(ChapterId, CopyId);//刷怪系统
            gameCamera = new GameCamera(copyData.GenerateMapId);//游戏相机
        }

        /// <summary>
        /// 地图绘制资源配置初始化
        /// </summary>
        public void InitMapCfg()
        {
            UnitNode = GetNode<Node2D>("UnitList");
            DrawNode = GetNode<Node2D>("DrawList");
            TowerNode = GetNode<Node2D>("TowerList");
            BuildNode = GetNode<Node2D>("BulidList");
            map_draw = new MapDraw(ChapterId, CopyId, gameCamera.canvasLayer.noise, gameCamera.canvasLayer.Size);
            AddChild(map_draw);
            AddChild(gameCamera);
            layer_dict = map_draw.layer_dict;
            TowerNode.AddChild(new TowerBase(1, 1));
        }



        /// <summary>
        /// 初始化导航系统
        /// </summary>
        public void InitNavigation()
        {
            navSystem = new NavigationSystem(map_draw.mapGenerate.Width, map_draw.mapGenerate.Height, layer_dict[MapLayer.FloorLayer1], brushSystem.brushDataDict);
        }

        /// <summary>
        /// 初始化绘制地图刷新点
        /// </summary>
        public void InitBrushPoint()
        {
            Node2D lineNode = brushSystem.GetBrushPoint();
            DrawNode.AddChild(lineNode);
        }
        #endregion


        public override void _Process(double delta)
        {
            QueueRedraw();
        }

        //逻辑帧
        public override void _PhysicsProcess(double delta)
        {
            BrushMonsterUpdate(delta);//刷怪系统刷新
            navSystemUpdate(delta);//导航系统刷新
            base._PhysicsProcess(delta);
        }

        public override void _UnhandledInput(InputEvent @event)
        {
            base._UnhandledInput(@event);
        }

        public override void _Input(InputEvent ev)
        {
            if(IsInstanceValid(heldTower))
            {
            }
        }

        /// <summary>
        /// 删除选中
        /// </summary>
        private void DeselectTower()
        {
            if(IsInstanceValid(heldTower))
                heldTower.QueueFree();
            if(!IsInstanceValid(selectedTower))
                return;
            selectedTower.isSelected = false;
            selectedTower.QueueRedraw();
            selectedTower = null;
            GetNode<Control>("HUD/SelectedTowerPanel").Hide();
        }

        private void SelectTower(TowerBase tower)
        {
            if(selectedTower is not null)
            {
                selectedTower.isSelected = false;
                selectedTower.QueueRedraw();
            }
            selectedTower = tower;
            tower.isSelected = true;
            selectedTower.QueueRedraw();
        }
        #region 逻辑帧

        /// <summary>
        /// 刷怪系统刷新，逻辑帧检查 刷怪
        /// </summary>
        /// <param name="delta"></param>
        public void BrushMonsterUpdate(double delta)
        {
            brushSystem.Update(delta);//刷新系统时间
            //刷怪列表，<刷新点id,<<怪物id,阵营>,数量>>
            Dictionary<int, Dictionary<KeyValuePair<int, int>, int>> dict = brushSystem.CheckRefreshEnemies(delta);//
            if (dict.Count > 0)
                Log.Print("刷新怪物：" + dict.Count);
            foreach (var info in dict)
            {
                foreach (var unit_info in info.Value)
                {
                    for (int i = 0; i < unit_info.Value; i++)
                    {
                        UnitBase unitBase = new UnitBase(unit_info.Key.Key, unit_info.Key.Value);
                        Vector2I rand_vec = navSystem.CreateUnitPos(info.Key);
                        unitBase.Position = rand_vec * MapConstant.TileCellSize - new Vector2I(MapConstant.TileCellSize / 2, MapConstant.TileCellSize / 2);
                        unitBase.ZIndex = MapLayer.ObjectLayer2;
                        UnitNode.AddChild(unitBase);
                    }
                }
            }
        }

        /// <summary>
        /// 导航系统刷新
        /// </summary>
        /// <param name=""></param>
        public void navSystemUpdate(double delta)
        {
            navSystem.Update(delta);
        }

        #endregion



    }
}
