extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.occer.connect(self_occer)
	pass # Replace with function body.

func self_occer(_l:int):
	CS.chang_scene("res://scenes/level2/level_2.tscn")
