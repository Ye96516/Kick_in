extends StaticBody3D

func _on_soccer_goal_body_entered(body: Node3D) -> void:
	if body is Ball:
		body.queue_free()
		Global.socre_occer=true
	pass # Replace with function body.
