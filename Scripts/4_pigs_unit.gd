extends CharacterBody3D

@onready var decorative_tray = $DecorativeTray
@onready var movement_gizmo = $MovementGizmo

@onready var max_movement = 20.0
var current_movement = 0.0
var movement_left = 20.0

@onready var gizmo_end = $MovementGizmo/GizmoEnd

var mouse_target = Vector3.ZERO
var movement_target = Vector3.ZERO
var tray_material

const SPEED = 10.0

enum {  DEPLOY_SELECTED, DEPLOY_NOT_SELECTED, MOVEMENT_SELECTED,
		MOVEMENT_NOT_SELECTED, IN_MOVEMENT  }

var unit_state = DEPLOY_NOT_SELECTED


# Called when the node enters the scene tree for the first time.
func _ready():
	movement_left = max_movement


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _physics_process(_delta):
	match unit_state:
		DEPLOY_SELECTED:
			tray_material = decorative_tray.get_active_material(0)
			tray_material.albedo_color = Color.GREEN
			$DEBUGLabel3D.text = "DEPLOY_SELECTED"
			
		DEPLOY_NOT_SELECTED:
			tray_material = decorative_tray.get_active_material(0)
			tray_material.albedo_color = Color.WHITE
			$DEBUGLabel3D.text = "DEPLOY_NOT_SELECTED"
			
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
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	move_and_slide()
