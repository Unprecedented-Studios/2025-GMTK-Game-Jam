extends Node

signal level_lost
signal level_won
signal level_won_and_changed(level_path : String)

@export_file("*.tscn") var next_level_path : String

var level_state : LevelState
func _on_lose_button_pressed() -> void:
	level_lost.emit()

func _on_win_button_pressed() -> void:
	if not next_level_path.is_empty():
		level_won_and_changed.emit(next_level_path)
	else:
		level_won.emit()

func open_tutorials() -> void:
	#%TutorialManager.open_tutorials()
	level_state.tutorial_read = true

func _ready() -> void:
	level_state = GameState.get_level_state(scene_file_path)
	Looper.count_off.connect(count_off)
	if false && not level_state.tutorial_read:
		open_tutorials()
	else:
		Looper.start_playing()

func _on_tutorial_button_pressed() -> void:
	open_tutorials()

func count_off(number:int):
	match number:
		1:
			$CountOff/CountOff1.play()
		2:
			$CountOff/CountOff2.play()
		3:
			$CountOff/CountOff3.play()
		4:
			$CountOff/CountOff4.play()
	$CountOff.modulate.a = 1
	$CountOff.text = "%s!" %number
	#var tween = get_tree().create_tween()
	#tween.tween_property($CountOff,"modulate",Color(1,1,1,0),.4)
		
func _process(delta: float) -> void:
	if $CountOff.modulate.a > 0.0:
		$CountOff.modulate.a -= delta
		
