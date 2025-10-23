extends Node3D

@onready var sub_viewport: SubViewport = %SubViewport
@onready var player: CharacterBody3D = %Player
@onready var color_rect: ColorRect = %ColorRect
const NOISE = preload("uid://dkt7u8bg5j62s")
var audio_player:AudioStreamPlayer


func appear_glitch():
	color_rect.visible=true
	audio_player=AD.play(NOISE,false,false,-10)

func disappear_glitch():
	color_rect.visible=false
	AD.destory(audio_player)
