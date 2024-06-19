extends CanvasLayer


signal button_pressed(action)

const AnimationDuration: float = 1.5
const MaxBlurAmount: float = 2.0

#var _tween: Tween = null


func _ready() -> void:
	hide_menu()
	pass


func _process(delta: float) -> void:
	pass
	#_set_blur_amount(_blur_amount)


func _physics_process(delta: float) -> void:
	pass


func show_menu() -> void:
	_set_blur_amount(MaxBlurAmount)
	_show_buttons()
	#if not animated:
		#_set_blur_amount(MaxBlurAmount)
		#return
	#if _tween:
		#_tween.kill()
		#_tween = null
	##var _tween: Tween = get_tree().create_tween()
	#_tween = get_tree().create_tween()
	##_tween.set_ease(Tween.EASE_OUT)
	##_tween.set_trans(Tween.TRANS_CUBIC)
	##_tween.tween_method(
		##_set_blur_amount,
		##_get_blur_amount(),
		##2.0,
		##AnimationDuration
	##)
	#_tween.tween_property(self, "_blur_amount", 2.0, AnimationDuration)
	#_tween.play()


func hide_menu() -> void:
	_set_blur_amount(0.0)
	_hide_buttons()
	#if not animated:
		#_set_blur_amount(0.0)
		#return
	#if _tween:
		#_tween.kill()
		#_tween = null
	##var _tween: Tween = get_tree().create_tween()
	#_tween = get_tree().create_tween()
	##_tween.set_ease(Tween.EASE_IN)
	##_tween.set_trans(Tween.TRANS_CUBIC)
	##_tween.tween_method(
		##_set_blur_amount,
		##_get_blur_amount(),
		##0.0,
		##AnimationDuration
	##)
	#_tween.tween_property(self, "_blur_amount", 0.0, AnimationDuration)
	#_tween.play()
#
#
func _show_buttons() -> void:
	$CanvasLayerButtons.visible = true
	#print("Showing buttons")
	#var tween: Tween = get_tree().create_tween()
	#tween.set_ease(Tween.EASE_OUT)
	#tween.set_trans(Tween.TRANS_CUBIC)
	#tween.tween_property(
		#$CanvasLayerButtons,
		#"offset:y",
		#10.0, 2.0
	#)
	#tween.play()
#
#
func _hide_buttons() -> void:
	$CanvasLayerButtons.visible = false
	#print("Hiding buttons")
	#var tween: Tween = get_tree().create_tween()
	#tween.set_ease(Tween.EASE_IN)
	#tween.set_trans(Tween.TRANS_CUBIC)
	#tween.tween_property(
		#$CanvasLayerButtons,
		#"offset:y",
		#-800, 2.0
	#)
	#tween.play()


func _set_blur_amount(amount: float) -> void:
	print("Setting blur to ", amount)
	$MarginContainer/ColorRect.material.set_shader_parameter("lod", amount)


func _get_blur_amount() -> float:
	return $MarginContainer/ColorRect.material.get_shader_parameter("lod")


func _on_button_resume_pressed() -> void:
	button_pressed.emit("resume")


func _on_button_restart_pressed() -> void:
	button_pressed.emit("restart")


func _on_button_quit_pressed() -> void:
	button_pressed.emit("quit")
