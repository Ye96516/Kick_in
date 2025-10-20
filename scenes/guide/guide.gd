extends Control

var main:PackedScene

func _ready() -> void:
	$AnimationPlayer.play("show")
	WorkerThreadPool.add_task(
		load_scence
	)

func load_scence():
	main=load("res://scenes/main/main.tscn")

func to_main():
	get_tree().change_scene_to_packed(main)
	#get_tree().change_scene_to_file(main)
