extends CanvasLayer

@onready var sub_viewport: SubViewport = %SubViewport
@onready var player: Player = %Player
@onready var next: Button = %Next

func _ready() -> void:
	self.visible=false
	Global.occer.connect(ball_occer)

#根据路径加载场景，销毁当前场景，并且初始化玩家位置
func ball_occer(file_path:String,current_scence:Node,_l:int):
	self.visible=true
	await next.pressed
	CS.load_level(file_path,current_scence,sub_viewport,player)
	self.visible=false
