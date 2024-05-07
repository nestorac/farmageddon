class_name BaseUnit

extends CharacterBody3D

@onready var decorative_tray = $DecorativeTray
@onready var movement_gizmo = $MovementGizmo

@onready var max_movement = 20.0
var current_movement = 0.0
var movement_left = 20.0

@onready var gizmo_end = $MovementGizmo/GizmoEnd

@export var unit_type = "Infantry"
@export var unit_id:int = 0

var mouse_target = Vector3.ZERO
var movement_target = Vector3.ZERO
var tray_material

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

var unit_state = MOVEMENT_SELECTED


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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	match unit_state:
		MOVEMENT_SELECTED:
			pass
		MOVEMENT_SELECTED:
			pass
		IN_MOVEMENT:
			move_to(movement_target)

func _physics_process(_delta):
	match unit_state:			
		MOVEMENT_SELECTED:
			$DEBUGLabel3D.text = "MOVEMENT_SELECTED"
			#print ("movement_left: ", movement_left)
			tray_material = decorative_tray.get_active_material(0)
			movement_gizmo.show()
			
			var distance_from_mouse = mouse_target.distance_to(position)
			current_movement = min(distance_from_mouse, max_movement)
			
			if movement_left < 0:
				movement_left = 0
			
			movement_gizmo.scale.z = min(distance_from_mouse, movement_left)
			tray_material.albedo_color = Color.BLUE
			movement_gizmo.look_at(mouse_target, Vector3.UP)
			movement_gizmo.rotation_degrees.x = 0
			
		MOVEMENT_NOT_SELECTED:
			$DEBUGLabel3D.text = "MOVEMENT_NOT_SELECTED"
			tray_material = decorative_tray.get_active_material(0)
			movement_gizmo.hide()
			tray_material.albedo_color = Color.WHITE
		
		IN_MOVEMENT:
			$DEBUGLabel3D.text = "IN_MOVEMENT"
			move_to (movement_target)
			movement_gizmo.hide()
			

func move_to(target):
	var direction = (target - global_position).normalized()
	
	if direction:
		velocity.x = direction.x * mov_spd
		velocity.z = direction.z * mov_spd
	move_and_slide()
