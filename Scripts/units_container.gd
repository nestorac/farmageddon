class_name UnitsContainer
extends Node3D

func reset_units_gui() -> void:
	for child in get_children():
		if not child.is_in_group("Units"):
			return
		child.restart_stamina_bar_gui()
