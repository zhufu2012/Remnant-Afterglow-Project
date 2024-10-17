extends Button


func  _on_pressed() -> void:
	print ("返回主菜单")
	get_tree().change_scene_to_file("res://关卡场景/主界面.tscn")
