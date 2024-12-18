extends alteration
class_name one_time_alteration

#Is an extendable class that defines whether the alteration is a one shot and does not repeat

func execute():
	print("Execute Alteration: Stopped? " + str(stop))
	child_execute()
	pass

#Overrideable function for all child implementations
func child_execute():
	pass
