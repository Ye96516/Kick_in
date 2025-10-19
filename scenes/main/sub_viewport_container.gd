extends SubViewportContainer


@export var player:CharacterBody3D
@onready var color_rect: ColorRect = %ColorRect

# Called when the node enters the scene tree for the first time.

func _unhandled_input(event: InputEvent) -> void:
	#射击逻辑
	if player.mouse_captured and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if player.marker_3d.get_child_count():
			player.shoot_an()
			player.marker_3d.get_child(0).throw(Vector3(-10*player.basis.z.x,1,-10*player.basis.z.z))
	#出现故障逻辑
	if player.mouse_captured and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		color_rect.visible=!color_rect.visible
		
	if player.mouse_captured and event is InputEventMouseMotion:
		player.rotate_look(event.relative)
		
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		player.capture_mouse()
	if Input.is_key_pressed(KEY_ESCAPE):
		player.release_mouse()
	pass
