extends Control

var main:PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(SS.show_all_content())
	if not SS.query_key("guide"):
		SS.save_data("guide",false)
		print(SS.show_all_content())
	if SS.load_data("guide"):
		WorkerThreadPool.add_task(
		load_scence
	)
	
func load_scence():
	main=load("res://scenes/main/main.tscn")

func _on_button_pressed() -> void:
	if SS.query_key("guide") and not SS.load_data("guide"):
		get_tree().change_scene_to_file("res://scenes/guide/guide.tscn")
	if SS.load_data("guide"):
		get_tree().change_scene_to_packed(main)
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	print(SS.data.archives_file)
	pass # Replace with function body.
