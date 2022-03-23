extends Spatial

signal player_detected

func _on_Trigger_body_entered(body):
	if body.is_in_group("Player"):
		emit_signal("player_detected")
