class_name BaseUnit

extends CharacterBody3D

signal action_finished

@export var unit_type = "Infantry"
@export var unit_id:int = 0
@export var unit_owner:String = "Player_1"
@export var max_movement = 20.0

var current_movement = 0.0
var movement_left = 20.0
var mouse_ray_hit = Vector3.ZERO
var movement_target = Vector3.ZERO
var is_selected:bool = false

# Stats
var strength:int = 0 # 1..100
var dex:int = 0 # 1..100
var intl = 0 # 1..100
var def = 0 # 1..100
var mov_spd = 0 # 0..10
var unit_price:int = 0

# Status ailments
var fear = 0 # 1..inf
var fatigue = 0 # 1..inf
var stunt = false # stunned or not, boolean
var poison = false # boolean

# We can add different variables for different stats

@onready var decorative_tray_not_selected:MeshInstance3D = $DecorativeTray_NotSelected
@onready var decorative_tray_selected:MeshInstance3D = $DecorativeTray_Selected
@onready var movement_gizmo = $MovementGizmo
@onready var main_camera:Node = get_tree().get_first_node_in_group("main_camera")
@onready var main_scene:Node = get_tree().get_first_node_in_group("main_scene_manager")
@onready var navigation_agent:NavigationAgent3D = $NavigationAgent3D
@onready var gizmo_end = $MovementGizmo/GizmoEnd
@onready var stamina_bar: ProgressBar = $StaminaBar


enum STATES {  MOVEMENT_SELECTED, ACTION_QUEUED,
		MOVEMENT_NOT_SELECTED, IN_MOVEMENT }

var unit_state = STATES.MOVEMENT_NOT_SELECTED


# Called when the node enters the scene tree for the first time.
func _ready():
	initialize_unit_by_type()
	movement_left = max_movement
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	
	action_finished.connect(Callable(main_scene, "_on_action_finished"))

	stamina_bar.max_value = max_movement
	stamina_bar.value = movement_left

func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)


func initialize_unit_by_type():
	var unit_types_dict = GlobalGameFunctions.parse_json_to_dict("res://Data/en/unit_types.json")
#	print(unit_types_dict[unit_type]["unit_price"])
	
	strength = int((unit_types_dict[unit_type]["strength"])) # 1..100
	dex = int((unit_types_dict[unit_type]["dex"])) # 1..100
	intl = int((unit_types_dict[unit_type]["intl"])) # 1..100
	def = int((unit_types_dict[unit_type]["def"])) # 1..100
	mov_spd = int((unit_types_dict[unit_type]["mov_spd"])) # 0..10
	unit_price = int(unit_types_dict[unit_type]["unit_price"])
	
	$DEBUGLabel3D.text = unit_type

func _select_unit() -> void:
	is_selected = true
	decorative_tray_not_selected.hide()
	decorative_tray_selected.show()
	movement_gizmo.show()


func _deselect_unit() -> void:
	is_selected = false
	decorative_tray_selected.hide()
	decorative_tray_not_selected.show()
	movement_gizmo.hide()
	

func switch_unit_state(new_state:STATES) -> void:
	unit_state = new_state
	match unit_state:
		STATES.MOVEMENT_SELECTED:
			_select_unit()
			$DebugState.text = "Selected for movement."
			pass
		STATES.ACTION_QUEUED:
			$DebugState.text = "Action queued."
			_deselect_unit()
		STATES.MOVEMENT_NOT_SELECTED:
			$DebugState.text = "NOT selected for movement."
			pass
		STATES.IN_MOVEMENT:
			$DebugState.text = "In movement."
	#TODO: Add signal if necessary to alert other nodes when the unit changes its state.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#print (is_selected)
	match unit_state:
		STATES.MOVEMENT_SELECTED:
			pass
		STATES.MOVEMENT_NOT_SELECTED:
			pass
		STATES.IN_MOVEMENT:
			var distance_to_target = global_position.distance_to(movement_target)
			movement_left = distance_to_target
			stamina_bar.value = movement_left
			print (distance_to_target)
			nav_movement()
			#move_to(movement_target)


func start_action_move(target:Vector3):
	movement_target = target
	set_movement_target(target)
	switch_unit_state(BaseUnit.STATES.IN_MOVEMENT)


func nav_movement() -> void:
	# Do not query when the map has never synchronized and is empty.
	if NavigationServer3D.map_get_iteration_id(navigation_agent.get_navigation_map()) == 0:
		return
	if navigation_agent.is_navigation_finished():
		emit_signal("action_finished")
		unit_state = STATES.MOVEMENT_NOT_SELECTED
		return

	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	var new_velocity: Vector3 = global_position.direction_to(next_path_position) * mov_spd
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)


func move_to(target:Vector3):
	var direction = (target - global_position).normalized()
	
	if direction:
		velocity.x = direction.x * mov_spd
		velocity.z = direction.z * mov_spd
	move_and_slide()
	
	
func _on_velocity_computed(safe_velocity: Vector3):
	velocity = safe_velocity
	move_and_slide()
