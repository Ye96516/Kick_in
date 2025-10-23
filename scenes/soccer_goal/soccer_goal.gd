extends StaticBody3D

@export var next_level_path:String
@export var current_scene:Node
@export var level:int

func _on_soccer_goal_body_entered(body: Node3D) -> void:
	if body is Ball:
		body.queue_free()
		Global.occer_emit(next_level_path,current_scene,level)
	pass # Replace with function body.
