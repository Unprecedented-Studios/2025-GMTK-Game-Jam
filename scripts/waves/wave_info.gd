class_name WaveInfo
extends Node

class WaveElement:
	var enemy: PackedScene
	var count: int

@onready var enemy_list = %EnemyList

func pick_random_enemy():
	return enemy_list.enemyTypes.pick_random();
	
var complete: bool:
	get: 
		return false;
