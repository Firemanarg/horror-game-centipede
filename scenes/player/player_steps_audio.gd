extends AudioStreamPlayer3D


const StepDelay: float = 0.05
const StepSounds: Array[AudioStreamWAV] = [
	preload("res://assets/audio/sounds/player_steps/player_step_01.wav"),
	preload("res://assets/audio/sounds/player_steps/player_step_02.wav"),
	preload("res://assets/audio/sounds/player_steps/player_step_03.wav"),
	preload("res://assets/audio/sounds/player_steps/player_step_04.wav"),
	preload("res://assets/audio/sounds/player_steps/player_step_05.wav"),
	preload("res://assets/audio/sounds/player_steps/player_step_06.wav"),
	preload("res://assets/audio/sounds/player_steps/player_step_07.wav"),
	preload("res://assets/audio/sounds/player_steps/player_step_08.wav"),
	preload("res://assets/audio/sounds/player_steps/player_step_09.wav"),
	preload("res://assets/audio/sounds/player_steps/player_step_10.wav"),
]

@onready var player: CharacterBody3D = get_parent()
@onready var timer_step_delay: Timer = get_node("TimerStepDelay")


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	if _can_play_step_sound():
		if not playing:
			stream = StepSounds.pick_random()
			play()
	else:
		stop()


func _can_play_step_sound() -> bool:
	return (
		not player.velocity.is_zero_approx()
		and player.is_on_floor()
		and timer_step_delay.is_stopped()
		)


func _on_finished() -> void:
	timer_step_delay.start(StepDelay)
