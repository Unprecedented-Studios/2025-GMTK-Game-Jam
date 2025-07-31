class_name WaveInfo
extends Node

class WaveElement:
	var ID: int
	var count: int

@onready var enemy_list = %EnemyList

var _enemyCount: Array[WaveElement] = []

func createWave(level):
	for i in range(0,enemy_list.types.size()):
		if level >= enemy_list.firstWave[i]:
			var element = WaveElement.new()
			element.ID = i
			element.count = level * enemy_list.levelMultiplier[i]
			_enemyCount.push_back(element)

func pick_random_enemy():
	if _enemyCount.size() == 0:
		return null;
		
	var selected = _enemyCount.pick_random();
	var type = enemy_list.types[selected.ID];
	selected.count -= 1;
	if selected.count == 0:
		var i = _enemyCount.find(selected);
		_enemyCount.remove_at(i)
	return type;

func clear():
	_enemyCount.clear();

var complete: bool:
	get: 
		return _enemyCount.size() == 0;
