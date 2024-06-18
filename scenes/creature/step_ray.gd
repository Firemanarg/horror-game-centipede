extends RayCast3D


@export var step_target: Node3D = null


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	var hit_point: Vector3 = get_collision_point()
	if is_colliding():
		step_target.global_position = hit_point

