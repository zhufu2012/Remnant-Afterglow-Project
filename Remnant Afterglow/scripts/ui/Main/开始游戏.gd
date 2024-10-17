extends Button


func  _on_pressed() -> void:
	print ("开始游戏")
	get_tree().change_scene_to_file("res://关卡场景/关卡库/游戏关卡1场景.tscn")
