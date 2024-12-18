extends CharacterBody2D

#Variables for parent and following necessities
@onready var parent : CharacterBody2D
@export var speed = 180
@export var speed_offset = 25
@export var direction : Vector2

#Creates the extension: sets the parent to follow and the offset its followed by
#Checks the velocity of the parent and alters the position it spawns at based on the direction the parent is moving
#If the parent is not moving, the new extension will spawn to the parents left
#If the parent is moving, the new extension will spawn behind it
#The exact offset it spawns at will be the size of the parent combined with the extensions fixed offset value
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

#Controls the movement of the extension to follow its parent by a set distance
#If the extension has no parent, it will delete itself
func _physics_process(_delta):
	if parent:
		direction = parent.position - position
		var distance = direction.length()
		speed = parent.speed - (parent.speed / speed_offset)
		if distance <= Globals.extension_stop_threshold:
			velocity = Vector2.ZERO
		else:
			velocity = direction.normalized() * speed
		move_and_slide()
		pass
	else:
		queue_free()
		pass
