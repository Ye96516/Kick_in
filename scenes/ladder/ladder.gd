extends Node3D

@onready var label: Label3D = %Label3D

func _ready() -> void:
	label.visible=false
