extends Button


func  _on_pressed() -> void:
	print ("打开设置")
	get_tree().change_scene_to_file("res://关卡场景/设置界面.tscn")
