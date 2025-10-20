class_name Ball extends RigidBody3D
 
@export var death_instance:int=50

func _ready() -> void:
	disabled()

func throw(v:Vector3):
	reparent(get_tree().current_scene)
	enabled()
	apply_central_impulse(v)

func _physics_process(_delta: float) -> void:
	death_sentence()
	
func death_sentence():
	if abs(global_position.x)>death_instance:
		queue_free()
	if abs(global_position.y)>death_instance:
		queue_free()
	if abs(global_position.z)>death_instance:
		queue_free()
		
func disabled():
	set_physics_process(false)
	$CollisionShape3D.disabled=true
	gravity_scale=0.0

func enabled():
	set_physics_process(true)
	$CollisionShape3D.disabled=false
	gravity_scale=1.0
