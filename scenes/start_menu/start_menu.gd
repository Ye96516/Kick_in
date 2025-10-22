extends Control

var main:PackedScene

func _ready() -> void:
	if not SS.query_key("guide"):
		SS.save_data("guide",false)
	if SS.load_data("guide"):
		WorkerThreadPool.add_task(
		load_scence
	)
	
func load_scence():
	main=load("res://scenes/main/main.tscn")

func _on_button_pressed() -> void:
	if SS.query_key("guide") and not SS.load_data("guide"):
		get_tree().change_scene_to_file("res://scenes/guide/guide.tscn")
	if SS.query_key("guide") and SS.load_data("guide"):
		get_tree().change_scene_to_packed(main)
	pass # Replace with function body.

func _on_button_2_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
