extends CharacterBody2D

#Variables for the movement, size, and value of the food
@export var speed : float = 500
@export var point_value : int = 1

var object_size : Vector2

#Connects the global launch signal to the foods launch function
func _ready():
	Globals.connect("launch", launch)
	pass

#Moves the food in a linear direction until it collides with a wall or the player
#Colliding with the player will consume it
#Colliding with the wall will make it bounce and change direction
func _physics_process(delta):
	position += velocity * speed * delta
	if position.x <= 0:
		velocity.x = abs(velocity.x)
		position.x = 0
	elif position.x >= Globals.screen_size.x:
		velocity.x = -abs(velocity.x)
		position.x = Globals.screen_size.x
	if position.y <= 0:
		velocity.y = abs(velocity.y)
		position.y = 0
	elif position.y >= Globals.screen_size.y:
		velocity.y = -abs(velocity.y)
		position.y = Globals.screen_size.y - object_size.y
	
	pass

#Begins the movement of the food in a random direction
func launch():
	velocity = Vector2(randf_range(Globals.food_min_launch_dir,Globals.food_max_launch_dir), randf_range(Globals.food_min_launch_dir,Globals.food_max_launch_dir)).normalized()
	pass

#Switches the foods ability to collide with the player
func disable_collider(val):
	$CollisionShape2D.disabled = val
	pass

#Tells the disable collider function to allow the food to collide with the player again
func _on_enable_timer_timeout():
	disable_collider(false)
	pass
