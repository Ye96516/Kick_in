extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		body.global_position=get_parent().player_pos
	pass # Replace with function body.


func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		body.global_position=get_parent().player_pos
	pass # Replace with function body.
