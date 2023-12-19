extends Node3D

@onready var camera = $Camera3D
@onready var unit_1 = $"Select Unit UI/Unit_1"

# Called when the node enters the scene tree for the first time.
func _ready():
	camera.connect("unit_placed", _on_unit_placed)


func _process(delta):
	pass


func _on_unit_1_toggled(button_pressed):
	if button_pressed == true:
		camera.test_unit.show()
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
