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

var damage: float
var type: damage_types
var effects: effect_types
