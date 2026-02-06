extends Control

# 关闭信号
signal close_menu

# 设置菜单中的节点引用
@onready var close_button: Button = $CloseButton  # 假设有关闭按钮
@onready var volume_slider: HSlider = $VolumeSlider  # 音量滑块示例
@onready var fullscreen_check: CheckButton = $FullscreenCheck  # 全屏复选框示例

func _ready():
	# 连接关闭按钮信号
	if close_button:
		close_button.pressed.connect(_on_close_button_pressed)
	
	# 初始化设置值
	load_settings()

func _on_close_button_pressed():
	"""关闭按钮点击事件"""
	close_menu.emit()

func load_settings():
	"""加载设置"""
	# 从配置加载设置值
	if volume_slider:
		volume_slider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	
	if fullscreen_check:
		fullscreen_check.button_pressed = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN

func _on_volume_slider_value_changed(value: float):
	"""音量滑块值改变"""
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)

func _on_fullscreen_check_toggled(button_pressed: bool):
	"""全屏切换"""
	if button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_设置图标_button_down() -> void:
	pass # Replace with function body.
