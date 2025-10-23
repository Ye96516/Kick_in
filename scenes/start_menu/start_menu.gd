extends Control

func _ready() -> void:
	if not SS.query_key("guide"):
		SS.save_data("guide",false)
	if not SS.query_key("level"):
		SS.save_data("level",1)
		
func _on_button_pressed() -> void:
	if SS.query_key("guide") and not SS.load_data("guide"):
		get_tree().change_scene_to_file("res://scenes/guide/guide.tscn")
	
	if SS.query_key("guide") and SS.load_data("guide"):
		match SS.load_data("level"):
			1:
				CS.to_main(["res://scenes/main/main.tscn","res://scenes/level1/level_1.tscn"])
			2:
				CS.to_main(["res://scenes/main/main.tscn","res://scenes/level2/level_2.tscn"])

func _on_button_2_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
