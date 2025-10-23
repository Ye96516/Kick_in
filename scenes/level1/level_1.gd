extends Node3D

const player_pos:Vector3=Vector3(-15,3,0)
const player_angle:Vector3=Vector3(0,90,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SS.save_data("level",1)
	pass # Replace with function body.
