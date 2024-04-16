extends Camera3D

@onready var scene_manager = $".."
@onready var ray = $RayCast3D
@onready var unit_mesh_ghost = $"../UnitsGhostContainer/PlaceholderUnitGhost"
@onready var destination_icon = $"../DestinationIcon"

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
				unit_mesh_ghost.position = Vector3( hit.position.x, 1, hit.position.z )
				
		elif scene_manager.turn_state == scene_manager.RESOLUTION:
			unit_mesh_ghost.mouse_target = hit.position
			#print ("Mouse movement.")
	if event.is_action_pressed("l_click"):
		if scene_manager.turn_state == scene_manager.DEPLOYMENT:
			print("Click on deployment.")
		elif scene_manager.turn_state == scene_manager.COMMANDS:
			var from = project_ray_origin((event.position))
			var to = from + project_ray_normal(event.position) * distance_from_camera
			
			var space_state = get_world_3d().get_direct_space_state()
			
			var query = PhysicsRayQueryParameters3D.create(from,to)
			
			var hit = space_state.intersect_ray(query)
			
			if hit.size() != 0:
				print (hit.collider)
				if hit.collider.is_in_group("Units"):
					var unit = hit.collider
					print ("It is indeed in group Units.")
					unit.unit_state = unit.MOVEMENT_SELECTED
				else:
					var units = get_tree().get_nodes_in_group("Units")
					for unit in units:
						unit.unit_state = unit.MOVEMENT_NOT_SELECTED
		elif scene_manager.turn_state == scene_manager.RESOLUTION:
			print("Click on attack.")
	
	if event.is_action_pressed("r_click"):
		if scene_manager.turn_state == scene_manager.COMMANDS:
			if not unit_mesh_ghost.movement_gizmo.visible:
				return
			var from = project_ray_origin((event.position))
			var to = from + project_ray_normal(event.position) * distance_from_camera
			var space_state = get_world_3d().get_direct_space_state()
			var query = PhysicsRayQueryParameters3D.create(from,to)
			var hit = space_state.intersect_ray(query)
			
			unit_mesh_ghost.movement_left -= hit.position.distance_to(unit_mesh_ghost.position)
		
			#print ("Right click in movement!", hit)
			unit_mesh_ghost.unit_state = unit_mesh_ghost.IN_MOVEMENT
			unit_mesh_ghost.movement_target = unit_mesh_ghost.gizmo_end.global_position
			destination_icon.global_position = unit_mesh_ghost.gizmo_end.global_position
			destination_icon.show()
			destination_icon.monitoring = true
			
	if event.is_action_released("l_click") and is_unit_selected:
		is_unit_selected = false
		unit_mesh_ghost.hide()
		emit_signal("unit_placed", picked_unit_type, unit_mesh_ghost.global_position)

func set_unit_mesh_ghost(unit_type:String) -> void:
	picked_unit_type = unit_type
	unit_mesh_ghost = get_node("../UnitsGhostContainer/" + unit_type + "Ghost")
