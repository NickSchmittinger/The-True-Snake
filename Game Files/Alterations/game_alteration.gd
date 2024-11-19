extends Node

@export var world_node : Node2D
@export var gui_node : Control

@export var alterations : Array[alteration] = []


func _ready():
	Globals.connect("alter_game", choose_random_alteration_execute)
	Globals.connect("end_game", clear_all)
	pass

func clear_all():
	for a in Globals.active_alterations:
		stop_alteration(a)
	pass

func choose_random_alteration_execute():
	print("Choosing")
	execute_alteration(alterations.pick_random())
	pass

func execute_alteration(input_alteration: alteration):
	if not Globals.active_alterations.has(input_alteration):
		Globals.active_alterations.append(input_alteration)
		input_alteration.create(world_node, gui_node, self)
		Globals.latest_alteration = input_alteration.alteration_name
		input_alteration.execute()

func stop_alteration(input_alteration: alteration):
	var remove_alteration = Globals.active_alterations[Globals.active_alterations.find(input_alteration)]
	Globals.active_alterations.erase(remove_alteration)
	input_alteration.node.queue_free()
	Globals.emit_signal("alter_ended")
	pass
