extends Node3D

@onready var green_line_mesh:MeshInstance3D = $GreenLineMesh
@onready var gizmo_end:MeshInstance3D = $GizmoEnd
@onready var parent_unit:BaseUnit = $".."

func show_gizmo() -> void:
	show()
	
func _process(delta:float) -> void:
	if not visible:
		return
	var mouse_hit:Dictionary = parent_unit.main_camera.get_update_mouse_ray_hit()
	if mouse_hit.is_empty():
		return
	var mouse_hit_position = mouse_hit.position
	var distance_from_mouse = mouse_hit_position.distance_to(global_position)
	scale.z = min (distance_from_mouse, 10.0)
	look_at (mouse_hit_position, Vector3.UP)
	#print (mouse_hit_position)
