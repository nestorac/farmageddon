extends Panel
class_name Action

@export var action_name:String = "None"


@onready var debug_label = $DebugLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	debug_label.text = action_name
	pass # Replace with function body.

