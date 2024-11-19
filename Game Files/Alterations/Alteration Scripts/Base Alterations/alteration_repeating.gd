extends alteration
class_name repeating_alteration

@export var countdown_time_min : float = 1.0
@export var countdown_time_max : float = 2.0
var timer : Timer

func execute():
	timer = Timer.new()
	node.add_child(timer)
	timer.timeout.connect(start_timer)
	start_timer()
	print("Execute Alteration: Stopped? " + str(stop))
	pass

func start_timer():
	if not stop:
		timer.start(randf_range(countdown_time_min,countdown_time_max))
		child_execute()
	pass

func child_execute():
	pass
