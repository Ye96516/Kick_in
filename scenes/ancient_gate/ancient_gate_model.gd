extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func open_the_door():
	animation_player.play("open")

func close_the_door():
	animation_player.play("close")


func _on_area_3d_body_entered(body: Node3D) -> void:
	#if body is Player:
		
	pass # Replace with function body.
