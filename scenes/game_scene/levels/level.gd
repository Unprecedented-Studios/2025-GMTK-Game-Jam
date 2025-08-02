extends Node

signal level_lost

var level_state : LevelState

func _on_lose_button_pressed() -> void:
	level_lost.emit()

func _ready() -> void:
	Looper.count_off.connect(count_off)

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
		


func _on_player_area_died():
	level_lost.emit();
