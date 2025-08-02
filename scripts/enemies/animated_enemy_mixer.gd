extends Node2D

@export var bodyList:Array[Texture2D] = []
@export var legList:Array[Texture2D] = []

@onready var enemy_left_leg = %EnemyLeftLeg
@onready var enemy_right_leg = %EnemyRightLeg
@onready var enemy_body = %EnemyBody

func _ready():
	var texturePick = randi_range(0,bodyList.size()-1)
	
	enemy_body.texture = bodyList[texturePick];
	enemy_left_leg.texture = legList[texturePick];
	enemy_right_leg.texture = legList[texturePick];
	
