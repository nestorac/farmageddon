extends CharacterBody3D

@onready var decorative_tray = $DecorativeTray
@onready var movement_gizmo = $MovementGizmo

@onready var max_movement = 10.0

var mouse_target = Vector3.ZERO
var movement_target = Vector3.ZERO
var tray_material

const SPEED = 10.0

enum {  DEPLOY_SELECTED, DEPLOY_NOT_SELECTED, MOVEMENT_SELECTED,
		MOVEMENT_NOT_SELECTED, IN_MOVEMENT  }

var unit_state = DEPLOY_NOT_SELECTED


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _physics_process(_delta):
	match unit_state:
		DEPLOY_SELECTED:
			tray_material = decorative_tray.get_active_material(0)
			tray_material.albedo_color = Color.GREEN
			
		DEPLOY_NOT_SELECTED:
			tray_material = decorative_tray.get_active_material(0)
			tray_material.albedo_color = Color.WHITE
			
		MOVEMENT_SELECTED:
			tray_material = decorative_tray.get_active_material(0)
			movement_gizmo.show()
			
			var distance_from_mouse = min(mouse_target.distance_to(position), 10.0)
			movement_gizmo.scale.z = distance_from_mouse
			
			#movement_gizmo.scale.z = max_movement
			tray_material.albedo_color = Color.BLUE
			movement_gizmo.look_at(mouse_target, Vector3.UP)
			
		MOVEMENT_NOT_SELECTED:
			tray_material = decorative_tray.get_active_material(0)
			movement_gizmo.hide()
			tray_material.albedo_color = Color.WHITE
		
		IN_MOVEMENT:
			#print ("troop moving.")
			#print (movement_target)
			move_to (movement_target)
			

func move_to(target):
	var direction = (transform.basis * target).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	move_and_slide()
