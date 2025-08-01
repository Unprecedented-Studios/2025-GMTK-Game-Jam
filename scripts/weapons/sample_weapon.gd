extends Node

var _shooting = false;
var _multiShot = 0;

@export var multi_yOffset = 23;

@onready var projectile = preload("res://scenes/projectiles/sample_projectile.tscn")
var _measure_length = 0.5;

func _ready():
	Looper.sample_triggered.connect(_on_sample_attack)

func _on_sample_attack(damage_info:DamageInfo):
	var new_projectile:SampleProjectile = projectile.instantiate();
	get_parent().add_child(new_projectile)
	new_projectile.set_damage_info(damage_info)
	
