using GameLog;
using Godot;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
	/// <summary>
	/// 大地图上
	/// </summary>
	public partial class BigMapCopy : Node2D
	{

		/// <summary>
		/// 单例模式，用于全局访问MainCopy实例
		/// </summary>
		public static BigMapCopy Instance { get; private set; }
		#region 地图生成
		/// <summary>
		/// 地图绘制节点
		/// </summary>
		public BigMapDraw bigMapDraw;
		/// <summary>
		/// 大地图碰撞器
		/// </summary>
		public Node2D BigCellList;
		#endregion


		#region
		/// <summary>
		/// 相机系统
		/// </summary>
		public BigMapCamera gameCamera;


		#endregion



		/// <summary>
		/// 关卡基础配置列表  <坐标，关卡基础配置>
		/// </summary>
		public Dictionary<Vector2I, ChapterCopyBase> copyBaseDict = new Dictionary<Vector2I, ChapterCopyBase>();
		/// <summary>
		/// 章节id
		/// </summary>
		public int ChapterId;
		/// <summary>
		/// 战役基础配置数据
		/// </summary>
		public ChapterBase chapterBase;

		/// <summary>
		/// 是否显示设置下的各按钮
		/// </summary>
		public bool is_show_setview = false;


		public BigMapCopy()
		{
			Instance = this;
		}

		public override void _Ready()
		{
			InitData();
			InitMapCfg();
		}

		/// <summary>
		/// 初始化数据
		/// </summary>
		public void InitData()
		{
			int ChapterId = (int)SceneManager.GetParam("chapter_id");
			SceneManager.DataClear();
			chapterBase = ConfigCache.GetChapterBase("" + ChapterId);
			BigCellList = GetNode<Node2D>("BigCellList");

			//设置对应坐标的章节战役关卡数据
			List<Dictionary<string, object>> list = ConfigLoadSystem.QueryCfgAllLine(ConfigConstant.Config_ChapterCopyBase, new Dictionary<string, object> { { "ChapterId", ChapterId } });
			for (int i = 0; i < list.Count; i++)
			{
				ChapterCopyBase chapterCopy = ConfigCache.GetChapterCopyBase("" + ChapterId + "_" + (int)list[i]["CopyId"]);
				copyBaseDict[chapterCopy.Pos] = chapterCopy;
			}
			gameCamera = GetNode<BigMapCamera>("gameCamera");//初始化游戏相机
			gameCamera.InitData(chapterBase.CameraId);
            MapOpManager.Instance.SetOpView(OpViewType.BigMap_OpView);
		}

		/// <summary>
		/// 地图绘制资源配置初始化
		/// </summary>
		public void InitMapCfg()
		{
			bigMapDraw = new BigMapDraw(ChapterId, new Vector2(0,0));
			AddChild(bigMapDraw);
		}

	}
}
