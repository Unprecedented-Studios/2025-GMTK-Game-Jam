extends Node

# Wave Changes
signal started 
signal complete

@onready var currentWave = %CurrentWave
	
func start_wave():
	emit_signal("started");

func get_enemy() -> PackedScene:
	var enemy_picked = currentWave.pick_random_enemy()
	if currentWave.complete:
		emit_signal("complete")
	return enemy_picked
