extends CharacterBody3D

@onready var decorative_tray = $DecorativeTray
@onready var movement_gizmo = $MovementGizmo

var tray_material
var movement_target = Vector3.ZERO

enum {DEPLOY_SELECTED, DEPLOY_NOT_SELECTED, MOVEMENT_SELECTED, MOVEMENT_NOT_SELECTED}

var unit_state = DEPLOY_NOT_SELECTED


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
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
			tray_material.albedo_color = Color.BLUE
			movement_gizmo.look_at(movement_target, Vector3.UP)
		MOVEMENT_NOT_SELECTED:
			tray_material = decorative_tray.get_active_material(0)
			movement_gizmo.hide()
			tray_material.albedo_color = Color.WHITE
