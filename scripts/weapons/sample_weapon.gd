extends Node


@onready var projectile = preload("res://scenes/projectiles/sample_projectile.tscn")

func _ready():
	Looper.sample_triggered.connect(_on_sample_attack)

func _on_sample_attack(damage_info:DamageInfo, damage_mod:float):
	var new_projectile:SampleProjectile = projectile.instantiate();
	get_parent().add_child(new_projectile)
	new_projectile.set_damage_info(damage_info)
	new_projectile.damage = damage_info.damage *damage_mod
	
