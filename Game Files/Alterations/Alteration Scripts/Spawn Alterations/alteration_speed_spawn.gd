extends one_time_alteration
class_name speed_zone_spawn

#Variable for reference to the file path of the speed zone
@export var speed_zone_path : String

#Variables for the amount of speed zones to spawn and value of their boost
@export var max_speed_zones : int
@export var boost_amount : float

#Variable for the zone boost to go towards
var look_point : Vector2

#Loops through the amount of speed zones to make and creates them
func child_execute():
	for f in max_speed_zones:
		create_speed_zone_object()
		pass
	pass

#Instantiates a speed zone from its file path
#Adds the new speed zone to the World Node and places them in it
func create_speed_zone_object():
	var zone = load(speed_zone_path).instantiate()
	node.add_child(zone)
	place_speed_zone_object(zone)
	pass

#Takes the given speed zone object and places it at a random point on screen
#Makes the speed zone object look at a random point on screen
#Sets the objects boost amount and direction to Resource boost amount and screen point being looked at
func place_speed_zone_object(object):
	object.position = Vector2(randf_range(0,Globals.screen_size.x), randf_range(0, Globals.screen_size.y))
	look_point = Vector2(randf_range(0,Globals.screen_size.x), randf_range(0, Globals.screen_size.y))
	object.look_at(look_point)
	object.boost_amount = boost_amount
	object.boost_direction = object.position.direction_to(look_point)
	print("Object Position: " + str(object.position) + ", Look Position: " + str(look_point))
	print("Boost Direction: " + str(object.boost_direction))
	pass
