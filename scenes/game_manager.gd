extends Node


var current_scene = null


func _ready() -> void:
	get_tree().change_scene_to_file("res://scenes/level/main.tscn")
	current_scene = get_tree().current_scene as Node3D


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	pass

