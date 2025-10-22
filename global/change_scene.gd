
extends Node

var _current_loading_path: String = ""

func chang_scene(path: String):
	_current_loading_path = path
	# 开始异步加载
	ResourceLoader.load_threaded_request(path)

# 在_process中检查加载状态
func _process(_delta):
	if _current_loading_path.is_empty():
		return

	var progress: Array = []
	var status = ResourceLoader.load_threaded_get_status(_current_loading_path, progress)
	
	match status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			# 可以在这里更新UI进度条，progress[0]是0.0到1.0的进度
			print("Loading: ", progress[0] * 100, "%")
		ResourceLoader.THREAD_LOAD_LOADED:
			# 加载完成，获取资源并切换场景
			var scene = ResourceLoader.load_threaded_get(_current_loading_path)
			get_tree().change_scene_to_packed(scene)
			_current_loading_path = "" # 重置状态
		ResourceLoader.THREAD_LOAD_FAILED:
			print("Failed to load scene: ", _current_loading_path)
			_current_loading_path = ""
