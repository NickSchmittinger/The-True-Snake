extends Node2D

#References to creatable food, character, and character extension files
@onready var creatable_food_object = preload("res://Food Files/food.tscn")
@onready var creatable_character_object = preload("res://Character Files/character.tscn")
@onready var creatable_extension = preload("res://Character Files/character_extension.tscn")

#Holding list for food objects in scene
@export var existing_food_objects = []

#No use?
@export var current_extension_object : CharacterBody2D

#Sets up a connection from global signals to local functions
func _ready():
	Globals.connect("begin_spawn",initial_spawn)
	Globals.connect("end_game", end_game)
	Globals.connect("consume", eat_food)
	Globals.connect("growth_consumed", eat_growth_burst)
	pass

#Called when game ends: removes all 2D objects currently in the World Node
#Clears the list of all food objects in the scene
#World Node contains: character, character extensions, food (for now)
#Potentially moved to a singularity that controls all aspects of game ending
func end_game():
	for c in get_children():
		c.queue_free()
		pass
	existing_food_objects.clear()
	pass

#Called at beginning of game: creates a character using the reference to the character file created above ^
#Adds the character to the World Node and sets its position to the center of the screen
func create_character():
	var character = creatable_character_object.instantiate()
	add_child(character)
	character.position = get_viewport_rect().size / 2
	pass

#Called at the beginning of game: loops through num of food to be created and instantiates a copy of the food object file from above ^
#Adds the food to the World Node and adds a reference to it to the existing food objects list
#Sets the starting position of the new food to a random point on the screen
func create_food(num):
	for f in num:
		var new_food = creatable_food_object.instantiate()
		add_child(new_food)
		existing_food_objects.append(new_food)
		new_food.position = Vector2(randf_range(0,Globals.screen_size.x), randf_range(0, Globals.screen_size.y))
	pass

#Called when the player is to have an extension added to it: creates an instance of the extension file above ^
#Adds the extension to the World Node and then sends a global signal "extend" (to the player) and gives it a reference to the new extension
func add_extension():
	var new_extension = creatable_extension.instantiate()
	add_child(new_extension)
	Globals.emit_signal("extend", new_extension)
	pass

#Called at the beginning of the game: Creates the character, initial food objects, and unpauses the world
func initial_spawn():
	create_character()
	create_food(3)
	unpause_world()
	pass

#Disables the timer allowing food objects to respawn
#Loops through all children of World Node and disables their processing as well as hides them
func pause_world():
	get_parent().get_node("RespawnTimer").stop()
	for n in get_children():
		n.process_mode = Node.PROCESS_MODE_DISABLED
		n.hide()
	pass

#Loops through all children of World Node and enables their processing as well as reveals them
#Sends the global signal to launch any stopped projectiles (food)
func unpause_world():
	for n in get_children():
		n.process_mode = Node.PROCESS_MODE_INHERIT
		n.show()
	Globals.emit_signal("launch")
	pass

#Disables food ability to collide and makes it temporarily invisible
#Sets the new position of the food and makes it visible again
#Respawn timer is started which will re-enable the food upon completion
func reset_food_position(food_obj):
	if not Globals.ended:
		food_obj.disable_collider(true)
		food_obj.visible = false
		food_obj.position = Vector2(randf_range(0,Globals.screen_size.x), randf_range(0, Globals.screen_size.y))
		food_obj.visible = true
		food_obj.get_node("EnableTimer").start()
	pass

#Called when the player collides with a food object
#This adds an extension to the player and resets the food
#This also tells the global script to give the player the point value of the food object
func eat_food(food_object):
	Globals.add_points(food_object[0].point_value)
	add_extension()
	reset_food_position(food_object[0])
	pass

#Called when the player collides with the growth burst power-up
#This tells the growth burst to call its stop execute function
#This adds the amount of extensions from the growth amount to the player
#This tells the global script to give the player the point value of the growth object
func eat_growth_burst(growth_object):
	Globals.add_points(growth_object.growth_amount)
	growth_object.base_alteration.stop_execute()
	for i in growth_object.growth_amount:
		call_deferred("add_extension")
	pass

#No function for the World Node
#(to be removed)
func _on_respawn_timer_timeout():

	pass
