extends Panel
class_name Action

@export var action_name:String = "None"
@export var action_icon:Texture2D
@export var action_type:String = "movement" # movement, charge, spell, distance
@export var unit_id:int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$DebugLabel.text = action_name
	if action_icon:
		$TextureRect.texture = action_icon
	else:
		print ("Action icon is not valid.")
	pass # Replace with function body.

