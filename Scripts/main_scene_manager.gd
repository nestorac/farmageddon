extends Node3D

@onready var camera = $MainCamera
@onready var select_units_ui = $"SelectUnitUI"
@onready var turn_state_label = $UI/TurnStateLabel
@onready var ui_node = $UI
@onready var deploy_buttons_container:VBoxContainer = $"SelectUnitUI/BackgroundWindow/VBoxContainer"
@onready var cash_label:Label = $"SelectUnitUI/CashLabel"

@export var units_node_container:Node3D

enum {DEPLOYMENT, COMMANDS, RESOLUTION}

var player_cash:int = 100
var turn_state = int(DEPLOYMENT)
var loaded_base_unit = load ("res://Scenes/base_unit.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	camera.connect("unit_placed", _on_unit_placed)
	ui_node.connect("next_turn_state", _on_next_turn_state)
	
	cash_label.text = str(player_cash) + "€"


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
	if turn_state > int(RESOLUTION):
		turn_state = int(DEPLOYMENT)
#
#
#func _on_unit_1_toggled(button_pressed):
	#if button_pressed == true:
		#camera.unit_mesh_ghost.show()
		#camera.is_unit_selected = true
		#camera.is_unit_positioned = false
	#else:
		#if camera.is_unit_positioned:
			#return
		#camera.unit_mesh_ghost.hide()
		#camera.is_unit_selected = false

func _on_unit_placed(unit_type_holding:String, ghost_position:Vector3):
	camera.is_unit_positioned = true
	for child_button in deploy_buttons_container.get_children():
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
