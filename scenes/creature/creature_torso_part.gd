extends Node3D


@export var next_part: Node3D = null
@export var movement_speed: int = 10
@export var max_separation: float = 7
@export var movement_offset: float = 20.0

var _previous_position: Vector3 = Vector3()

@onready var step_target_container = get_node("StepTargetContainer")


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	_chained_movement(delta)
	_update_offset()


func _chained_movement(delta: float) -> void:
	if next_part:
		var dist_to_next: float = (
			global_position.distance_squared_to(next_part.global_position)
		)
		if dist_to_next > max_separation:
			var movement_offset: Vector3 = (
				global_position.direction_to(next_part.global_position) * delta * movement_speed
			)
			global_position += movement_offset
			look_at(next_part.global_position)
			rotation_degrees.y += 180


func _update_offset() -> void:
	var velocity: Vector3 = global_position - _previous_position
	step_target_container.global_position = global_position + velocity * movement_offset
	_previous_position = global_position
