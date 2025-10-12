class_name Ball extends CharacterBody3D
 
@export var death_instance:int=50

func _ready() -> void:
	set_physics_process(false)

func throw(v:Vector3):
	reparent(get_tree().current_scene)
	set_physics_process(true)
	self.velocity=v

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	death_sentence()
	
	move_and_slide()

func death_sentence():
	if abs(global_position.x)>death_instance:
		queue_free()
	if abs(global_position.y)>death_instance:
		queue_free()
	if abs(global_position.z)>death_instance:
		queue_free()
		
