extends StaticBody2D
@export var health:float = 500

@onready var health_bar = %Healthbar
@onready var wave_number_label = %WaveNumberLabel

func _ready():
	health_bar.max_value = health;
	health_bar.value = health;
	GameStateController.started.connect(_wave_started)

func take_damage(info: DamageInfo):
	health -= info.damage;
	health_bar.value = health;
	#if (health <= 0):
		#queue_free();

func _wave_started():
	wave_number_label.text = "%s" % GameStateController.waveCount
