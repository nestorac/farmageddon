extends Camera3D

@onready var scene_manager = $".."
@onready var destination_icon = $"../DestinationIcon"
@export var unit_mesh_ghost:MeshInstance3D

var distance_from_camera = 100
var is_unit_selected = false
var is_unit_positioned = false
var picked_unit_type:String = "None"

signal unit_placed
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _input(event):
		
	if event is InputEventMouseMotion:
		var from = project_ray_origin((event.position))
		var to = from + project_ray_normal(event.position) * distance_from_camera
		var space_state = get_world_3d().get_direct_space_state()
		var query = PhysicsRayQueryParameters3D.create(from,to)
		var hit = space_state.intersect_ray(query)
		
		if not is_unit_selected and scene_manager.turn_state == scene_manager.DEPLOYMENT:
			return
			
		if scene_manager.turn_state == scene_manager.DEPLOYMENT:
			if hit.size() != 0:
				# collider will be the node you hit
				unit_mesh_ghost.position = Vector3( hit.position.x, 0.5, hit.position.z )
				
			
	if event.is_action_released("l_click") and is_unit_selected:
		is_unit_selected = false
		unit_mesh_ghost.hide()
		emit_signal("unit_placed", picked_unit_type, unit_mesh_ghost.global_position)

func set_unit_mesh_ghost(unit_type:String) -> void:
	picked_unit_type = unit_type
	unit_mesh_ghost = get_node("../UnitsGhostContainer/" + unit_type + "Ghost")
