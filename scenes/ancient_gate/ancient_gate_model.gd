extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: Label3D = %Label3D

func open_the_door():
	animation_player.play("open")

func close_the_door():
	animation_player.play("close")


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		label.visible=true
		if Global.get_ladder:
			label.text="原来是修理工，快请进！"
			open_the_door()
	pass # Replace with function body.


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is Player:
		label.visible=false
	pass # Replace with function body.
