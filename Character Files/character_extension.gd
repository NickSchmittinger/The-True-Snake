extends CharacterBody2D
#No movements needed (for now)


@onready var parent : CharacterBody2D
@export var speed = 180
@export var speed_offset = 12
@export var direction : Vector2

func setup(parent_node):
	parent = parent_node
	var offset_vector : Vector2
	var parent_sprite_size_x = parent.find_children("","Sprite2D",false)[0].get_rect().size.x
	if parent.velocity == Vector2.ZERO:
		if not parent.is_in_group("Extension"):
			offset_vector = Vector2(1,0) * (Globals.extension_spawn_fixed_offset + parent_sprite_size_x)
		else:
			offset_vector = parent.position.direction_to(parent.parent.position) * (Globals.extension_spawn_fixed_offset + parent_sprite_size_x)
	else:
		offset_vector = parent.velocity.normalized() * (Globals.extension_spawn_fixed_offset + parent_sprite_size_x)
	
	position = parent.position + -offset_vector
	pass

func _physics_process(_delta):
	if parent:
		direction = parent.position - position
		var distance = direction.length()
		speed = parent.speed - speed_offset
		if distance <= Globals.extension_stop_threshold:
			velocity = Vector2.ZERO
		else:
			velocity = direction.normalized() * speed
		move_and_slide()
		pass
	else:
		queue_free()
		pass
