
extends CanvasItem

@onready var progress_bar: ProgressBar = %ProgressBar
@onready var loading: Label = %Loading

const z:=4095
var _current_loading_path: String = ""

enum state{normal,remove_add,add_add}
var change_state=state.normal

var scene:PackedScene=null
var player:Player=null
var father:Viewport=null

var scenes_path:Array=[]
var scenes_array:Array=[]

func _ready() -> void:
	z_index=z
	visible=false

##切换场景
func change_scene(path: String):
	_current_loading_path = path
	self.visible=true
	change_state=state.normal
	# 开始异步加载
	ResourceLoader.load_threaded_request(path)

##移除场景并引入新场景
func load_level(path:String,current_scene:Node,father1:SubViewport,player1:Player):
	self.visible=true
	change_state=state.remove_add
	_current_loading_path = path
	current_scene.queue_free()
	await current_scene.tree_exited
	father=father1
	player=player1
	ResourceLoader.load_threaded_request(path)
	pass

func to_main(path:Array):
	_current_loading_path = path[0]
	scenes_path=path
	self.visible=true
	change_state=state.add_add
	ResourceLoader.load_threaded_request(path[0])

# 在_process中检查加载状态
func _process(_delta):
	print(_current_loading_path)
	if _current_loading_path.is_empty():
		return
	var progress: Array = []
	var status = ResourceLoader.load_threaded_get_status(_current_loading_path, progress)
	#print(status)
	match status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			# 可以在这里更新UI进度条，progress[0]是0.0到1.0的进度
			progress_bar.value=progress[0]*100
			print("加载中: ", progress[0] * 100, "%")
		ResourceLoader.THREAD_LOAD_LOADED:
			# 加载完成，获取资源并切换场景
			scene= ResourceLoader.load_threaded_get(_current_loading_path)
			#get_tree().change_scene_to_packed(scene)
			#_current_loading_path = ""
			#print(state)
			match change_state:
				
				state.normal:
					get_tree().change_scene_to_packed(scene)
					_current_loading_path = ""
					self.visible=false
					scene=null
				state.remove_add:
					var scene_ins:Node=scene.instantiate()
					father.add_child(scene_ins)
					player.global_position=scene_ins.player_pos
					_current_loading_path = ""
					self.visible=false
					scene=null
					player=null
					father=null
				state.add_add:
					scenes_array.append(scene.instantiate())
					if scenes_array.size()==2:
						scenes_array[0].subviewport.add_child(scenes_array[1])
						var s=PackedScene.new()
						s.pack(scenes_array[0])
						get_tree().change_scene_to_packed(s)
						print("f")
					if scenes_array.size()==1:
						ResourceLoader.load_threaded_request(scenes_array[1])
					pass
			# 重置状态
			
			
		ResourceLoader.THREAD_LOAD_FAILED:
			print("场景加载失败: ", _current_loading_path)
			loading.text="加载失败"
			_current_loading_path = ""
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			print(scene)
			print("资源无效")
			_current_loading_path = ""
