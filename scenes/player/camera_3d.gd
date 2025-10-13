extends Camera3D


# 使用 _unhandled_input 是处理游戏性输入的最佳实践
func _unhandled_input(event: InputEvent) -> void:
	# 只要有任何未被UI处理的输入，就打印消息
	print("Input event received in 3D world: ", event.as_text())

	# 如果是鼠标移动事件，特别打印出来
	if event is InputEventMouseMotion:
		print("Mouse is moving!")
