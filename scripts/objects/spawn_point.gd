class_name SpawnPoint
extends Marker2D

@onready var spawn_area = %SpawnArea

var _spawn_wait_list: Array[PackedScene] = [];

func spawn_enemy(enemy):
	if (spawn_area.get_overlapping_bodies().size() != 0):
		_spawn_wait_list.push_back(enemy)
		return;
	var enemy_spawn = enemy.instantiate();
	add_child(enemy_spawn)

func _on_spawn_area_body_exited(_body):
	if (_spawn_wait_list.size() > 0):
		spawn_enemy(_spawn_wait_list.pop_front())
