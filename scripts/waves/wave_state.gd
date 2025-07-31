extends Node

# Wave Changes
signal started 
signal complete

var waveCount = 0;

@export var timeBetweenWaves: float = 5;

@onready var currentWave = %CurrentWave

func start_wave():
	waveCount += 1
	currentWave.createWave(waveCount)
	emit_signal("started");

func get_enemy() -> PackedScene:
	if currentWave.complete:
		endWave();
		return;
	var enemy_picked = currentWave.pick_random_enemy()
	return enemy_picked

func endWave():
	emit_signal("complete");
	if (timeBetweenWaves != 0):		
		get_tree().create_timer(timeBetweenWaves).timeout.connect(start_wave)

	
