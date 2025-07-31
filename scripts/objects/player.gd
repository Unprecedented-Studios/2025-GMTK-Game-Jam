extends StaticBody2D
@export var health:float = 500

@onready var health_bar = %Healthbar

func _ready():
	health_bar.max_value = health;
	health_bar.value = health;

func take_damage(info: DamageInfo):
	health -= info.damage;
	health_bar.value = health;
	if (health <= 0):
		queue_free();
