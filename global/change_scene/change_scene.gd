extends CanvasItem

@onready var progress_bar: ProgressBar = %ProgressBar
@onready var loading: Label = %Loading

const z := 4095

# --- 状态管理 ---
enum State { IDLE, LOADING, FAILED }
var current_state = State.IDLE

# --- 任务数据存储 ---
# 使用字典来存储更复杂的任务信息
var loading_task: Dictionary = {}

func _ready() -> void:
	z_index = z
	visible = false

# =============================================================================
# --- 公开的 API 函数 ---
# =============================================================================

## 1. 简单的场景切换
func change_scene(path: String):
	if current_state == State.LOADING: return
	
	loading_task = {
		"type": "change_scene",
		"paths": [path]
	}
	_start_loading()

## 2. 移除当前关卡并加载新关卡 (已实现)
func load_level(path: String, current_scene: Node, father_viewport: Viewport, player_node: Node):
	if current_state == State.LOADING: return
	
	loading_task = {
		"type": "load_level",
		"paths": [path],
		"father": father_viewport,
		"player": player_node
	}
	
	# 使用一个异步函数来处理移除和启动加载的流程
	_remove_and_start_loading(current_scene)

## 3. 组合多个场景
func to_main(paths: Array[String]):
	if current_state == State.LOADING: return
	
	if paths.size() < 2:
		printerr("to_main: 路径数组至少需要包含两个场景！")
		return
		
	loading_task = {
		"type": "to_main",
		"paths": paths
	}
	_start_loading()

# =============================================================================
# --- 内部逻辑函数 ---
# =============================================================================

# --- 异步辅助函数，用于先移除旧场景再开始加载 ---
func _remove_and_start_loading(scene_to_remove: Node):
	self.visible = true # 先显示加载界面
	loading.text = "正在卸载当前场景..."
	progress_bar.value = 0
	
	scene_to_remove.queue_free()
	await scene_to_remove.tree_exited # 等待节点完全从树中移除
	
	print("旧场景已移除，开始加载新场景...")
	_start_loading()

# --- 统一的加载启动函数 ---
func _start_loading():
	self.visible = true
	current_state = State.LOADING
	loading.text = "加载中..."
	
	var paths_to_load = loading_task.get("paths", [])
	for path in paths_to_load:
		ResourceLoader.load_threaded_request(path)

# --- 核心的 _process 循环 ---
func _process(_delta: float) -> void:
	if current_state != State.LOADING:
		return

	var paths_to_check = loading_task.get("paths", [])
	if paths_to_check.is_empty():
		return

	var all_loaded = true
	var cumulative_progress = 0.0
	
	# 1. 检查所有任务的状态
	for path in paths_to_check:
		var progress_array: Array = []
		var status = ResourceLoader.load_threaded_get_status(path, progress_array)
		
		match status:
			ResourceLoader.THREAD_LOAD_IN_PROGRESS:
				all_loaded = false
				if !progress_array.is_empty():
					cumulative_progress += progress_array[0]
			
			ResourceLoader.THREAD_LOAD_LOADED:
				cumulative_progress += 1.0
			
			ResourceLoader.THREAD_LOAD_FAILED, ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
				printerr("场景加载失败: " + path)
				loading.text = "加载失败: " + path.get_file()
				current_state = State.FAILED
				loading_task.clear()
				return

	# 2. 更新UI
	var total_progress = (cumulative_progress / paths_to_check.size()) * 100.0
	progress_bar.value = total_progress
	loading.text = "加载中: %d%%" % total_progress

	# 3. 如果所有任务都已完成
	if all_loaded:
		# a. 获取所有已加载的资源
		var loaded_resources: Array[PackedScene] = []
		for path in paths_to_check:
			loaded_resources.append(ResourceLoader.load_threaded_get(path))

		# b. 根据任务类型执行不同的构建和切换逻辑
		_build_and_switch_scenes(loaded_resources)
		
		# c. 重置状态
		current_state = State.IDLE
		loading_task.clear()
		self.visible = false

# --- 场景构建和切换函数 ---
func _build_and_switch_scenes(resources: Array[PackedScene]):
	if resources.is_empty(): return

	var task_type = loading_task.get("type", "")
	
	match task_type:
		"change_scene":
			get_tree().change_scene_to_packed(resources[0])
		
		"load_level":
			var father_viewport = loading_task.get("father")
			var player_node = loading_task.get("player")
			
			if is_instance_valid(father_viewport) and is_instance_valid(player_node):
				var new_level_instance = resources[0].instantiate()
				father_viewport.add_child(new_level_instance)
				
				if new_level_instance:
					player_node.global_position = new_level_instance.player_pos
					player_node.rotation=new_level_instance.player_angle
				else:
					print("在新的关卡场景中未找到 'PlayerStart' 节点，玩家位置未更新。")
				
				print("新关卡加载并添加成功！")
			else:
				printerr("load_level 失败：父节点或玩家节点已失效。")

		"to_main":
			var old_scene = get_tree().current_scene
			
			var parent_scene_instance = resources[0].instantiate()
			var child_scene_instance = resources[1].instantiate()
			
			var sub_viewport = parent_scene_instance.get_child(0).get_child(0)
			if sub_viewport:
				sub_viewport.add_child(child_scene_instance)
				
				get_tree().root.add_child(parent_scene_instance)
				parent_scene_instance.player.global_position = child_scene_instance.player_pos
				parent_scene_instance.player.rotation=child_scene_instance.player_angle
				get_tree().current_scene = parent_scene_instance
				
				if old_scene and is_instance_valid(old_scene):
					old_scene.queue_free()
				
				print("主场景组合并切换成功！")
			else:
				printerr("在父场景中找不到容器节点，切换失败。")
