using Godot;
namespace Remnant_Afterglow
{
	public partial class BigMapOpView : Control
	{
		/// <summary>
		/// 设置按钮
		/// </summary>
		[Export]
		public Button SetingButton;
		/// <summary>
		/// 科技树按钮
		/// </summary>
		[Export]
		public TextureButton ScienceButton;
		/// <summary>
		/// 档案库按钮
		/// </summary>
		[Export]
		public TextureButton RecordButton;
		/// <summary>
		/// 配置按钮
		/// </summary>
		[Export]
		public TextureButton ConfigButton;
		[Export]
		public ScienceTreeView ScienceTreeView;

		/// <summary>
		/// 动画
		/// </summary>
		[Export]
		public AnimationPlayer animation;
		/// <summary>
		/// 某个界面已开启
		/// </summary>
		public bool IsActive = false;
		/// <summary>
		/// 界面是否已经上升
		/// </summary>
		public bool IsUP = true;
		public override void _Ready()
		{
			SetingButton.ButtonDown += SetingButton_ButtonDown;
			ScienceButton.ButtonDown += ScienceButton_ButtonDown;
			RecordButton.ButtonDown += RecordButton_ButtonDown;
			ConfigButton.ButtonDown += ConfigButton_ButtonDown;
		}

		/// <summary>
		/// 配置按钮
		/// </summary>
		private void ConfigButton_ButtonDown()
		{
			if(IsActive)
			{
				IsActive = false;
			}
			else
			{
				IsActive = true;
			}
			if (IsUP)
			{
				if (IsActive)
				{
					animation.Play("操作界面下降");
					IsUP = false;
				}
			}
			else
			{
				if (!IsActive)
				{
					animation.Play("操作界面上升");
					IsUP = true;
				}
			}
		}

		/// <summary>
		/// 档案库按钮
		/// </summary>
		/// <exception cref="System.NotImplementedException"></exception>
		private void RecordButton_ButtonDown()
		{
			if (IsActive)
			{
				IsActive = false;
			}
			else
			{
				IsActive = true;
			}
			if (IsUP)
			{
				if (IsActive)
				{
					animation.Play("操作界面下降");
					IsUP = false;
				}
			}
			else
			{
				if (!IsActive)
				{
					animation.Play("操作界面上升");
					IsUP = true;
				}
			}
		}

		private void SetingButton_ButtonDown()
		{
		}
		/// <summary>
		/// 科技树按钮
		/// </summary>
		private void ScienceButton_ButtonDown()
		{
			// 检查科技树视图当前是否可见
			if (ScienceTreeView.Visible)
			{
				// 如果可见，则隐藏科技树视图
				ScienceTreeView.Visible = false;
				IsActive = false;
			}
			else
			{
				// 如果不可见，则显示科技树视图
				ScienceTreeView.Visible = true;
				IsActive = true;
			}

			if (IsUP)
			{
				if (IsActive)
				{
					animation.Play("操作界面下降");
					IsUP = false;
				}
			}
			else
			{
				if (!IsActive)
				{
					animation.Play("操作界面上升");
					IsUP = true;
				}
			}
		}

		public void StartActive()
		{
			if (IsActive)
			{
				IsActive = false;
			}
			else
			{
				IsActive = true;
			}
			if (IsUP)
			{
				if (IsActive)
				{
					animation.Play("操作界面下降");
					IsUP = false;
				}
			}
			else
			{
				if (!IsActive)
				{
					animation.Play("操作界面上升");
					IsUP = true;
				}
			}
		}



		public override void _Process(double delta)
		{
		}


	}
}
