extends Area3D

func _on_body_entered(body):
	if body.is_in_group("Units"):
		body.unit_state = body.MOVEMENT_NOT_SELECTED
		hide()
		monitoring = false
