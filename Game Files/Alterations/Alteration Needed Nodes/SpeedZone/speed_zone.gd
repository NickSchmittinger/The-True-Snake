extends Area2D

var boost_amount : float
var boost_direction : Vector2

func _on_body_entered(body):
	if not body.is_in_group("Extension") || not body.is_in_group("Food"):
		Globals.emit_signal("boost",(boost_direction * boost_amount))
		queue_free()
