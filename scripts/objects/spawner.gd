extends Node
@export var spawn_interval_min:float = 2;
@export var spawn_interval_max:float = 3;
@export var spawnPoints:Array[Marker2D] = []

func _ready():
	GameStateController.started.connect(_on_wave_start);
	
func spawn_something():
	var enemy = GameStateController.get_enemy()
	if enemy: 
		var spawn_point = spawnPoints.pick_random();
		spawn_point.spawn_enemy(enemy);
		get_tree().create_timer(randf_range(spawn_interval_min, spawn_interval_max)).timeout.connect(spawn_something)

func _on_wave_start():
	spawn_something()
