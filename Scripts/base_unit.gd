class_name BaseUnit

extends CharacterBody3D

@onready var decorative_tray = $DecorativeTray
@onready var movement_gizmo = $MovementGizmo
@onready var main_camera:Node = get_tree().get_first_node_in_group("main_camera")

@onready var max_movement = 20.0
var current_movement = 0.0
var movement_left = 20.0

@onready var gizmo_end = $MovementGizmo/GizmoEnd

@export var unit_type = "Infantry"
@export var unit_id:int = 0

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


enum {  MOVEMENT_SELECTED,
		MOVEMENT_NOT_SELECTED, IN_MOVEMENT  }

var unit_state = MOVEMENT_NOT_SELECTED


# Called when the node enters the scene tree for the first time.
func _ready():
	initialize_unit_by_type()
	movement_left = max_movement


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

func select_this_unit() -> void:
	var tray_material = decorative_tray.get_active_material(0)
	is_selected = true
	tray_material.albedo_color = Color.BLUE
	movement_gizmo.show_gizmo()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#print (is_selected)
	match unit_state:
		MOVEMENT_SELECTED:
			pass
		MOVEMENT_SELECTED:
			pass
		IN_MOVEMENT:
			move_to(movement_target)


func start_action_move(target:Vector3):
	movement_target = target
	unit_state = IN_MOVEMENT


func move_to(target:Vector3):
	var direction = (target - global_position).normalized()
	
	if direction:
		velocity.x = direction.x * mov_spd
		velocity.z = direction.z * mov_spd
	move_and_slide()
