extends TextureButton

@export var unit_type = "Infantry"
@onready var price_label:Label = $PriceLabel
@export var camera:Camera3D 

@export var unit_price:int = 10


func _ready() -> void:
	price_label .text = "$" + str(unit_price)


func _on_toggled(toggled_on):
	if toggled_on == true:
		camera.set_unit_mesh_ghost(unit_type)
		camera.unit_mesh_ghost.show()
		camera.is_unit_selected = true
		camera.is_unit_positioned = false
	else:
		if camera.is_unit_positioned:
			return
		camera.unit_mesh_ghost.hide()
		camera.is_unit_selected = false
