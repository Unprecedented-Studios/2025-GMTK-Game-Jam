extends Node

@onready var timer = $Timer

var _shooting = false;

func _ready():
	WaveState.started.connect(_on_wave_start);

func _on_beat(beat_counter, note, count):
	var projectile = preload("res://scenes/projectiles/basic.tscn")
	var new_projectile = projectile.instantiate();
	get_parent().add_child(new_projectile)

func _on_wave_start():
	Looper.beat.connect(_on_beat);
	_shooting = true;
	
func _on_wave_stop():
	Looper.beat.disconnect(_on_beat);
	_shooting = false;
