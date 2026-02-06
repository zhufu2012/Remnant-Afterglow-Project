using GameLog;
using Godot;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
	/// <summary>
	/// 设置界面
	/// </summary>
	public partial class SettingView : Control
	{
		/// <summary>
		/// 返回按钮,点击返回主菜单
		/// </summary>
		[Export]
		public Button ReturnButton = new Button();

		[Export]
		private TabContainer tabContainer;
		[Export]
		private GridContainer gridContainer;

		public override void _Ready()
		{
			InitView();
		}

		public void InitView()
		{
			ReturnButton.ButtonDown += ReturnView;
			// 创建配置项显示页面
			CreateConfigPage();
		}

		/// <summary>
		/// 创建配置项显示页面
		/// </summary>
		private void CreateConfigPage()
		{
			gridContainer.Name = "默认参数";
			// 获取所有ShopSetting为true的配置项
			List<GlobalConfig> shopConfigs = ConfigCache.GetShopConfigs();
			// 为每个配置项创建UI元素
			foreach (GlobalConfig config in shopConfigs)
			{
				PanelContainer panel = new PanelContainer();
				VBoxContainer configBox = new VBoxContainer();
				configBox.Set("theme_override_constants/separation", 10); // 设置间距

				// 显示配置名称
				Label nameLabel = new Label();
				nameLabel.Size = new Vector2(config.ConfigName.Length * 30, 24);
				nameLabel.Text = $"配置名称: {config.ConfigName}";
				configBox.AddChild(nameLabel);

				// 显示配置ID
				Label idLabel = new Label();
				idLabel.Size = new Vector2(config.Configid.Length * 30, 24);
				idLabel.Text = $"配置ID: {config.Configid}";
				configBox.AddChild(idLabel);

				// 显示和编辑配置值
				HBoxContainer valueBox = new HBoxContainer();
				Label valueLabel = new Label();
				valueLabel.Size = new Vector2(150, 24);
				valueLabel.Text = "当前值: ";
				valueLabel.SizeFlagsHorizontal = Control.SizeFlags.ShrinkCenter;
				valueBox.AddChild(valueLabel);

				if (config.IsModif)
				{
					// 根据配置值类型创建相应的编辑控件
					if (config.ConfigValue is int intValue)
					{
						SpinBox spinBox = new SpinBox();
						spinBox.Value = ConfigCache.GetGlobal_Int(config.Configid); // 使用修改后的值
						spinBox.ValueChanged += (double value) => OnConfigValueChanged(config.Configid, (int)value);
						spinBox.SizeFlagsHorizontal = Control.SizeFlags.ExpandFill;
						valueBox.AddChild(spinBox);
					}
					else if (config.ConfigValue is float floatValue)
					{
						SpinBox spinBox = new SpinBox();
						spinBox.Value = ConfigCache.GetGlobal_Float(config.Configid); // 使用修改后的值
						spinBox.Step = 0.1;
						spinBox.ValueChanged += (double value) => OnConfigValueChanged(config.Configid, (float)value);
						spinBox.SizeFlagsHorizontal = Control.SizeFlags.ExpandFill;
						valueBox.AddChild(spinBox);
					}
					else if (config.ConfigValue is string stringValue)
					{
						LineEdit lineEdit = new LineEdit();
						lineEdit.Text = ConfigCache.GetGlobal_Str(config.Configid); // 使用修改后的值
						lineEdit.TextChanged += (string text) => OnConfigValueChanged(config.Configid, text);
						lineEdit.SizeFlagsHorizontal = Control.SizeFlags.ExpandFill;
						valueBox.AddChild(lineEdit);
					}
				}
				else
				{
					// 只读显示
					Label readOnlyValueLabel = new Label();
					readOnlyValueLabel.Text = GetConfigValueString(config.Configid, config.ConfigValue);
					valueBox.AddChild(readOnlyValueLabel);
				}

				configBox.AddChild(valueBox);
				panel.AddChild(configBox);

				// 添加一些样式
				panel.Set("theme_override_styles/panel", new StyleBoxFlat()
				{
					BgColor = new Color(0.2f, 0.2f, 0.2f, 0.7f),
					BorderWidthLeft = 1,
					BorderWidthRight = 1,
					BorderWidthTop = 1,
					BorderWidthBottom = 1,
					BorderColor = new Color(0.5f, 0.5f, 0.5f)
				});

				gridContainer.AddChild(panel);
			}
		}

		/// <summary>
		/// 获取配置值的字符串表示
		/// </summary>
		/// <param name="configId"></param>
		/// <param name="value"></param>
		/// <returns></returns>
		private string GetConfigValueString(string configId, object value)
		{
			// 检查是否有修改过的值
			object modifiedValue = ConfigPersistenceManager.GetModifiedConfigValue(configId);
			if (modifiedValue != null)
			{
				return modifiedValue.ToString() + " (已修改)";
			}
			return value.ToString();
		}

		/// <summary>
		/// 配置值更改回调
		/// </summary>
		/// <param name="configId"></param>
		/// <param name="newValue"></param>
		private void OnConfigValueChanged(string configId, object newValue)
		{
			// 更新配置值
			ConfigCache.UpdateGlobalConfigValue(configId, newValue);
			GD.Print($"配置 {configId} 的值更改为: {newValue}");
		}

		/// <summary>
		/// 返回上一个界面
		/// </summary>
		public void ReturnView()
		{
			SceneManager.ChangeSceneBackward(this);
		}

		public override void _UnhandledInput(InputEvent @event)
		{
			if (@event.IsActionPressed(KeyConstant.Input_Key_ESC))
			{
				ReturnView();
			}
		}
	}
}
