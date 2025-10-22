extends Node3D

@onready var sub_viewport: SubViewport = %SubViewport
@onready var player: CharacterBody3D = %Player
@onready var color_rect: ColorRect = %ColorRect
const NOISE = preload("uid://dkt7u8bg5j62s")
var audio_player:AudioStreamPlayer


#根据路径加载场景，销毁当前场景，并且初始化玩家位置
func to_next_level(file_path:String,current_scence:Node):
	current_scence.queue_free()
	await current_scence.tree_exited
	var level:PackedScene=load(file_path)
	sub_viewport.add_child(level.instantiate())
	player.global_position=level.player_pos

func appear_glitch():
	color_rect.visible=true
	audio_player=AD.play(NOISE)

func disappear_glitch():
	color_rect.visible=false
	AD.destory(audio_player)
