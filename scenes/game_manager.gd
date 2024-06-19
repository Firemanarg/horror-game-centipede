extends Node


enum ContextID {
	MAIN_MENU,
	LEVEL
}

var context_data: Dictionary = {
	ContextID.MAIN_MENU: {
		"id": ContextID.MAIN_MENU,
		"packed_scene": preload("res://scenes/gui/main_menu/main_menu.tscn"),
		"scene": "res://scenes/gui/main_menu/main_menu.tscn", # Scene path, if no packed
		"ready_method": main_menu_context_ready_handler,
		"process_method": _default_context_process_handler,
	},
	ContextID.LEVEL: {
		"id": ContextID.LEVEL,
		"packed_scene": preload("res://scenes/level/level.tscn"),
		"scene": "res://scenes/level/level.tscn", # Scene path, if no packed
		"ready_method": level_context_ready_handler,
		"process_method": level_context_process_handler,
	},
}

#var current_scene = null
#var current_context: ContextID = ContextID.MAIN_MENU
#
#var _current_context_ready_method: Callable
var current_context: Dictionary = context_data[ContextID.MAIN_MENU]


func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func _ready() -> void:
	current_context["ready_method"].call(get_tree().current_scene)
	pass
	#_set_context(ContextID.MAIN_MENU)
	#var level_menu: CanvasLayer = get_tree().current_scene.level_menu
	#level_menu.button_pressed.connect(_on_level_menu_button_pressed)


func _process(delta: float) -> void:
	current_context["process_method"].call(get_tree().current_scene, delta)


func _physics_process(delta: float) -> void:
	pass


#region CONTEXT RELATED STUFF
func _default_context_ready_handler(_context_scene) -> void:
	pass


func _default_context_process_handler(_context_scene, _delta: float) -> void:
	pass


func _set_context(new_context: ContextID) -> void:
	current_context = context_data[new_context]
	if not current_context.get("ready_method"):
		current_context["ready_method"] = _default_context_ready_handler
	if not current_context.get("process_method"):
		current_context["process_method"] = _default_context_process_handler
	if current_context.get("packed_scene"):
		get_tree().change_scene_to_packed(current_context["packed_scene"])
	else:
		get_tree().change_scene_to_file(current_context["scene"])
	await get_tree().process_frame # Await for scene change - step 1
	await get_tree().process_frame # Await for scene change - step 2
	current_context["ready_method"].call(get_tree().current_scene)
#endregion


#region MAIN_MENU-CONTEXT
func main_menu_context_ready_handler(main_menu) -> void:
	var gui: CanvasLayer = main_menu.get_node("MainMenuGUI")
	gui.button_pressed.connect(_on_main_menu_button_pressed)


func _on_main_menu_button_pressed(action: String) -> void:
	if action == "play":
		_set_context(ContextID.LEVEL)
	elif action == "quit":
		get_tree().quit()
#endregion


#region LEVEL-CONTEXT
func level_context_ready_handler(level) -> void:
	level.level_menu.button_pressed.connect(_on_level_menu_button_pressed)
	get_tree().paused = false



func level_context_process_handler(level, _delta: float) -> void:
	_check_pause()


func _check_pause() -> void:
	var pressed_pause: bool = Input.is_action_just_pressed("pause")
	if pressed_pause:
		var level_menu: CanvasLayer = get_tree().current_scene.level_menu
		var is_paused: bool = get_tree().paused
		if is_paused:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			get_tree().paused = false
			level_menu.hide_menu()
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			get_tree().paused = true
			level_menu.show_menu()


func _on_level_menu_button_pressed(action: String) -> void:
	if action == "resume":
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		get_tree().paused = false
		get_tree().current_scene.level_menu.hide_menu()
	elif action == "restart":
		_set_context(ContextID.LEVEL)
	elif action == "quit":
		_set_context(ContextID.MAIN_MENU)
#endregion


