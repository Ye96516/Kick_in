extends Node3D

@onready var sub_viewport: SubViewport = %SubViewport
@onready var player: CharacterBody3D = %Player
@onready var color_rect: ColorRect = %ColorRect
const NOISE = preload("uid://dkt7u8bg5j62s")
var audio_player:AudioStreamPlayer

#func _ready() -> void:
	#Global.occer.connect(ball_occer)

#根据路径加载场景，销毁当前场景，并且初始化玩家位置
#func ball_occer(file_path:String,current_scence:Node,_l:int):
	#CS.load_level(file_path,current_scence,sub_viewport,player)

func appear_glitch():
	color_rect.visible=true
	audio_player=AD.play(NOISE,false,false,-10)

func disappear_glitch():
	color_rect.visible=false
	AD.destory(audio_player)
