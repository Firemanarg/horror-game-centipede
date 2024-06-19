extends Node3D


const MonsterScene = preload("res://scenes/monster/monster.tscn")

var monster: Node3D = null

@onready var monster_spawn: Node3D = get_node("MonsterSpawn")
@onready var traps: Node3D = get_node("Traps")
@onready var player: CharacterBody3D = get_node("Player")
@onready var level_menu: CanvasLayer = get_node("LevelMenu")


func _ready() -> void:
	pass
	_connect_traps()


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	pass


func _connect_traps() -> void:
	for trap in traps.get_children():
		trap.triggered.connect(_on_trap_triggered.bind(trap))


func _on_trap_triggered(trap) -> void:
	if not monster:
		monster = MonsterScene.instantiate()
		monster.target = player
		add_child(monster)
		monster.global_position = monster_spawn.global_position
		monster.rotate_y(deg_to_rad(180))
