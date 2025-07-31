extends Node

@onready var timer = $Timer

func _ready():
	timer.timeout.connect(_on_timer_timeout);
	timer.start();

func _on_timer_timeout():
	var projectile = preload("res://scenes/projectiles/basic.tscn")
	var new_projectile = projectile.instantiate();
	get_parent().add_child(new_projectile)
