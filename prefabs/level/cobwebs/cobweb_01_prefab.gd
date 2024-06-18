extends Node3D


signal triggered

@onready var particles = get_node("GPUParticles3D")
@onready var mesh = get_node("Mesh/CSGMesh3D")
@onready var audioplayer = get_node("AudioStreamPlayer3D")


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	pass


func _disappear() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(mesh, "transparency", 1.0, 2.0)
	tween.set_ease(Tween.EASE_OUT_IN)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.play()
	await tween.finished
	triggered.emit()
	queue_free()


func _on_area_3d_body_entered(body: Node3D) -> void:
	_disappear()
	audioplayer.play()
	await get_tree().create_timer(0.3).timeout
	particles.global_position = body.global_position
	particles.set_emitting(true)
