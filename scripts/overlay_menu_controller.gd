extends Node

## Node for opening a pause menu when detecting a 'ui_cancel' event.

@export var pause_menu_packed : PackedScene
@export var lost_menu_packed : PackedScene
@export_file("*.tscn") var main_menu_scene : String

@export var focused_viewport : Viewport

#from Maaack
func _try_connecting_signal_to_node(node : Node, signal_name : String, callable : Callable) -> void:
	if node.has_signal(signal_name) and not node.is_connected(signal_name, callable):
		node.connect(signal_name, callable)

func _unhandled_input(event : InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if not focused_viewport:
			focused_viewport = get_viewport()
		var _initial_focus_control = focused_viewport.gui_get_focus_owner()
		var current_menu = pause_menu_packed.instantiate()
		get_tree().current_scene.call_deferred("add_child", current_menu)
		await current_menu.tree_exited
		if is_inside_tree() and _initial_focus_control:
			_initial_focus_control.grab_focus()


func _on_level_test_level_lost():
	if lost_menu_packed:
		var instance = lost_menu_packed.instantiate()
		get_tree().current_scene.add_child(instance)
		_try_connecting_signal_to_node(instance, &"restart_pressed", _reload_level)
		_try_connecting_signal_to_node(instance, &"main_menu_pressed", _load_main_menu)
	else:
		_reload_level()

func _reload_level():
	SceneLoader.reload_current_scene()

func _load_main_menu():
	Looper.reset_music()
	get_tree().paused = false;
	SceneLoader.load_scene(main_menu_scene)
