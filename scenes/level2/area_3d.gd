extends Area3D

@export var current_scene:Node

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		body.collision_layer=0
		body.collision_mask=0
		await get_tree().create_timer(2).timeout
		body.collision_layer=1
		body.collision_mask=1
		body.global_position=current_scene.player_pos
	pass # Replace with function body.
