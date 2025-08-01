extends Node

# Wave Changes
signal started 
signal complete

var waveCount = 0;
var _enemyList: Dictionary = {}

@export var timeBetweenWaves: float = 5;

@onready var currentWave = %CurrentWave

func start_wave():
	waveCount += 1
	currentWave.createWave(waveCount)
	print("Wave %s Started" % [waveCount])
	emit_signal("started");

func get_enemy() -> CharacterBody2D:
	if currentWave.complete:
		return null;
	var enemy_picked = currentWave.pick_random_enemy()
	var enemy = enemy_picked.instantiate() as CharacterBody2D
	enemy.dying.connect(_check_last_enemy_died);
	_enemyList.set(enemy, 1)
	return enemy

func _check_last_enemy_died(enemy):
	_enemyList.erase(enemy)
	#print("Enemy Died %s left" % [_enemyList.size()])
	if _enemyList.is_empty():
		endWave();

func endWave():
	if currentWave.complete && _enemyList.is_empty():
		print("Wave Completed")
		emit_signal("complete");
		if (timeBetweenWaves != 0):		
			get_tree().create_timer(timeBetweenWaves).timeout.connect(start_wave)

	
