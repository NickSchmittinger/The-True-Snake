extends alteration
class_name repeating_alteration

#Is an extendable class that defines whether the alteration repeats

#Overrideable indicators for the duration of the repeating timer
@export var countdown_time_min : float = 1.0
@export var countdown_time_max : float = 2.0
var timer : Timer

#Creates and starts the timer to make this alteration repeat
func execute():
	timer = Timer.new()
	node.add_child(timer)
	timer.timeout.connect(start_timer)
	start_timer()
	print("Execute Alteration: Stopped? " + str(stop))
	pass

#Makes the time between repeats a random value between min and max possibile times
func start_timer():
	if not stop:
		timer.start(randf_range(countdown_time_min,countdown_time_max))
		child_execute()
	pass

func child_execute():
	pass
