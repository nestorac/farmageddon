extends Node3D

@onready var camera = $Camera3D
@onready var select_units_ui = $"Select Unit UI"
@onready var unit_1 = $"Select Unit UI/Unit_1"
@onready var turn_state_label = $UI/TurnStateLabel
@onready var ui_node = $UI

enum {DEPLOYMENT, COMMANDS, RESOLUTION}

var turn_state = DEPLOYMENT

# Called when the node enters the scene tree for the first time.
func _ready():
	camera.connect("unit_placed", _on_unit_placed)
	ui_node.connect("next_turn_state", _on_next_turn_state)


func _physics_process(_delta):
	match turn_state:
		DEPLOYMENT:
			turn_state_label.text = "Deployment"
			select_units_ui.show()
		COMMANDS:
			turn_state_label.text = "Commands"
			select_units_ui.hide()
		RESOLUTION:
			turn_state_label.text = "Resolution"


func _process(_delta):
	pass


func _on_next_turn_state():
	turn_state += 1
	if turn_state > RESOLUTION:
		turn_state = DEPLOYMENTtc


func _on_unit_1_toggled(button_pressed):
	if button_pressed == true:
		camera.test_unit.show()
		camera.test_unit.unit_state = camera.test_unit.DEPLOY_SELECTED
		camera.is_unit_selected = true
		camera.is_unit_positioned = false
	else:
		if camera.is_unit_positioned:
			return
		camera.test_unit.hide()
		camera.is_unit_selected = false

func _on_unit_placed():
	camera.is_unit_positioned = true
	unit_1.button_pressed = false
