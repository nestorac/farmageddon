class_name ActionBar
extends Control

const MAX_ACTIONS = 15
var action = load("res://Scenes/action_ui.tscn")

@export var main_game:Node3D

@onready var h_box_container = $HBoxContainer
@onready var movements_container:HBoxContainer = $HBoxContainer/Movements
@onready var charges_containter:HBoxContainer = $HBoxContainer/Charges
@onready var distanceattacks:HBoxContainer = $HBoxContainer/DistanceAttacks
@onready var spells_container:HBoxContainer = $HBoxContainer/Spells

func add_action(action_name:String, type:String, unit_id:int, mov_target:Vector3):
	# If there is one action for that unit, return.
	
	var _actions = _get_actions_in_bar()
	for _action in _actions:
		if _action.unit_id == unit_id:
			_action.action_name = action_name
			_action.action_type = type
			_action.movement_target = mov_target
			return
			#_action.queue_free()
			# TODO: Add animation for substitution of the action.
	
	if h_box_container.get_child_count() >= MAX_ACTIONS:
		return
	var action_inst = action.instantiate()
	action_inst.action_name = action_name
	action_inst.action_type = type
	action_inst.unit_id = unit_id
	action_inst.movement_target = mov_target
	
	match action_inst.action_type:
		"movement":
			main_game.actions.movements.append(action_inst)
			h_box_container.get_child(0).add_child(action_inst)
		"charge":
			main_game.actions.charges.append(action_inst)
			h_box_container.get_child(1).add_child(action_inst)
		"distance_attack":
			main_game.actions.distance_attacks.append(action_inst)
			h_box_container.get_child(2).add_child(action_inst)
		"spell":
			main_game.actions.spells.append(action_inst)
			h_box_container.get_child(3).add_child(action_inst)
		
func _get_actions_in_bar() -> Array:
	var _actions:Array = get_tree().get_nodes_in_group("Action")
	return _actions

# For debugging.
#func _input(event):
	#if event.is_action_released("l_click"):
		#add_action("test", "movement", 0)

func do_first_action() -> void:
	var unit_nodes = get_tree().get_nodes_in_group("Units")
	#for movement
	if movements_container.get_child_count() <= 0:
		return
	var first_action = movements_container.get_child(0)
	if not first_action:
		return
	for unit_node in unit_nodes:
		if first_action.unit_id == unit_node.unit_id:
				unit_node.start_action_move(first_action.movement_target)

func clear_first_action() -> void:
	var first_action = movements_container.get_child(0)
	if first_action:
			first_action.free()
	

func _on_button_play_button_up():
	do_first_action()
#	var unit_nodes = get_tree().get_nodes_in_group("Units")
	# Movements
	#for action_queued in h_box_container.get_child(0).get_children():
		#print(action_queued.name, " ", action_queued.action_name, " id: ",
			  #action_queued.unit_id, "target: ", action_queued.movement_target)
		#for unit_node in unit_nodes:
			#if action_queued.unit_id == unit_node.unit_id:
				#unit_node.start_action_move(action_queued.movement_target)
		#action_queued.queue_free()
		#
	## Charges
	#for action_queued in h_box_container.get_child(1).get_children():
		#print(action_queued.name, " ", action_queued.action_name, ", id: ",
			  #action_queued.unit_id, ", target: ", action_queued.movement_target)
		#action_queued.queue_free()
		#
	## Distance attacks
	#for action_queued in h_box_container.get_child(2).get_children():
		#print(action_queued.name, " ", action_queued.action_name, ", id: ",
			  #action_queued.unit_id, ", target: ", action_queued.movement_target)
		#action_queued.queue_free()
		#
	## Spells
	#for action_queued in h_box_container.get_child(3).get_children():
		#print(action_queued.name, " ", action_queued.action_name, ", id: ",
			  #action_queued.unit_id, ", target: ", action_queued.movement_target)
		#action_queued.queue_free()
		
	
		
#TODO
## Add custom actions: attack, walk, run...
## Pass the actions to the pigs.
## The pig prints the actions.


func _on_button_movement_button_up():
	print ("Add a movement.")
	add_action("Movement", "movement", 0, Vector3.ZERO)
	pass # Replace with function body.


func _on_button_spell_button_up():
	print ("Add a spell.")
	add_action("Fireball", "spell", 1, Vector3.ZERO)
	pass # Replace with function body.
