using GameLog;
using Godot;
using System;
using System.Collections.Generic;


namespace Remnant_Afterglow
{
	/// <summary>
	/// 关卡选择界面
	/// </summary>
	public partial class CopySelectPanel : SubScene
	{
		/// <summary>
		/// 章节id
		/// </summary>
		public int chapterId;
		/// <summary>
		/// 关卡id
		/// </summary>
		public int copyId;
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
			chapterCopyUI = ConfigCache.GetChapterCopyUI(chapterCopyBase.CopyUiId);
		}

		#region
		/// <summary>
		/// 返回按钮
		/// </summary>
		[Export]
		public Button returnBut;
		/// <summary>
		/// 选择的关卡模式
		/// </summary>
		[Export]
		public OptionButton optionButton;
		/// <summary>
		/// 准备按钮
		/// </summary>
		[Export]
		public Button prepareBut;
		/// <summary>
		/// 任务名称
		/// </summary>
		[Export]
		public Label taskNameLab;
		/// <summary>
		/// 任务介绍
		/// </summary>
		[Export]
		public RichTextLabel introduceLab;

		public override void _Ready()
		{
			returnBut.ButtonDown += ReturnBut_ButtonDown;
			prepareBut.ButtonDown += PrepareBut_ButtonDown;
			taskNameLab.Text = chapterCopyUI.CopyName;
			introduceLab.Text = chapterCopyUI.Describe1;
		}
		/// <summary>
		/// 点击准备按钮
		/// </summary>
		private void PrepareBut_ButtonDown()
		{
			// 关卡选择管理器
			WindowManager.Instance.OpenWindow<CopyPreparePanel>(new Dictionary<string, object>
							{
								{ "modelType", optionButton.GetSelectedId() }
							});
		}

		/// <summary>
		/// 点击返回按钮
		/// </summary>
		private void ReturnBut_ButtonDown()
		{
			WindowManager.Window_GoBack();
		}
		#endregion
	}
}
