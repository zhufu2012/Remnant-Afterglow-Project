using GameLog;
using Godot;

namespace Remnant_Afterglow
{
	public partial class MainView : Control
	{
		public TextureButton but_start_game;   //开始游戏
		public TextureButton but_multi_player; //多人游戏
		public TextureButton but_map_edit;     //地图编辑器
		public TextureButton but_archival;     //档案库
		public TextureButton but_model;    //模组

		public TextureButton but_setting;  //设置
		public TextureButton but_quit; //退出

		public TextureButton but_achievement;  //成就
		public TextureButton but_thank;    //致谢
		public TextureButton but_language; //语言

		public override void _Ready()
		{
			MapOpManager.Instance.SetOpView(OpViewType.None);
			InitView();
		}

		public void InitView()
		{
			but_start_game = GetNode<TextureButton>("view/but_start_game");
			but_multi_player = GetNode<TextureButton>("view/but_multi_player");
			but_map_edit = GetNode<TextureButton>("view/but_map_edit");
			but_archival = GetNode<TextureButton>("view/but_archival");

			but_model = GetNode<TextureButton>("view/but_model");
			but_setting = GetNode<TextureButton>("view/but_setting");
			but_quit = GetNode<TextureButton>("view/but_quit");
			but_achievement = GetNode<TextureButton>("view2/but_achievement");
			but_thank = GetNode<TextureButton>("view2/but_thank");

			but_start_game.ButtonDown += StartGame;
			but_multi_player.ButtonDown += MultiPlayer;
			but_map_edit.ButtonDown += MapEdit;
			but_archival.ButtonDown += ArchivalView;

			but_model.ButtonDown += ModelManager;
			but_setting.ButtonDown += SetUp;
			but_quit.ButtonDown += Quit;
			but_achievement.ButtonDown += Achievement;
			but_thank.ButtonDown += Thank;
		}


		/// <summary>
		/// 地图编辑器
		/// </summary>
		public void MapEdit()
		{
			Log.Print("地图编辑器");
			SceneManager.ChangeScenePath("EditMapCreateView", SceneTransitionType.MainChange, this);
		}

		/// <summary>
		/// 档案库
		/// </summary>
		public void ArchivalView()
		{
			Log.Print("档案库");
			SceneManager.ChangeScenePath("ArchivalView", SceneTransitionType.MainChange, this);
		}

		/// <summary>
		/// 开始游戏-跳转到存档管理界面
		/// </summary>
		public void StartGame()
		{
			Log.Print("开始游戏");
			SceneManager.ChangeScenePath("SaveLoadView", SceneTransitionType.MainChange, this);
		}

		/// <summary>
		/// 多人游戏
		/// </summary>
		public void MultiPlayer()
		{
			Log.Print("多人游戏");
		}

		/// <summary>
		/// 模组管理器
		/// </summary>
		public void ModelManager()
		{
			SceneManager.ChangeScenePath("ModManageView", SceneTransitionType.MainChange, this);
		}

		/// <summary>
		/// 设置
		/// </summary>
		public void SetUp()
		{
			SceneManager.ChangeScenePath("SettingView", SceneTransitionType.MainChange, this);
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
	}
}
