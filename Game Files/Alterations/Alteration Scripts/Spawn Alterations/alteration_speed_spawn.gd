extends one_time_alteration
class_name speed_zone_spawn

@export var speed_zone_path : String
@export var max_speed_zones : int

@export var boost_amount : float

var look_point : Vector2

func child_execute():
	for f in max_speed_zones:
		create_speed_zone_object()
		pass
	pass

func create_speed_zone_object():
	var zone = load(speed_zone_path).instantiate()
	node.add_child(zone)
	place_speed_zone_object(zone)
	pass

func place_speed_zone_object(object):
	object.position = Vector2(randf_range(0,Globals.screen_size.x), randf_range(0, Globals.screen_size.y))
	look_point = Vector2(randf_range(0,Globals.screen_size.x), randf_range(0, Globals.screen_size.y))
	object.look_at(look_point)
	object.boost_amount = boost_amount
	object.boost_direction = object.position.direction_to(look_point)
	print("Object Position: " + str(object.position) + ", Look Position: " + str(look_point))
	print("Boost Direction: " + str(object.boost_direction))
	pass
