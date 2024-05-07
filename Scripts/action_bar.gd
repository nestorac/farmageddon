class_name ActionBar
extends Control

const MAX_ACTIONS = 15
var action = load("res://Scenes/action_ui.tscn")

@onready var h_box_container = $HBoxContainer
@export var main_game:Node3D

func add_action(action_name:String, type:String, unit_id:int, mov_target:Vector3):
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
		

# For debugging.
#func _input(event):
	#if event.is_action_released("l_click"):
		#add_action("test", "movement", 0)


func _on_button_button_up():
	# Movements
	for action_queued in h_box_container.get_child(0).get_children():
		print(action_queued.name, " ", action_queued.action_name, " id: ",
			  action_queued.unit_id, "target: ", action_queued.movement_target)
		action_queued.queue_free()
		
	# Charges
	for action_queued in h_box_container.get_child(1).get_children():
		print(action_queued.name, " ", action_queued.action_name, ", id: ",
			  action_queued.unit_id, ", target: ", action_queued.movement_target)
		action_queued.queue_free()
		
	# Distance attacks
	for action_queued in h_box_container.get_child(2).get_children():
		print(action_queued.name, " ", action_queued.action_name, ", id: ",
			  action_queued.unit_id, ", target: ", action_queued.movement_target)
		action_queued.queue_free()
		
	# Spells
	for action_queued in h_box_container.get_child(3).get_children():
		print(action_queued.name, " ", action_queued.action_name, ", id: ",
			  action_queued.unit_id, ", target: ", action_queued.movement_target)
		action_queued.queue_free()
		
	
		
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
