extends Control

# 单例实例
static var Instance = null

# 节点引用
@onready var setting_button: Button = $Button
@onready var setting_menu: Control = $SettingMenu

func _init():
	# 设置单例实例
	Instance = self

func _ready():
	init_view()

func init_view():
	"""初始化视图"""
	# 连接按钮信号
	if setting_button:
		setting_button.pressed.connect(_on_setting_button_pressed)
	
	# 初始隐藏设置菜单
	if setting_menu:
		setting_menu.hide()
	
	print("MapOpView initialized")

func _on_setting_button_pressed():
	"""设置按钮点击事件"""
	if setting_menu and setting_menu.visible:
		close_setting_menu()
	else:
		open_setting_menu()

func open_setting_menu():
	"""打开设置菜单"""
	# 暂停场景
	get_tree().paused = true
	
	# 显示设置菜单
	if setting_menu:
		setting_menu.show()
	
	# 可选：更改按钮文本
	if setting_button:
		setting_button.text = "关闭设置"

func close_setting_menu():
	"""关闭设置菜单"""
	# 恢复场景
	get_tree().paused = false
	
	# 隐藏设置菜单
	if setting_menu:
		setting_menu.hide()
	
	# 可选：恢复按钮文本
	if setting_button:
		setting_button.text = "设置"

# 提供公共方法供其他脚本调用
func show_settings():
	open_setting_menu()

func hide_settings():
	close_setting_menu()

func is_settings_open() -> bool:
	return setting_menu and setting_menu.visible
