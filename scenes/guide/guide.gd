extends Control

var main:PackedScene
const NOISE = preload("uid://dkt7u8bg5j62s")
var audio:AudioStreamPlayer

func _ready() -> void:
	$AnimationPlayer.play("show")
	WorkerThreadPool.add_task(
		load_scence
	)

func load_scence():
	main=load("res://scenes/main/main.tscn")

func to_main():
	SS.save_data("guide",true)
	get_tree().change_scene_to_packed(main)
	

func play_audio():
	audio=AD.play(NOISE)
	
func clear_audio():
	AD.destory(audio)
