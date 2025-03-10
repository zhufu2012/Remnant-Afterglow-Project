using GameLog;
using Godot;
using System;
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
		public MapCamera gameCamera;
		#endregion

		#region 地图生成
		/// <summary>
		/// 地图绘制节点
		/// </summary>
		public FixedTileMap fixedTileMap;
		#endregion

		#region 关卡各系统
		/// <summary>
		/// 地图基础逻辑-包含刷怪系统
		/// </summary>
		public MapLogic mapLogic;

		/// <summary>
		/// 子弹管理器
		/// </summary>
		public BulletManager bulletManager;
		/// <summary>
		/// 单位管理器
		/// </summary>
		public ObjectManager objectManager;

		public FlowFieldSystem flowFieldSystem;
		public FlowFieldDrawer flowFieldDrawer;
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
			Instance = this;
		}

		#region 初始化数据
		/// <summary>
		/// 初始化数据和各系统
		/// </summary>
		public void InitData()
		{
			ChapterId = (int)SceneManager.GetParam("ChapterId");
			CopyId = (int)SceneManager.GetParam("CopyId");
			SceneManager.DataClear();
			copyData = new ChapterCopyBase(ChapterId, CopyId);

			DrawNode = GetNode<Node2D>("DrawList");
			UnitNode = GetNode<Node2D>("UnitList");
			TowerNode = GetNode<Node2D>("TowerList");
			BuildNode = GetNode<Node2D>("BuildList");
			WorkerNode = GetNode<Node2D>("WorkerList");
			BulletNode = GetNode<Node2D>("BulletList");
			gameCamera = GetNode<MapCamera>("gameCamera");
			gameCamera.InitData(copyData.CameraId);//游戏相机

			bulletManager = new BulletManager();// 初始化子弹管理器
			mapLogic = new MapLogic((MapGameModel)copyData.CopyType, ChapterId, CopyId);//游戏逻辑构造
			AddChild(mapLogic);//游戏模式逻辑
			MapOpManager.Instance.SetOpView(OpViewType.Map_OpView);
		}

		/// <summary>
		/// 地图绘制资源配置初始化
		/// </summary>
		public void InitMapCfg()
		{
			fixedTileMap = GetNode<FixedTileMap>("FixedTileMap");
			fixedTileMap.InitData(copyData.GenerateMapId);
				//new FixedTileMap(copyData.GenerateMapId);
			fixedTileMap.Name = "fixedTileMap";
			flowFieldSystem = new FlowFieldSystem(fixedTileMap.Width, fixedTileMap.Height, fixedTileMap.layerData[MapConstant.MapLogicLayer]);//流场导航系统
			objectManager = new ObjectManager(fixedTileMap.Width, fixedTileMap.Height,fixedTileMap.layerData[MapConstant.MapLogicLayer]);// 初始化单位管理器
			if(IsShowFlow)//是否显示流场
			{
				flowFieldDrawer = new FlowFieldDrawer();//流场绘制显示
				flowFieldDrawer.ZIndex = 100;
				flowFieldDrawer.Name = "flowFieldDrawer";
				AddChild(flowFieldDrawer);
			}
		}

		public override void _Ready()
		{
			InitData();
			InitMapCfg();
			for (int i = 18; i < 19; i++)
			{
				for (int j = 5; j < 6; j++)
				{
					Random random = new Random();
					//int unitId = random.NextDouble() >= 0.1 ? 1001 : 1002;
					ObjectManager.Instance.CreateMapUnit(1001, new Vector2I(i, j));
				}
			}
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
			mapLogic.MapLogicUpdate(delta);//地图逻辑更新
		}




		/// <summary>
		/// 全局位置转换为格子坐标
		/// </summary>
		/// <param name="GlobalPosition"></param>
		/// <returns></returns>
		public static Vector2I GetWorldPos(Vector2 GlobalPosition)
		{
			return Instance.fixedTileMap.LocalToMap(GlobalPosition);
		}

		/// <summary>
		/// 格子坐标转换为地图格子中心位置
		/// </summary>
		/// <param name="cellPos"></param>
		/// <returns></returns>
		public static Vector2 GetCellCenter(Vector2I cellPos)
		{
			return Instance.fixedTileMap.MapToLocal(cellPos);
		}
	}
}
