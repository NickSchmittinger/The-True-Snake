extends CharacterBody2D

@export var speed : float = 500
@export var point_value : int = 1

var object_size : Vector2

func _ready():
	Globals.connect("launch", launch)
	set_random_face()
	pass

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

func launch():
	velocity = Vector2(randf_range(Globals.food_min_launch_dir,Globals.food_max_launch_dir), randf_range(Globals.food_min_launch_dir,Globals.food_max_launch_dir)).normalized()
	pass

func set_random_face():

	pass

func set_sprite_size():

	pass

func disable_collider(val):

	$CollisionShape2D.disabled = val
	pass

func _on_enable_timer_timeout():
	disable_collider(false)
	set_random_face()
	pass
