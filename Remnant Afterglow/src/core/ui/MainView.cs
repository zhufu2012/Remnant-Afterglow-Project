using GameLog;
using Godot;

namespace Remnant_Afterglow
{
	public partial class MainView : Control
	{
		public Button but_start_game;   //开始游戏
		public Button but_multi_player; //多人游戏
		public Button but_map_edit;     //地图编辑器
		public Button but_archival;     //档案库
		public Button but_model;    //模组

		public Button but_setting;  //设置
		public Button but_quit; //退出

		public Button but_achievement;  //成就
		public Button but_thank;    //致谢
		public Button but_language; //语言

		/// <summary>
		/// 操作界面
		/// </summary>
		public MapOpManager mapOpManager;

		public override void _Ready()
		{
			InitView();
		}

		public void InitView()
		{
			but_start_game = GetNode<Button>("view/but_start_game");
			but_multi_player = GetNode<Button>("view/but_multi_player");
			but_map_edit = GetNode<Button>("view/but_map_edit");
			but_archival = GetNode<Button>("view/but_archival");

			but_model = GetNode<Button>("view/but_model");
			but_setting = GetNode<Button>("view/but_setting");
			but_quit = GetNode<Button>("view/but_quit");
			but_achievement = GetNode<Button>("view/but_achievement");
			but_thank = GetNode<Button>("view/but_thank");

			but_start_game.ButtonDown += StartGame;
			but_multi_player.ButtonDown += MultiPlayer;
			but_map_edit.ButtonDown += MapEdit;
			but_archival.ButtonDown += ArchivalView;

			but_model.ButtonDown += Model;
			but_setting.ButtonDown += SetUp;
			but_quit.ButtonDown += Quit;
			but_achievement.ButtonDown += Achievement;
			but_thank.ButtonDown += Thank;
		}


		public override void _Process(double delta)
		{
			base._Process(delta);
		}



		/// <summary>
		/// 地图编辑器
		/// </summary>
		public void MapEdit()
		{
			Log.Print("地图编辑器");
			SceneManager.ChangeSceneName("EditMapCreateView", this);
		}

		/// <summary>
		/// 档案库
		/// </summary>
		public void ArchivalView()
		{
			Log.Print("档案库");
		}

		/// <summary>
		/// 开始游戏-跳转到存档管理界面
		/// </summary>
		public void StartGame()
		{
			AddOpView();
			Log.Print("开始游戏");
			SceneManager.ChangeSceneName("SaveLoadView", this);
			//GetTree().ChangeSceneToFile("res://src/core/ui/view/archive_view/SaveLoadView.tscn");
		}

		/// <summary>
		/// 多人游戏
		/// </summary>
		public void MultiPlayer()
		{
			AddOpView();
			Log.Print("多人游戏");
		}

		/// <summary>
		/// 模组管理器
		/// </summary>
		public void Model()
		{
			SceneManager.ChangeSceneName("ModManageView", this);
		}

		/// <summary>
		/// 设置
		/// </summary>
		public void SetUp()
		{
			SceneManager.ChangeSceneName("SettingView", this);
		}

		/// <summary>
		/// 退出游戏
		/// </summary>
		public void Quit()
		{
			Log.Print("退出游戏");
			GetTree().Quit();
		}

		/// <summary>
		/// 成就
		/// </summary>
		public void Achievement()
		{
			Log.Print("成就");
		}

		/// <summary>
		/// 致谢
		/// </summary>
		public void Thank()
		{
			Log.Print("致谢");
		}

		/// <summary>
		/// 添加操作界面-游戏开始添加
		/// </summary>
		public void AddOpView()
		{
			mapOpManager = GD.Load<PackedScene>("res://src/core/controllers/operation/MapOpManager.tscn").Instantiate<MapOpManager>();
			GetTree().Root.AddChild(mapOpManager);//添加操作界面
		}
	}
}
