extends alteration
class_name one_time_alteration

func execute():
	print("Execute Alteration: Stopped? " + str(stop))
	child_execute()
	pass

func child_execute():
	pass
