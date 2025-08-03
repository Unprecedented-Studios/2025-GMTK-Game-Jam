extends Node

# Wave Changes
signal started(int)
signal complete(int)
signal scoreChange(int)

var waveCount = 0;
var score = 0;
var _enemyList: Dictionary = {}

@export var timeBetweenWaves: float = 2;

@onready var wave_timer = %WaveTimer
@onready var currentWave = %CurrentWave
var game_state:GameState
func _ready():
	wave_timer.wait_time = timeBetweenWaves;
	
func reset_game():
	wave_timer.stop();
	waveCount = 0
	score = 0;
	_enemyList = {}
	
	game_state = GameState.get_or_create_state()

	if game_state.playerData.has("score"):
		score = game_state.playerData.score
		scoreChange.emit(score)
	if game_state.playerData.has("lastWave"):
		waveCount = game_state.playerData.lastWave
	_enemyList = {}
	scoreChange.emit(score)
	wave_timer.stop();
	
func start_wave():
	waveCount += 1
	currentWave.createWave(waveCount)
	print("Wave %s Started" % [waveCount])
	started.emit(waveCount);

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

func score_enemy(points):
	score += points
	scoreChange.emit(score)

func endWave():
	if currentWave.complete && _enemyList.is_empty():
		print("Wave Completed")
		complete.emit(waveCount);
		if (timeBetweenWaves != 0):
			wave_timer.start();
	
