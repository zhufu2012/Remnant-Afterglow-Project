using Godot;
using System.Linq;
namespace Remnant_Afterglow
{
	[GlobalClass, Tool]
	public partial class CarouselContainer : Node2D
	{
		/// <summary>
		/// 视图宽度
		/// </summary>
		[Export] public float ViewportWidth { get; set; } = 1024f;

		/// <summary>
		/// 基础布局参数
		/// </summary>
		[Export] public float Spacing { get; set; } = 20f;  // 每个菜单项之间的水平间距（像素）

		/// <summary>
		/// 环绕模式参数
		/// </summary>
		[Export] public bool WraparoundEnabled { get; set; } = false;  // 是否启用圆形环绕布局
		[Export] public float WraparoundRadius { get; set; } = 300f;  // 圆形布局的半径（像素）
		[Export] public float WraparoundHeight { get; set; } = 50f;   // 圆形布局的垂直高度（像素）

		/// <summary>
		/// 视觉效果参数
		/// </summary>
		[Export(PropertyHint.Range, "0.0,1.0")]
		public float OpacityStrength { get; set; } = 0.35f;  // 非选中项的透明度衰减程度

		[Export(PropertyHint.Range, "0.0,1.0")]
		public float ScaleStrength { get; set; } = 0.25f;    // 非选中项的缩放衰减程度

		[Export(PropertyHint.Range, "0.01,0.99,0.01")]
		public float ScaleMin { get; set; } = 0.1f;   // 最小缩放比例限制

		/// <summary>
		/// 行为控制参数
		/// </summary>
		[Export] public float SmoothingSpeed { get; set; } = 6.5f;      // 动画过渡的平滑速度（值越大越快）
		[Export] public int SelectedIndex { get; set; } = 0;           // 当前选中项的索引（从0开始）
		[Export] public bool FollowButtonFocus { get; set; } = false; // 是否自动选中获得焦点的按钮

		/// <summary>
		/// 节点引用
		/// </summary>
		[Export] public Control PositionOffsetNode { get; set; } = null;  // 包含所有菜单项的容器节点


		/// <summary>
		/// 左按钮
		/// </summary>
		[Export] public Button button_left { get; set; } = null;  // 包含所有菜单项的容器节点


		/// <summary>
		/// 右按钮
		/// </summary>
		[Export] public Button button_right { get; set; } = null;  // 包含所有菜单项的容器节点
		/// <summary>
		/// 弹窗
		/// </summary>
		[Export] public Popup Popup { get; set; } = null;

		public override void _Ready()
		{
			var allArchivals = ConfigCache.GetAllArchival();
			if (allArchivals == null || !allArchivals.Any())
			{
				GD.PrintErr("错误：档案数据为空，请检查 cfg_Archival 配置文件");
				// 创建空的占位符或显示错误信息
				Label errorLabel = new Label();
				errorLabel.Text = "暂无档案数据";
				errorLabel.HorizontalAlignment = HorizontalAlignment.Center;
				errorLabel.VerticalAlignment = VerticalAlignment.Center;
				AddChild(errorLabel);
				return; // 提前返回，避免后续代码执行
				}

Archival FirstArchival = allArchivals.First();
			foreach (int itemId in FirstArchival.ItemIdList)
			{
				ArchivalItem item = ConfigCache.GetArchivalItem(itemId);
				Button button = CreateArchivalItem(item);

				PositionOffsetNode.AddChild(button);
			}
			button_left.ButtonDown += Button_left_ButtonDown;
			button_right.ButtonDown += Button_right_ButtonDown;
			Button closeItemView = Popup.GetNode<Button>("Button");
			closeItemView.ButtonDown += () =>
			{
				Popup.Visible = false;
			};
		}


		public Button CreateArchivalItem(ArchivalItem item)
		{
			Button button = (Button)GD.Load<PackedScene>("res://src/core/ui/view/database_view/scene/ArchivalItem.tscn").Instantiate(); ;
			TextureRect texture = button.GetNode<TextureRect>("TextureRect");
			LineEdit line = button.GetNode<LineEdit>("LineEdit");
			texture.Texture = item.Image;
			line.Text = item.Name;
			button.ButtonDown += () => //点击子项
			{
				Control itemView = Popup.GetNode<Control>("ArcjovalItemView");
				TextureRect texture2 = itemView.GetNode<TextureRect>("图片区/TextureRect");
				TextEdit line2 = itemView.GetNode<TextEdit>("NinePatchRect3/TextEdit");
				texture2.Texture = item.Image;
				line2.Text = item.Content;
				Popup.Visible = true;
			};

			return button;
		}


		private void Button_left_ButtonDown()
		{
			if (SelectedIndex > 0)
			{
				SelectedIndex--;
			}
		}

		private void Button_right_ButtonDown()
		{
			if (SelectedIndex < PositionOffsetNode.GetChildCount() - 1)
			{
				SelectedIndex++;
			}
		}

