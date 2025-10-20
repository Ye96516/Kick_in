extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if body is Ball:
		body.queue_free()
	if body is Player:
		owner.appear_glitch()

func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		owner.disappear_glitch()
