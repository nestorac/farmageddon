extends Panel
class_name Action

@export var action_name:String = "None"
@export var action_icon:Texture2D
@export var action_type:String = "movement" # movement, charge, spell, distance
@export var unit_id:int = 0
@export var movement_target:Vector3 = Vector3.ZERO

var is_selected: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$DebugLabel.text = action_name
	if action_icon:
		$TextureRect.texture = action_icon
	else:
		print ("Action icon is not valid.")
	pass # Replace with function body.


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("l_click"):
		is_selected = not is_selected
		if is_selected:
			$TextureRect.self_modulate = Color.RED
		else:
			$TextureRect.self_modulate = Color.WHITE
		print ("clicked")
