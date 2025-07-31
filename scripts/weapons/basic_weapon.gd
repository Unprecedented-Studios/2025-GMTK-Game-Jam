extends Node

@onready var timer = $Timer

func _ready():
	Looper.beat.connect(_on_beat);
	timer.start();

func _on_beat(beat_counter, note, count):
	var projectile = preload("res://scenes/projectiles/basic.tscn")
	var new_projectile = projectile.instantiate();
	get_parent().add_child(new_projectile)
