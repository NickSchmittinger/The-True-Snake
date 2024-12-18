extends Resource
class_name alteration

#Variables for the alteration definition
@export var alteration_name : String
@export var alteration_image : Texture2D

#Variables for length of the alteration and whether it is active or not
var duration_timer : Timer
@export var alteration_duration : float
@export var stop : bool = false

#Variables for references to the world, gui, itself, and the alteration holder node
var node : Node2D
var world_node : Node2D
var gui_node : Control
var alteration_node : Node

#Called when the alteration is to be added to the world
#Sets the reference for the variables above to the parameters of the function
#Creates a node that will hold this instance of the alteration (makes it easier to use)
#Gives the alteration a duration timer with connecting start and timeout functions
func create(world : Node2D, gui : Control, parent_node : Node):
	world_node = world
	gui_node = gui
	alteration_node = parent_node
	node = Node2D.new()
	alteration_node.add_child(node)
	duration_timer = Timer.new()
	node.add_child(duration_timer)
	stop = false
	duration_timer.timeout.connect(stop_execute)
	duration_timer.start(alteration_duration)
	pass

#Overrideable function for alterations to use differently on their own
func execute():
	pass

#Called when the alteration is done in the world: deletes itself
func stop_execute():
	stop = true
	alteration_node.stop_alteration(self)
	pass
