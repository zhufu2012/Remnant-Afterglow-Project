extends Node

var aspect_ratio: float

var temp_size:Vector2i
func _process(delta:float)->void:
	if temp_size !=get_window().size:
		aspect_ratio =float(get_window().size.x) /float(get_window().size.y)
		if aspect_ratio<1:
			get_window().size.x=get_window().size.y
		elif aspect_ratio >16/9:
			get_window().size.y=get_window().size.x* 9/16
		temp_size =get_window().size
		print(aspect_ratio)
