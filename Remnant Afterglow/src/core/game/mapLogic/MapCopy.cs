using GameLog;
using Godot;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 副本内部代码1
    /// </summary>
    public partial class MapCopy : Node2D
    {
        /// <summary>
        /// 副本关卡数据
        /// </summary>
        public ChapterCopyBase copyData;

        #region 各节点及初始化
        /// <summary>
        /// 绘制用列表
        /// </summary>
        public Node2D DrawNode;
        /// <summary>
        /// 单位列表
        /// </summary>
        public Node2D UnitNode;
        /// <summary>
        /// 防御塔列表
        /// </summary>
        public Node2D TowerNode;
        /// <summary>
        /// 建筑列表
        /// </summary>
        public Node2D BuildNode;
        /// <summary>
        /// 无人机列表
        /// </summary>
        public Node2D WorkerNode;
        /// <summary>
        /// 子弹列表
        /// </summary>
        public Node2D BulletNode;
        /// <summary>
        /// 相机
        /// </summary>
        public GameCamera gameCamera;
        #endregion

        #region 地图生成
        /// <summary>
        /// 地图绘制节点
        /// </summary>
        public MapDraw mapDraw;
        /// <summary>
        /// 导航区域根节点
        /// </summary>
        public Node2D NavigationRoot;
        #endregion

        #region 关卡各系统
        //地图基础逻辑-包含刷怪系统
        public MapLogic mapLogic;

        /// <summary>
        /// 子弹管理器
        /// </summary>
        public BulletManager bulletManager;
        /// <summary>
        /// 单位管理器
        /// </summary>
        public ObjectManager objectManager;
        /// <summary>
        /// 建造列表-及建筑管理器
        /// </summary>
        public ObjectBuildSystem objectBuildSystem;

        public MapOpManager mapOpManager = new mapOpManager();

        #endregion


        /// <summary>
        /// 游戏总时间
        /// </summary>
        public double NowTime = 0;

        /// <summary>
        /// 副本id
        /// </summary>
        public int ChapterId;
        /// <summary>
        /// 关卡id
        /// </summary>
        public int CopyId;


        /// <summary>
        /// 单例模式，用于全局访问MapCopy实例
        /// </summary>
        public static MapCopy Instance { get; set; }

        /// <summary>
        /// 获取视口的宽度
        /// </summary>
        public static float ViewportWidth => Instance.GetViewportRect().Size.X;
        /// <summary>
        /// 视口的高度
        /// </summary>
        public static float ViewportHeight => Instance.GetViewportRect().Size.Y;


        public MapCopy()
        {
            //SceneManager.PutParam("ChapterId", 1);//章节
            //SceneManager.PutParam("CopyId", 1);//关卡
            Instance = this;
        }
        public override void _Ready()
        {
            InitData();
            InitMapCfg();

            mapLogic.LogicStart();//地图逻辑-关卡逻辑开始
        }

        #region 初始化数据
        /// <summary>
        /// 初始化数据和各系统
        /// </summary>
        public void InitData()
        {
            ChapterId = (int)SceneManager.GetParam("ChapterId");
            CopyId = (int)SceneManager.GetParam("CopyId");
            copyData = new ChapterCopyBase(ChapterId, CopyId);
            SceneManager.DataClear()();
            DrawNode = GetNode<Node2D>("DrawList");
            UnitNode = GetNode<Node2D>("UnitList");
            TowerNode = GetNode<Node2D>("TowerList");
            BuildNode = GetNode<Node2D>("BuildList");
            WorkerNode = GetNode<Node2D>("WorkerList");
            NavigationRoot = GetNode<Node2D>("NavigationRoot");
            BulletNode = GetNode<Node2D>("BulletList");

            bulletManager = new BulletManager();// 初始化子弹管理器
            objectManager = new ObjectManager();// 初始化单位管理器
            gameCamera = new GameCamera(copyData.GenerateMapId);//游戏相机

            MapLogic = new MapLogic((MapGameModel)copyData.CopyType);//游戏逻辑构造
            AddChild(gameCamera);
            AddChild(mapOpManager);//添加操作界面
        }
        /// <summary>
        /// 获取可攻击目标的位置--祝福注释
        /// </summary>
        /// <returns></returns>
        private Vector2 GetPlayerPosition()
        {
            // 如果玩家实例存在，返回其位置；否则返回默认位置
            return new Vector2(0, 0);
        }

        TowerBase tower;
        /// <summary>
        /// 地图绘制资源配置初始化
        /// </summary>
        public void InitMapCfg()
        {
            mapDraw = new MapDraw(ChapterId, CopyId, gameCamera.canvasLayer.Size, gameCamera.canvasLayer.noise);
            AddChild(mapDraw);

            tower = new TowerBase(2001);
            TowerNode.AddChild(tower);//祝福注释-这里测试刷新炮塔
            //创建子弹
            bulletManager.CreateTopBullet("add2way", new Vector2(300, 300), 0, tower);
        }
        #endregion


        public override void _Process(double delta)
        {
            QueueRedraw();
        }

        /// <summary>
        /// 逻辑帧
        /// </summary>
        /// <param name="delta"></param>
        public override void _PhysicsProcess(double delta)
        {
            bulletManager.Update(delta); // 更新子弹管理器
            objectManager.Update(delta); // 实体更新逻辑
            bulletManager.PostUpdate(); // 执行子弹管理器的PostUpdate逻辑
            mapLogic.MapLogicUpdate();//地图逻辑更新
        }

        public override void _UnhandledInput(InputEvent @event)
        {
            if (@event is InputEventMouse mouseEvent)
            {
                // 检查是否是鼠标左键按下
                if (mouseEvent is InputEventMouseButton mb && mb.ButtonIndex == MouseButton.Left && mb.Pressed)
                {
                    
                   bulletManager.CreateTopBullet("add2way", ToGlobal( GetViewport().GetMousePosition()), 0, tower);
                    
                }
            }

        }
    }
}
