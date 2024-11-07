extends Panel

func _input(event: InputEvent) -> void:
	if not visible:
		return
		
	if event is InputEventMouseMotion:
		global_position = event.global_position
