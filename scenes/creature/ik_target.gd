extends Node3D


#const StepSoundEffects: Array = [
	#preload("res://assets/audio/sounds/monster_step_1.wav"),
	#preload("res://assets/audio/sounds/monster_step_2.wav"),
	#preload("res://assets/audio/sounds/monster_step_3.wav"),
#]

#@export var audio_player: AudioStreamPlayer3D = null

@export var parallel_target: Node3D = null
@export var step_target: Node3D = null
@export var step_distance: float = 3.0

var is_stepping: bool = false


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	if not step_target or not parallel_target:
		return
	var dist: float = global_position.distance_squared_to(step_target.global_position)
	if not parallel_target.is_stepping and dist > step_distance:
		step()


func step() -> void:
	var target_position: Vector3 = step_target.global_position
	var half_way: Vector3 = (global_position + step_target.global_position) / 2.0
	is_stepping = true

	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", half_way + owner.basis.y, 0.1)
	tween.tween_property(self, "global_position", target_position, 0.1)
	tween.tween_callback(func(): is_stepping = false)
	#await tween.finished
	#play_step_sound()
#
#
#func play_step_sound() -> void:
	#if not audio_player:
		#return
	#audio_player.set_stream(
		#StepSoundEffects[randi() % (StepSoundEffects.size())]
	#)
	#audio_player.play()

