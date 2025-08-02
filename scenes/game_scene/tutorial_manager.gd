extends Node
@export var tutorial_scenes : Array[PackedScene]
@export var tutorial_waves: Array[int]

@export var open_delay : float = 0.25
@export var auto_open : bool = false

var level_state: LevelState

func open_tutorials(wave:int = 0) -> void:
	if open_delay > 0.0:
		await get_tree().create_timer(open_delay, false).timeout
	var _initial_focus_control : Control = get_viewport().gui_get_focus_owner()
	for i  in range(0,tutorial_scenes.size()):
		var tutorial_scene = tutorial_scenes[i]
		var tutorial_wave = tutorial_waves[i]
		if wave == tutorial_wave && not level_state.tutorial_read.has(tutorial_scene):
			var tutorial_menu : OverlaidMenu = tutorial_scene.instantiate()
			if tutorial_menu == null:
				push_warning("tutorial failed to open %s" % tutorial_scene)
				return
			get_tree().current_scene.call_deferred("add_child", tutorial_menu)
			await tutorial_menu.tree_exited
			
			level_state.tutorial_read.set(tutorial_scene, true)
			GlobalState.save()
			if is_inside_tree() and _initial_focus_control:
				_initial_focus_control.grab_focus()
	if (wave == 0):
		GameStateController.reset_game()
		Looper.reset_music();
		Looper.start_playing()

func _ready() -> void:
	
	level_state = GameState.get_level_state('DJ-De-Fintz')
	
	GameStateController.started.connect(open_tutorials)
	open_tutorials()
