extends Node

#Variables with references to the exisiting world and gui nodes
@export var world_node : Node2D
@export var gui_node : Control

#List of all available alterations
@export var alterations : Array[alteration] = []

#Connects alter game and end game signals to creating a new alteration and clearing all exisiting alterations
func _ready():
	Globals.connect("alter_game", choose_random_alteration_execute)
	Globals.connect("end_game", clear_all)
	pass

#Stops and Ends all exisiting alterations
func clear_all():
	for a in Globals.active_alterations:
		stop_alteration(a)
	pass

#Chooses a random alteration from possibilities list to create
func choose_random_alteration_execute():
	print("Choosing")
	execute_alteration(alterations.pick_random())
	pass

#Tells the input alteration to execute unless it already exists
#If it doesn't exist, the new alteration is created and executed
func execute_alteration(input_alteration: alteration):
	if not Globals.active_alterations.has(input_alteration):
		Globals.active_alterations.append(input_alteration)
		input_alteration.create(world_node, gui_node, self)
		Globals.latest_alteration = input_alteration.alteration_name
		input_alteration.execute()

#Tells the input alteration to delete itself and sends out the global signal that the alteration ended
func stop_alteration(input_alteration: alteration):
	var remove_alteration = Globals.active_alterations[Globals.active_alterations.find(input_alteration)]
	Globals.active_alterations.erase(remove_alteration)
	input_alteration.node.queue_free()
	Globals.emit_signal("alter_ended")
	pass
