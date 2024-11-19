extends repeating_alteration
class_name food_teleport


func child_execute():
	print("Child")
	for f in world_node.existing_food_objects:
		var new_pos = Vector2(randf_range(0,Globals.screen_size.x), randf_range(0, Globals.screen_size.y))
		f.position = new_pos
		f.launch()
		print("Launch: " + str(new_pos))
		pass
	pass
