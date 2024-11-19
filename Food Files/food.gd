extends CharacterBody2D

@onready var colorSprite = $ColorSprite
@onready var facialSprite = $FacialSprite
@onready var faces = ["Blush", "Laugh", "Scared"]

@export var speed : float = 500
@export var point_value : int = 1

var object_size : Vector2

func _ready():
	colorSprite.connect("texture_changed", set_sprite_size)
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

func set_face(state : String):
	if state == "Blush":
		facialSprite.play("Blush")
		pass
	elif state == "Cry":
		facialSprite.play("Cry")
		pass
	elif state == "Scared":
		facialSprite.play("Scared")
		pass
	elif state == "Laugh":
		facialSprite.play("Laugh")
		pass
	pass

func set_random_face():
	set_face(faces.pick_random())
	pass

func set_sprite_size():
	object_size = colorSprite.texture.size
	pass

func disable_collider(val):
	set_face("Cry")
	$CollisionShape2D.disabled = val
	pass

func _on_enable_timer_timeout():
	disable_collider(false)
	set_random_face()
	pass
