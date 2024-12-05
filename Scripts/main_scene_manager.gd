extends Node3D

@onready var camera = $MainCamera

@export var select_units_ui:Control
@export var cash_label:Label
@export var game_state_ui:Control
@export var units_container_p1:UnitsContainer
@export var units_container_p2:UnitsContainer
@export var canvas_ui:CanvasLayer
@export var action_bar:ActionBar


@export var players_in_match:Array[PLAYERS]

enum {DEPLOYMENT, PLAY_CARDS, COMMANDS, RESOLUTION}
enum PLAYERS {PLAYER_1, PLAYER_2, AI} # Later, AI_1 and AI_2, to play AI vs AI

var unit_count:int = 0
var player_cash:int = 500
var turn_state = int(DEPLOYMENT)

@onready var current_player = players_in_match[0]

var loaded_base_unit = load ("res://Scenes/base_unit.tscn")
var deployment_done = false # Flag to ensure deployment only happens once.

var actions:Dictionary = {
	"movements":[],
	"charges":[],
	"distance_attacks":[],
	"spells":[],
}

# Called when the node enters the scene tree for the first time.
func _ready():
	camera.connect("unit_placed", _on_unit_placed)
	game_state_ui.connect("next_turn_state", _on_next_turn_state)
	
	cash_label.text = str(player_cash) + "€"
	match_turn_state()
	game_state_ui.update_turn_label(current_player)


func match_turn_state() -> void:
	for child in canvas_ui.get_children():
		child.hide()
		
	match turn_state:
		DEPLOYMENT:
			if deployment_done == true:
				_on_next_turn_state()
				return
			game_state_ui.turn_state_label.text = "Deployment"
			select_units_ui.show()
			game_state_ui.show()
			deployment_done = true
		PLAY_CARDS:
			game_state_ui.turn_state_label.text = "Play cards"
			game_state_ui.show()
		COMMANDS:
			game_state_ui.turn_state_label.text = "Commands"
			action_bar.show()
			game_state_ui.show()
			units_container_p1.reset_units_gui()
			units_container_p2.reset_units_gui()
		RESOLUTION:
			game_state_ui.turn_state_label.text = "Resolution"
			game_state_ui.show()


func _on_next_turn_state():
	turn_state += 1
	if turn_state > int(RESOLUTION):
		change_player_turn()
		turn_state = int(DEPLOYMENT)
		game_state_ui.update_turn_label(current_player)
	match_turn_state()


func change_player_turn() -> void:
	var next_index = players_in_match.find(current_player) + 1
	if next_index >= players_in_match.size():
		next_index = 0
	current_player = players_in_match[next_index]


func _on_unit_placed(unit_type_holding:String, ghost_position:Vector3):
	camera.is_unit_positioned = true
	for child_button in select_units_ui.deploy_buttons_container.get_children():
		child_button.button_pressed = false
	print (unit_type_holding)
	var base_unit_instanced = loaded_base_unit.instantiate()
	base_unit_instanced.unit_type = unit_type_holding
	base_unit_instanced.unit_id = unit_count
	unit_count += 1
	units_container_p1.add_child(base_unit_instanced)
	base_unit_instanced.global_position = ghost_position
	
	substract_money(base_unit_instanced.unit_price)

func add_money(amount:int) -> void:
	player_cash += amount
	cash_label.text = str(player_cash) + "€"
	check_units_buttons_disabled()
	
func substract_money(amount:int) -> void:
	player_cash -= amount
	cash_label.text = str(player_cash) + "€"
	check_units_buttons_disabled()
	
func check_units_buttons_disabled() -> void:
	var buttons = get_tree().get_nodes_in_group("deploy_unit_button")
	for button in buttons:
		if button.unit_price > player_cash:
			button.disabled = true


func _on_main_camera_click_on_walkable_for_unit(action_name, type, unit_id, mov_target):
	action_bar.add_action(action_name, type, unit_id, mov_target)

func _on_action_finished() -> void:
	action_bar.clear_first_action()
	action_bar.do_first_action()
#	print ("ACTION FINISHED!")
