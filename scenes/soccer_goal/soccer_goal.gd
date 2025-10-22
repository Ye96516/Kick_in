extends StaticBody3D

@export var level:int=1

func _on_soccer_goal_body_entered(body: Node3D) -> void:
	if body is Ball:
		body.queue_free()
		Global.occer_emit(level)
	pass # Replace with function body.
