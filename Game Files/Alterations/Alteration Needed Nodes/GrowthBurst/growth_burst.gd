extends CharacterBody2D

var world_node : Node2D
var base_alteration : alteration
var growth_amount : int
var motion_speed : float

#func _on_body_entered(body):
	#if not body.is_in_group("Extension") || not body.is_in_group("Food"):
		#base_alteration.stop_execute()
		#for i in growth_amount:
			#world_node.call_deferred("add_extension")

func _ready():
	velocity = Vector2(randf_range(Globals.food_min_launch_dir,Globals.food_max_launch_dir), randf_range(Globals.food_min_launch_dir,Globals.food_max_launch_dir)).normalized()
	
	pass

func _physics_process(delta):
	position += velocity * motion_speed * delta
	pass
