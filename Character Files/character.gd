extends CharacterBody2D

#Timer for determing how long each buff affects player
#Potential Move
@export var buffTimer : Timer

#Variables for the player speed and rotational speed
#Most likely Staying
@export var base_speed = 200
@export var speed = 200
@export var angular_speed = 5

#Variables to determine the boost and direction for the player
var boost : Vector2 = Vector2.ONE
var boosting : bool = false

#Variables for the player body
@export var collider : CollisionShape2D
var collision : KinematicCollision2D

#List of extensions connected to the player
@export var extensions = []

#Connects global signals to speed increase, boost, and extension creation functions
#Ensures the collider and buff timers exist
func _ready():
	Globals.connect("player_speed_up", nat_speed_up)
	Globals.connect("extend",add_extension)
	Globals.connect("boost", apply_boost)
	if not collider:
		collider = $CollisionShape2D
	if not buffTimer:
		buffTimer = $BuffTimer
	pass

#Adds a reference to the extension object to the extensions list
#Names the extension object to extension object + its place in the list
#Calls the extension set up function passing it either the character or the previous extension in the list of extensions
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

#Increases the speed of the player by adding a percentage of the original speed to the current speed
func nat_speed_up(percent):
	speed += base_speed * percent
	pass

#Applies a boost in the direction of boost value
#Tells the player that it is boosting and denies the player the ability to move while boosting
#Times the boost to end after a certain amount of time
## buffTimer (add as param? move buffTimer to globals / other?)##
func apply_boost(boost_value : Vector2):
	boost = boost_value
	boosting = true
	buffTimer.start(.3)
	pass

#Manages the player movement based on rotational directions pressed
#Player will always be moving forward
#Disables the ability for player to control movement while boosting
#Constantly checks if the player collides with something
#Tells the game what the player collided with food and growth will add extensions and points while colliding with an extension will end the game
#Ensures the player is still on the screen to keep playing and ends the game on touching the walls of the screen
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

#Disables the boost
func _on_buff_timer_timeout():
	boosting = false
	boost = Vector2.ONE
	pass
