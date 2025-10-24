extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		get_tree().get_first_node_in_group("main").appear_glitch()
	pass # Replace with function body.


func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		get_tree().get_first_node_in_group("main").disappear_glitch()
	pass # Replace with function body.
