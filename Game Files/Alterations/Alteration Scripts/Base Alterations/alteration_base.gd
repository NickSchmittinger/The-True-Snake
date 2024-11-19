extends Resource
class_name alteration

@export var alteration_name : String
@export var alteration_image : Texture2D

var duration_timer : Timer
@export var alteration_duration : float
@export var stop : bool = false

var node : Node2D
var world_node : Node2D
var gui_node : Control
var alteration_node : Node

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

func execute():
	pass

func stop_execute():
	stop = true
	alteration_node.stop_alteration(self)
	pass
