extends Node3D


const RayLengthMultiplier: int = 10

var frequency: float = 1.5
var amplitude: float = 10.0
@export var max_speed: float = 5.0
@export var max_height: float = 5.0
@export var target: Node3D = null

var _prev_normal: Vector3 = Vector3.UP
var _prev_center: Vector3 = Vector3.ZERO
var _total_time: float = 0.0


func _ready() -> void:
	_update_rays_length()


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	_total_time += delta
	_update_align(delta)
	#_seek_target(delta)


func set_target(new_target: Node3D) -> void:
	target = new_target
	set_physics_process(not target == null)


func _update_rays_length() -> void:
	for ray in $Rays.get_children() as Array[RayCast3D]:
		ray.target_position.y = -max_height * RayLengthMultiplier


func _seek_target(delta: float) -> void:
	if target == null:
		return
	var offset: Vector3 = target.global_position - global_position
	var extra_offset: Vector3 = offset.normalized() * amplitude * delta * cos(_total_time * frequency)
	#global_position += offset.normalized() * max_speed * delta
	#position += extra_offset
	extra_offset = extra_offset.rotated(_prev_normal, deg_to_rad(90))
	#position = lerp(position, position + extra_offset, delta) # DEBUG
	$VisualHead.look_at(target.global_position, _prev_normal, true)


func _align_surface(normal: Vector3, center_point: Vector3) -> void:
	var scale_backup: Vector3 = scale
	basis.y = normal
	basis.x = -basis.z.cross(normal)
	#position = center_point + normal.normalized() * max_height
	basis = basis.orthonormalized()
	scale = scale_backup


func _update_align(delta: float) -> void:
	var has_reachable_floor: bool = false
	var average_normal: Vector3 = Vector3.ZERO
	var average_point: Vector3 = Vector3.ZERO
	var colliding_ray_count: int = $Rays.get_child_count()
	for ray in $Rays.get_children() as Array[RayCast3D]:
		if not ray.is_colliding():
			continue
		has_reachable_floor = true
		average_normal += ray.get_collision_normal()
		average_point += ray.get_collision_point()
	if not has_reachable_floor:
		return
	average_normal = (average_normal / colliding_ray_count).normalized()
	average_point /= colliding_ray_count
	_align_surface(
		lerp(_prev_normal, average_normal, 0.5),
		lerp(_prev_center, average_point, 0.5)
	)
	_prev_normal = average_normal
	_prev_center = average_point

	#var scale_backup: Vector3 = scale
	#var new_basis: Basis = basis
	#new_basis.y = average_normal
	#new_basis.x = -new_basis.z.cross(average_normal)
	#new_basis = new_basis.orthonormalized()
	#basis = new_basis
	#scale = scale_backup
	#position = average_point + average_normal.normalized() * max_height
