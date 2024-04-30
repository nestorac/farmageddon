extends Node3D

@onready var camera = $MainCamera

@export var select_units_ui:Control
@export var cash_label:Label
@export var game_state_ui:Control
@export var units_node_container:Node3D
@export var canvas_ui:CanvasLayer
@export var action_bar:Control

enum {DEPLOYMENT, COMMANDS, RESOLUTION}

var player_cash:int = 100
var turn_state = int(DEPLOYMENT)
var loaded_base_unit = load ("res://Scenes/base_unit.tscn")

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


func match_turn_state() -> void:
	for child in canvas_ui.get_children():
		child.hide()
		
	match turn_state:
		DEPLOYMENT:
			game_state_ui.turn_state_label.text = "Deployment"
			select_units_ui.show()
			game_state_ui.show()
		COMMANDS:
			game_state_ui.turn_state_label.text = "Commands"
			action_bar.show()
			game_state_ui.show()
		RESOLUTION:
			game_state_ui.turn_state_label.text = "Resolution"
			game_state_ui.show()


func _on_next_turn_state():
	turn_state += 1
	if turn_state > int(RESOLUTION):
		turn_state = int(DEPLOYMENT)
	match_turn_state()


func _on_unit_placed(unit_type_holding:String, ghost_position:Vector3):
	camera.is_unit_positioned = true
	for child_button in select_units_ui.deploy_buttons_container.get_children():
		child_button.button_pressed = false
	print (unit_type_holding)
	var base_unit_instanced = loaded_base_unit.instantiate()
	base_unit_instanced.unit_type = unit_type_holding
	units_node_container.add_child(base_unit_instanced)
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
