extends Control

signal next_turn_state

@onready var turn_state_label = $TurnStateLabel
@onready var next_state_button = $NextStateButton



func _on_next_state_button_button_up():
	emit_signal("next_turn_state")
