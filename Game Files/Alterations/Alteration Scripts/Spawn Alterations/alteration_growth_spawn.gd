extends one_time_alteration
class_name growth_burst_spawn

@export var growth_burst_path : String

@export var growth_amount : int

@export var motion_speed : float

func child_execute():
	create_growth_burst_object()
	pass

func create_growth_burst_object():
	var growth_burst = load(growth_burst_path).instantiate()
	node.add_child(growth_burst)
	place_growth_burst_object(growth_burst)
	pass

func place_growth_burst_object(object):
	object.world_node = world_node
	object.position = Vector2(randf_range(0,Globals.screen_size.x), randf_range(0, Globals.screen_size.y))
	object.growth_amount = growth_amount
	object.base_alteration = self
	object.motion_speed = motion_speed
	pass
