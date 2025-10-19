extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	if not SS.query_key("guide"):
		SS.save_data("guide",false)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/guide/guide.tscn")
	pass # Replace with function body.
