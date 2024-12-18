extends one_time_alteration
class_name growth_burst_spawn

#Variable for the growth burst object file
@export var growth_burst_path : String

#Variables for the speed of the growth burst and the amount of extensions the growth burst will give
@export var growth_amount : int
@export var motion_speed : float

func child_execute():
	create_growth_burst_object()
	pass

#Instantiates a growth burst object from its file path
#Adds the new growth burst object to the scene
func create_growth_burst_object():
	var growth_burst = load(growth_burst_path).instantiate()
	node.add_child(growth_burst)
	place_growth_burst_object(growth_burst)
	pass

#Places the new growth burst object in the World Node at a random position
#Sets the values of growth amount, speed, and the reference for the alteration Resource to the variables here
func place_growth_burst_object(object):
	object.world_node = world_node
	object.position = Vector2(randf_range(0,Globals.screen_size.x), randf_range(0, Globals.screen_size.y))
	object.growth_amount = growth_amount
	object.base_alteration = self
	object.motion_speed = motion_speed
	pass
