extends Node2D

@onready var creatable_food_object = preload("res://Food Files/food.tscn")
@onready var creatable_character_object = preload("res://Character Files/character.tscn")
@onready var creatable_extension = preload("res://Character Files/character_extension.tscn")
@export var existing_food_objects = []

#No use?
@export var current_extension_object : CharacterBody2D


func _ready():
	Globals.connect("begin_spawn",initial_spawn)
	Globals.connect("end_game", end_game)
	Globals.connect("consume", eat_food)
	pass

func end_game():
	for c in get_children():
		c.queue_free()
		pass
	existing_food_objects.clear()
	pass

func create_character():
	var character = creatable_character_object.instantiate()
	add_child(character)
	character.position = get_viewport_rect().size / 2
	pass

func create_food(num):
	for f in num:
		var new_food = creatable_food_object.instantiate()
		add_child(new_food)
		existing_food_objects.append(new_food)
		new_food.position = Vector2(randf_range(0,Globals.screen_size.x), randf_range(0, Globals.screen_size.y))
	pass

func add_extension():
	var new_extension = creatable_extension.instantiate()
	add_child(new_extension)
	Globals.emit_signal("extend", new_extension)
	pass

func initial_spawn():
	create_character()
	create_food(3)
	unpause_world()
	pass

func pause_world():
	get_parent().get_node("RespawnTimer").stop()
	for n in get_children():
		n.process_mode = Node.PROCESS_MODE_DISABLED
		n.hide()
	pass

func unpause_world():
	for n in get_children():
		n.process_mode = Node.PROCESS_MODE_INHERIT
		n.show()
	Globals.emit_signal("launch")
	pass

func reset_food_position(food_obj):
	if not Globals.ended:
		food_obj.disable_collider(true)
		food_obj.visible = false
		food_obj.position = Vector2(randf_range(0,Globals.screen_size.x), randf_range(0, Globals.screen_size.y))
		food_obj.visible = true
		food_obj.get_node("EnableTimer").start()
	pass

func eat_food(food_object):
	Globals.add_points(food_object[0].point_value)
	add_extension()
	reset_food_position(food_object[0])
	pass

func _on_respawn_timer_timeout():

	pass
