@tool
extends Node3D


const _TorsoPartScene: PackedScene = preload("res://scenes/creature/creature_torso_part.tscn")
const _HeadScene: PackedScene = preload("res://scenes/creature/creature_head.tscn")

@export var body_size: int = 5:
	set = set_body_size
@export var target: Node3D = null
@export var body_separation: float = 0.5
@export var movement_speed: int = 5
@export var step_distance: float = 30
@export var movement_offset: float = 30
@export var max_height: float = 5.0


func _ready() -> void:
	update_body_size()


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	pass


func set_body_size(new_size: int) -> void:
	body_size = new_size
	if is_inside_tree():
		update_body_size()


func update_body_size() -> void:
	for child in get_children():
		child.queue_free()
	var head: Node3D = _HeadScene.instantiate()
	add_child(head)
	head.rotation_degrees.y = 180
	head.target = target
	head.max_height = max_height
	var prev_torso: Node3D = head
	for i in body_size:
		var torso: Node3D = _TorsoPartScene.instantiate()
		torso.next_part = prev_torso
		torso.max_separation = body_separation
		torso.movement_speed = movement_speed
		torso.movement_offset = movement_offset
		add_child(torso)
		torso.position.z = prev_torso.position.z - body_separation
		torso.rotation_degrees.y = 180
		torso.get_node("LeftFootIKTarget").step_distance = step_distance
		torso.get_node("RightFootIKTarget").step_distance = step_distance
		prev_torso = torso

