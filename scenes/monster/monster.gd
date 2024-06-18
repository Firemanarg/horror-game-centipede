extends Node3D


@export var target: Node3D = null


func _ready() -> void:
	$CreatureHead.set_target(target)


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	pass

