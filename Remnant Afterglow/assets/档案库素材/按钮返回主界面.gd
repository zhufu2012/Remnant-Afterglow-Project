extends Button

const TARGET_SCENE := "res://src/core/ui/MainView.tscn"  # 你的场景路径
var scene = preload(TARGET_SCENE)
func _ready():
	pressed.connect(_on_button_pressed)  # Godot 4 信号连接方式

func _on_button_pressed():

	get_tree().change_scene_to_packed(scene)
