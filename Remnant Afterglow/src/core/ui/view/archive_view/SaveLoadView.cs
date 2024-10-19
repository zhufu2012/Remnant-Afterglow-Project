using GameLog;
using Godot;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
	public enum GamePlayerMode
	{
		SinglePerson = 1,
		ManyPerson = 2
	}

	/// <summary>
	/// 存档管理界面
	/// </summary>
	public partial class SaveLoadView : Control
	{
		public Button but_return_pre_view;//返回之前的界面 按钮
		public Button but_create_archive;//创建存档 按钮
		public Button but_enter_archive;//进入创建存档的界面 按钮
		public ScrollContainer scrollContainer;
		public VBoxContainer vBoxContainer;
		/// <summary>
		/// 游戏模式
		/// </summary>
		public GamePlayerMode player_mode;
		public Label lab_player_mode;
		/// <summary>
		/// 存档界面ui列表
		/// </summary>
		public List<SaveFileView> save_ui_list = new List<SaveFileView>();
		public List<SaveFile> file_list = new List<SaveFile>();
		public SaveLoadView()
		{
			LoadAllSaveFileUI();//加载全部存档的界面数据
		}


		public override void _Ready()
		{
			LoadView();

		}

		/// <summary>
		/// 加载全部存档的界面数据
		/// </summary>
		public void LoadAllSaveFileUI()
		{
			file_list = SaveLoadSystem.GetSaveFileList();
			int i = 0;
			foreach (SaveFile file in file_list)
			{

				SaveFileView saveFileUI = (SaveFileView)GD.Load<PackedScene>("res://scenes/ui/view/archive_view/SaveFile.tscn").Instantiate();
				saveFileUI.SetData(file);
				saveFileUI.Position = new Vector2(0, i * 162);
				save_ui_list.Add(saveFileUI);
				i++;
			}
		}

		public void LoadView()
		{
			but_return_pre_view = GetNode<Button>("Panel/Button");
			but_create_archive = GetNode<Button>("Panel/Panel/Button");
			but_enter_archive = GetNode<Button>("Panel/Button2");
			lab_player_mode = GetNode<Label>("Panel/Label");
			scrollContainer = GetNode<ScrollContainer>("Panel/Panel/ScrollContainer");
			scrollContainer.SetDeferred("scroll_vertical", 162);
			vBoxContainer = GetNode<VBoxContainer>("Panel/Panel/ScrollContainer/VBoxContainer");
			but_return_pre_view.ButtonDown += ReturnPreView;
			but_create_archive.ButtonDown += EnterCreateArchive;
			but_enter_archive.ButtonDown += EnterArchive;
			LoadSaveFile();
		}

		public void LoadSaveFile()
		{
			for (int i = 0; i < save_ui_list.Count; i++)
			{
				vBoxContainer.AddChild(save_ui_list[i]);
			}
		}



		/// <summary>
		/// 返回之前的界面
		/// </summary>
		public void ReturnPreView()
		{
			Log.Print("返回上一个界面");
			GetTree().ChangeSceneToFile("res://scenes/MainView.tscn");
		}
		/// <summary>
		/// 创建存档
		/// </summary>
		public void EnterCreateArchive()
		{
			Log.Print("进入存档创建界面");
			GetTree().ChangeSceneToFile("res://scenes/ui/view/archive_view/create/CreateArchiveView.tscn");
		}
		/// <summary>
		/// 确定进入选择的存档 按钮
		/// </summary>
		public void EnterArchive()
		{

			//MapDraw map = (MapDraw)GD.Load<PackedScene>("res://scenes/map/BigMapView.tscn").Instantiate();

			foreach (Panel fileView in GetNode<VBoxContainer>("Panel/Panel/ScrollContainer/VBoxContainer").GetChildren())
			{
				SaveFileView saveFileView = (SaveFileView)fileView;
				if (saveFileView.HasFocus())
				{
					BigMapDraw bigmap = (BigMapDraw)GD.Load<PackedScene>("res://scenes/map/BigMapView.tscn").Instantiate();
					SaveLoadSystem.SetNowSave(saveFileView.file);
					GlobalData.PutParam("chapter_id", saveFileView.file.chapter_id);
					GetTree().ChangeSceneToPacked(Common.GetPackedScene(bigmap));
				}
			}


		}

	}
}
