extends repeating_alteration
class_name food_teleport

#Loops through food objects in the world and sets them in a new position
#When the food objects have new positions, they are launched in a random direction using their launch function
func child_execute():
	print("Child")
	for f in world_node.existing_food_objects:
		var new_pos = Vector2(randf_range(0,Globals.screen_size.x), randf_range(0, Globals.screen_size.y))
		f.position = new_pos
		f.launch()
		print("Launch: " + str(new_pos))
		pass
	pass
