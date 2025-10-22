extends Node

var socre_occer:bool
signal occer(level:int)

func occer_emit(level:int):
	socre_occer=true
	occer.emit(level)
