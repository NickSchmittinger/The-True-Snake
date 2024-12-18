extends Area2D

#Variables for the direction and amount of boost
var boost_amount : float
var boost_direction : Vector2

#When the character alone collides with this, the player is launched in the forward facing direction of this boost
#The boost object deletes itself when the player is launched
func _on_body_entered(body):
	if not body.is_in_group("Extension") || not body.is_in_group("Food"):
		Globals.emit_signal("boost",(boost_direction * boost_amount))
		queue_free()
