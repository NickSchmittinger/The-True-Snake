extends CharacterBody2D

#Potential Move
@export var buffTimer : Timer

#Most likely Staying
@export var base_speed = 200
@export var speed = 200
@export var angular_speed = 5

var boost : Vector2 = Vector2.ONE
var boosting : bool = false

@export var collider : CollisionShape2D
var collision : KinematicCollision2D

@export var extensions = []

func _ready():
	Globals.connect("player_speed_up", nat_speed_up)
	Globals.connect("extend",add_extension)
	Globals.connect("boost", apply_boost)
	if not collider:
		collider = $CollisionShape2D
	if not buffTimer:
		buffTimer = $BuffTimer
	pass

func add_extension(extension_object):
	extensions.append(extension_object)
	extension_object.name = "extension_object" + str(extensions.size())
	if extensions.size() > 1:
		extension_object.setup(extensions[extensions.size()-2])
		pass
	else:
		extension_object.setup(self)
		pass
	pass

func nat_speed_up(percent):
	speed += base_speed * percent
	pass

## buffTimer (add as param? move buffTimer to globals / other?)##
func apply_boost(boost_value : Vector2):
	boost = boost_value
	boosting = true
	buffTimer.start(.3)
	pass

func _physics_process(delta):
	if boosting:
		velocity = boost
	else:
		velocity = Vector2.ONE * transform.y * speed
	rotation += Input.get_axis("left", "right") * angular_speed * delta
	
	if move_and_slide():
		collision = get_last_slide_collision()
		if collision.get_collider().is_in_group("Food"):
			Globals.emit_signal("consume", [collision.get_collider()])
		if collision.get_collider().is_in_group("Growth"):
			Globals.emit_signal("growth_consumed", collision.get_collider())
		elif collision.get_collider().is_in_group("Extension"):
			Globals.emit_signal("end_game")
			pass
		pass

	if global_position.x < Globals.screen_rect.position.x || global_position.y < Globals.screen_rect.position.y:
		Globals.emit_signal("end_game")
		pass
	if global_position.x >= Globals.screen_rect.end.x || global_position.y >= Globals.screen_rect.end.y:
		Globals.emit_signal("end_game")
		pass
	pass


func _on_buff_timer_timeout():
	boosting = false
	boost = Vector2.ONE
	pass