		public override void _Process(double delta)
		{
			// 安全检查：如果容器节点无效或没有子项则直接返回
			if (PositionOffsetNode == null || PositionOffsetNode.GetChildCount() == 0)
			{
				return;
			}

			// 确保选中索引在有效范围内
			SelectedIndex = Mathf.Clamp(SelectedIndex, 0, PositionOffsetNode.GetChildCount() - 1);

			Node focusedItem = null;  // 用于跟踪获得焦点的项

			// 遍历所有子项并更新它们的位置和视觉效果
			foreach (Node child in PositionOffsetNode.GetChildren())
			{
				if (child is Control i)
				{
					// 环绕模式下的位置计算（保持不变）
					if (WraparoundEnabled)
					{
						// 计算角度范围（确保均匀分布）
						float maxIndexRange = Mathf.Max(1, (PositionOffsetNode.GetChildCount() - 1) / 2.0f);
						// 计算当前项相对于选中项的角度（-PI到PI之间）
						float angle = Mathf.Clamp((i.GetIndex() - SelectedIndex) / maxIndexRange, -1.0f, 1.0f) * Mathf.Pi;
						// 计算圆形坐标
						float x = Mathf.Sin(angle) * WraparoundRadius;
						float y = Mathf.Cos(angle) * WraparoundHeight;
						// 计算目标位置（调整锚点到中心）
						Vector2 targetPos = new Vector2(x, y - WraparoundHeight) - i.Size / 2.0f;
						// 平滑过渡到目标位置
						i.Position = i.Position.Lerp(targetPos, SmoothingSpeed * (float)delta);
					}
					else
					{
						// 计算所有子项的总宽度（包括间距）
						float totalWidth = 0.0f;
						foreach (Node node in PositionOffsetNode.GetChildren())
						{
							if (node is Control childControl)
							{
								totalWidth += childControl.Size.X + Spacing;
							}
						}
						totalWidth -= Spacing;  // 最后一个项不需要间距

						// 计算当前项的目标位置（基于中心点布局）
						float positionX = (totalWidth * -0.5f);  // 从左侧开始
						for (int j = 0; j < i.GetIndex(); j++)
						{
							if (PositionOffsetNode.GetChild(j) is Control jControl)
							{
								positionX += jControl.Size.X + Spacing;
							}
						}

						// 设置项的位置（垂直居中）
						i.Position = new Vector2(positionX, -i.Size.Y / 2.0f);
					}

					// 设置旋转和缩放的中心点为项的中心
					i.PivotOffset = i.Size / 2.0f;

					// 计算缩放比例（选中项为1.0，其他项按距离衰减）
					float targetScale = 1 - (ScaleStrength * Mathf.Abs(i.GetIndex() - SelectedIndex));
					targetScale = Mathf.Clamp(targetScale, ScaleMin, 1.0f);  // 确保不小于最小比例
					i.Scale = i.Scale.Lerp(Vector2.One * targetScale, SmoothingSpeed * (float)delta);

					// 计算透明度（选中项为1.0，其他项按距离衰减）
					float targetOpacity = 1.5f - (OpacityStrength * Mathf.Abs(i.GetIndex() - SelectedIndex));
					targetOpacity = Mathf.Clamp(targetOpacity, 0.0f, 1.0f);  // 确保在0-1范围内
					i.Modulate = new Color(i.Modulate, Mathf.Lerp(i.Modulate.A, targetOpacity, SmoothingSpeed * (float)delta));

					// 设置渲染层级（选中项在最上层）
					if (i.GetIndex() == SelectedIndex)
					{
						i.ZIndex = 1;
					}
					else
					{
						i.ZIndex = -Mathf.Abs(i.GetIndex() - SelectedIndex);  // 其他项按距离设置层级
					}

					// 如果启用焦点跟随，检查当前项是否获得焦点
					if (FollowButtonFocus && i.HasFocus())
					{
						focusedItem = i;
					}
				}
			}

			// 如果有项获得焦点，更新选中索引
			if (focusedItem != null)
			{
				SelectedIndex = focusedItem.GetIndex();
			}

			// 容器位置平滑（用于居中效果）
			if (WraparoundEnabled)
			{
				PositionOffsetNode.Position = new Vector2(
					Mathf.Lerp(PositionOffsetNode.Position.X, 0.0f, SmoothingSpeed * (float)delta),
					PositionOffsetNode.Position.Y
				);
			}
			else
			{
				// 计算容器偏移使选中项居中
				if (PositionOffsetNode.GetChildCount() > 0)
				{
					var selectedItem = PositionOffsetNode.GetChild(SelectedIndex) as Control;
					if (selectedItem != null)
					{
						// 计算选中项中心在容器中的位置
						float itemCenter = selectedItem.Position.X + (selectedItem.Size.X / 2);

						// 计算需要的容器偏移量（使选中项位于区域中心）
						float targetOffset = (ViewportWidth / 2) - itemCenter;

						// 平滑过渡到目标偏移
						PositionOffsetNode.Position = new Vector2(
							Mathf.Lerp(
								PositionOffsetNode.Position.X,
								targetOffset,
								SmoothingSpeed * (float)delta
							),
							PositionOffsetNode.Position.Y
						);
					}
				}
			}
		}
	}
}
