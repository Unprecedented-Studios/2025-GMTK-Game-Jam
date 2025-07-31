class_name  DamageInfo

enum damage_types {
	NORMAL,
	ELECTRIC,
	AIR,
	WATER,
	FIRE,
	EARTH
}

enum effect_types {
	SLOW,
	PIERCE,
	DOT
}

var damage: float = 1
var type: damage_types = damage_types.NORMAL;
var effects: Array[effect_types] = []
