class_name BaseUnit

extends CharacterBody3D

@onready var decorative_tray = $DecorativeTray
@onready var movement_gizmo = $MovementGizmo

@onready var max_movement = 20.0
var current_movement = 0.0
var movement_left = 20.0

@onready var gizmo_end = $MovementGizmo/GizmoEnd

@export var unit_type = "Infantry"

var mouse_target = Vector3.ZERO
var movement_target = Vector3.ZERO
var tray_material

# Stats
var str:int = 0 # 1..100
var dex:int = 0 # 1..100
var intl = 0 # 1..100
var def = 0 # 1..100
var mov_spd = 5 # 1..inf

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
	match unit_type:
		"Infantry":
			str = 0 # 1..100
			dex = 0 # 1..100
			intl = 0 # 1..100
			def = 0 # 1..100
			mov_spd = 5 # 1..inf
		"Chivalry":
			str = 0 # 1..100
			dex = 0 # 1..100
			intl = 0 # 1..100
			def = 0 # 1..100
			mov_spd = 5 # 1..inf
		"Archers":
			str = 0 # 1..100
			dex = 0 # 1..100
			intl = 0 # 1..100
			def = 0 # 1..100
			mov_spd = 5 # 1..inf
		"Wizards":
			str = 0 # 1..100
			dex = 0 # 1..100
			intl = 0 # 1..100
			def = 0 # 1..100
			mov_spd = 5 # 1..inf

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _physics_process(_delta):
	match unit_state:			
		MOVEMENT_SELECTED:
			$DEBUGLabel3D.text = "MOVEMENT_SELECTED"
			print ("movement_left: ", movement_left)
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
