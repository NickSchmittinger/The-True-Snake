extends Area2D

var world_node : Node2D
var base_alteration : alteration
var growth_amount : int

func _on_body_entered(body):
	if not body.is_in_group("Extension") || not body.is_in_group("Food"):
		base_alteration.stop_execute()
		for i in growth_amount:
			world_node.call_deferred("add_extension")
