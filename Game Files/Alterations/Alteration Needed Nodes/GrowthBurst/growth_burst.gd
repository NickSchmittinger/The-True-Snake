extends CharacterBody2D

#Variables for referencing the World Node and the growth burst alteration Resource
var world_node : Node2D
var base_alteration : alteration

#Variables for the amount of extensions that will be grown and speed the growth burst moves
var growth_amount : int
var motion_speed : float

#func _on_body_entered(body):
	#if not body.is_in_group("Extension") || not body.is_in_group("Food"):
		#base_alteration.stop_execute()
		#for i in growth_amount:
			#world_node.call_deferred("add_extension")

#Makes the newly spawned growth burst move in a chosen direction
func _ready():
	velocity = Vector2(randf_range(Globals.food_min_launch_dir,Globals.food_max_launch_dir), randf_range(Globals.food_min_launch_dir,Globals.food_max_launch_dir)).normalized()
	pass

#Continues the motion of the growth burst
func _physics_process(delta):
	position += velocity * motion_speed * delta
	pass
