extends CharacterBody3D


@export var target: Node3D = null
@export var frequency: float = 2.0
@export var amplitude: float = 10.0
@export var max_speed: float = 5.0

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var _total_time: float = 0.0
var _floor_normal: Vector3 = Vector3.UP.normalized()

func _physics_process(delta: float) -> void:
	_total_time += delta
	if not target:
		return

	_update_floor_normal()
	_seek_target(delta)
	#_apply_sin_offset(delta)

	move_and_slide()


func set_target(new_target: Node3D) -> void:
	target = new_target
	set_physics_process(not target == null)


func _seek_target(delta: float) -> void:
	var direction: Vector3 = global_position.direction_to(target.global_position)
	var sin_offset: Vector3 = direction.rotated(_floor_normal, sin(_total_time * frequency)) * amplitude
	#var perpendicular_axis: Vector3 = Plane(
		#global_position, global_position + direction, _floor_normal
	#)
	#var sin_offset: Vector3 = (direction * sin(_total_time * frequency))
	#var sin_offset: Vector3 = direction.rotated(_floor_normal, sin(_total_time * frequency))
	#var sin_offset: Vector3 = Vector3.FORWARD.rotated(_floor_normal, sin(_total_time * frequency))
	#direction += sin_offset.normalized() * deg_to_rad(amplitude)
	#direction = direction.normalized()
	#direction = direction.rotated(_floor_normal, sin(_total_time * frequency) * deg_to_rad(amplitude))
	#var sin_offset: Vector3 = Vector3.ONE * amplitude * delta * sin(_total_time * frequency)
	#direction *= sin_offset
	if not is_on_floor():
		velocity.y -= gravity * delta
	#var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * max_speed
		velocity.z = direction.z * max_speed
	else:
		velocity.x = move_toward(velocity.x, 0, max_speed)
		velocity.z = move_toward(velocity.z, 0, max_speed)
	#velocity += direction * sin_offset * deg_to_rad(amplitude)
	#velocity += perpendicular_axis * sin(_total_time * frequency) * deg_to_rad(amplitude)
	velocity += sin_offset
	velocity = velocity.normalized() * max_speed
	$VisualHead.look_at(target.global_position, _floor_normal, true)
	up_direction = _floor_normal


func _update_floor_normal() -> void:
	var new_floor_normal: Vector3 = get_floor_normal()
	if not new_floor_normal.is_zero_approx():
		_floor_normal = new_floor_normal


func _apply_sin_offset(delta: float) -> void:
	var sin_offset: Vector3 = velocity * amplitude * delta * sin(_total_time * frequency)
	#velocity = lerp(velocity, velocity + sin_offset, delta)
	velocity += sin_offset
