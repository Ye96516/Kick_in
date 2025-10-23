extends Node

var socre_occer:bool
signal occer(next_path:String,current_scene:Node,level:int)

func occer_emit(next_path:String,current_scene:Node,level:int):
	socre_occer=true
	occer.emit(next_path,current_scene,level)
