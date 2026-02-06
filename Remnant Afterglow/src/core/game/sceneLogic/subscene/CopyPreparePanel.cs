using Godot;
using System;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
	/// <summary>
	/// 关卡准备界面
	/// </summary>
	public partial class CopyPreparePanel : SubScene
	{
		#region
		/// <summary>
		/// 返回按钮
		/// </summary>
		public Button returnBut;

		/// <summary>
		/// 开始按钮
		/// </summary>
		public Button startBut;
		/// <summary>
		/// 任务名称
		/// </summary>
		public Label taskNameLab;
		#endregion

		/// <summary>
		/// 章节id
		/// </summary>
		public int chapterId;
		/// <summary>
		/// 关卡id
		/// </summary>
		public int copyId;
		/// <summary>
		/// 选择的关卡模式 0 战役模式  1 挑战模式
		/// </summary>
		public int modelType;
		/// <summary>
		/// 战役基础配置数据
		/// </summary>
		public ChapterBase chapterBase;
		/// <summary>
		/// 战役关卡数据
		/// </summary>
		public ChapterCopyBase chapterCopyBase;
		public ChapterCopyUI chapterCopyUI;

		public override void Initialize(Dictionary<string, object> parameters)
		{
			base.Initialize(parameters);
			// 访问上下文数据
			chapterId = (int)parameters["chapter_id"];
			copyId = (int)parameters["copy_id"];
			chapterBase = (ChapterBase)parameters["chapterBase"];
			chapterCopyBase = (ChapterCopyBase)parameters["chapterCopyBase"];
			modelType = (int)parameters["modelType"];
			chapterCopyUI = ConfigCache.GetChapterCopyUI(chapterCopyBase.CopyUiId);
		}
		public override void _Ready()
		{
			InitView();
		}

		public void InitView()
		{
			returnBut = GetNode<Button>("NinePatchRect/NinePatchRect3/返回按钮");
			taskNameLab = GetNode<Label>("NinePatchRect/NinePatchRect/任务名称");
			startBut = GetNode<Button>("NinePatchRect/NinePatchRect3作战开始/开始按钮");
			returnBut.ButtonDown += ReturnBut_ButtonDown;
			startBut.ButtonDown += Start_ButtonDown;
			taskNameLab.Text = chapterCopyUI.CopyName;
		}


		/// <summary>
		/// 点击返回按钮
		/// </summary>
		private void ReturnBut_ButtonDown()
		{

			WindowManager.Window_CloseCurrentWindow();
		}

		/// <summary>
		/// 点击开始按钮-进入作战地图
		/// </summary>
		private void Start_ButtonDown()
		{
			SceneManager.PutParam("ChapterId", chapterId);//章节
			SceneManager.PutParam("CopyId", copyId);//关卡
			SceneManager.ChangeScenePath("MapCopy", SceneTransitionType.BattleMap, this);
		}

		public void SetVisible()
		{

		}
	}
}
