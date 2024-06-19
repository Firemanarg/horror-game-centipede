extends CanvasLayer


signal button_pressed(action)

const AnimationDuration: float = 1.5
const MaxBlurAmount: float = 2.0

#var _tween: Tween = null


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	pass


func _on_button_play_pressed() -> void:
	button_pressed.emit("play")


func _on_button_quit_pressed() -> void:
	button_pressed.emit("quit")
