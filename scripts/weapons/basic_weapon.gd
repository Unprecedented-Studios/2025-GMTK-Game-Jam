extends Node

var _shooting = false;
var _multiShot = 0;

@export var multi_yOffset = 23;

@onready var projectile = preload("res://scenes/projectiles/basic.tscn")
var _measure_length = 0.5;

func _ready():
	GameStateController.started.connect(_on_wave_start);

func _fire_projectile(offset: Vector2 = Vector2(0,0) ):
	var new_projectile = projectile.instantiate();
	get_parent().add_child(new_projectile)
	new_projectile.position.y += offset.y

func _on_beat(_beat_counter,_note, _count):
	_measure_length = 0.5;
	if Looper.playing_drum_attack == Looper.drum_attacks.AOE:
		_measure_length = 1.0;
		if _note % 2 == 0:
			return

	_fire_projectile()

	match Looper.playing_lead_attack:
		Looper.lead_attacks.FAST:
			_multiShot = 0
			get_tree().create_timer(_measure_length/4.0).timeout.connect(_multiShot_beat)
		Looper.lead_attacks.MULTI:
			_fire_projectile(Vector2(0,multi_yOffset))
			_fire_projectile(Vector2(0,-multi_yOffset))

func _on_wave_start(waveID: int):
	if !Looper.beat.is_connected(_on_beat):
		Looper.beat.connect(_on_beat);
	_shooting = true;
	
func _on_wave_stop():
	Looper.beat.disconnect(_on_beat);
	_shooting = false;

func _multiShot_beat():
	_multiShot += 1
	_fire_projectile(Vector2(0, -10 * _multiShot))
	if (_multiShot < 3):
		get_tree().create_timer(_measure_length/4.0).timeout.connect(_multiShot_beat)
