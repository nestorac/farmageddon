extends Control

signal next_turn_state

@onready var turn_state_label = $TurnStateLabel
@onready var next_state_button = $NextStateButton
@onready var player_turn_label: Label = $PlayerTurnLabel


func update_turn_label(new_turn:int) -> void:
	match new_turn:
		0:
			player_turn_label.text = "TURN: Player 1"
		1:
			player_turn_label.text = "TURN: Player 2"


func _on_next_state_button_button_up():
	emit_signal("next_turn_state")
